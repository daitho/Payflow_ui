import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../beneficiaries/domain/exception/beneficiary_exception.dart';
import '../../../beneficiaries/domain/model/beneficiary_contact.dart';
import '../../../beneficiaries/domain/service/beneficiary_service.dart';
import '../../domain/exception/transfer_exception.dart';
import '../../domain/model/transfer_draft_seed.dart';
import '../../domain/model/transfer_amount_input.dart';
import '../../domain/model/transfer_quote.dart';
import '../../domain/service/transfer_service.dart';
import '../../domain/service/transfer_amount_suggestions.dart';

class TransferViewModel extends ChangeNotifier {
  final TransferService _transfers;
  final BeneficiaryService _beneficiaries;
  final TransferDraftSeed seed;
  final Uuid _uuid;

  TransferViewModel({
    required TransferService transferService,
    required BeneficiaryService beneficiaryService,
    this.seed = const TransferDraftSeed(),
    Uuid uuid = const Uuid(),
  }) : _transfers = transferService,
       _beneficiaries = beneficiaryService,
       _uuid = uuid,
       _sentAmount = seed.sentAmount ?? 10,
       _sentCurrency = (seed.sentCurrency ?? 'EUR').toUpperCase();

  BeneficiaryContact? _beneficiary;
  TransferQuote? _quote;
  TransferFailure? _error;
  num _sentAmount;
  num _receivedAmount = 0;
  TransferAmountInput _amountInput = TransferAmountInput.sent;
  final String _sentCurrency;
  TransferFundingMethod _fundingMethod = TransferFundingMethod.card;
  bool _initializing = false;
  bool _quoting = false;
  bool _confirming = false;
  bool _disposed = false;
  int _quoteGeneration = 0;
  Timer? _quoteDebounce;
  String? _idempotencyKey;

  BeneficiaryContact? get beneficiary => _beneficiary;
  TransferQuote? get quote => _quote;
  TransferFailure? get error => _error;
  num get sentAmount => _sentAmount;
  num get receivedAmount => _receivedAmount;
  TransferAmountInput get amountInput => _amountInput;
  String get sentCurrency => _sentCurrency;
  List<num> get suggestedAmounts =>
      TransferAmountSuggestions.forCurrency(_sentCurrency);
  TransferFundingMethod get fundingMethod => _fundingMethod;
  bool get initializing => _initializing;
  bool get quoting => _quoting;
  bool get confirming => _confirming;
  bool get busy => _initializing || _quoting || _confirming;
  bool get hasUsableDestination =>
      _beneficiary?.destinationId?.trim().isNotEmpty == true;
  num get _activeAmount => _amountInput == TransferAmountInput.sent
      ? _sentAmount
      : _receivedAmount;
  bool get canContinue =>
      _beneficiary != null && hasUsableDestination && _activeAmount > 0 && !busy;

  String get initialAmountText {
    final value = _sentAmount.toDouble();
    return value == value.roundToDouble()
        ? value.toStringAsFixed(2)
        : value.toString();
  }

  Future<void> initialize() async {
    final id = seed.beneficiaryId?.trim();
    if (id == null || id.isEmpty || _initializing || _disposed) return;
    _initializing = true;
    _error = null;
    _notify();
    try {
      final contact = await _beneficiaries.get(id);
      if (_disposed) return;
      _beneficiary = contact;
      await _requestQuote();
    } on BeneficiaryException {
      if (!_disposed) _error = TransferFailure.notFound;
    } catch (_) {
      if (!_disposed) _error = TransferFailure.unexpected;
    } finally {
      if (!_disposed) {
        _initializing = false;
        _notify();
      }
    }
  }

  void selectBeneficiary(BeneficiaryContact contact) {
    if (_disposed) return;
    _beneficiary = contact;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void setSentAmount(String rawValue) {
    if (_disposed) return;
    _amountInput = TransferAmountInput.sent;
    _sentAmount = _parseAmount(rawValue);
    _receivedAmount = 0;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void setReceivedAmount(String rawValue) {
    if (_disposed) return;
    _amountInput = TransferAmountInput.received;
    _receivedAmount = _parseAmount(rawValue);
    _sentAmount = 0;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void selectSuggestedAmount(num amount) {
    if (_disposed || amount <= 0) return;
    _amountInput = TransferAmountInput.sent;
    _sentAmount = amount;
    _receivedAmount = 0;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void selectFundingMethod(TransferFundingMethod method) {
    if (_disposed || _fundingMethod == method) return;
    _fundingMethod = method;
    _notify();
  }

  Future<TransferQuote?> ensureQuote() async {
    _quoteDebounce?.cancel();
    final quoteMatchesInput = _amountInput == TransferAmountInput.sent
        ? _quote?.sentAmount == _sentAmount
        : _quote?.receivedAmount == _receivedAmount;
    if (_quote?.isUsable == true &&
        quoteMatchesInput &&
        _quote!.beneficiaryId == _beneficiary?.id) {
      return _quote;
    }
    await _requestQuote();
    return _quote?.isUsable == true ? _quote : null;
  }

  Future<ConfirmedTransfer?> confirm() async {
    if (_confirming || _disposed) return null;
    final currentQuote = await ensureQuote();
    if (currentQuote == null || _disposed) return null;
    _confirming = true;
    _error = null;
    _notify();
    try {
      final result = await _transfers.confirm(
        quoteId: currentQuote.id,
        idempotencyKey: _idempotencyKey ??= _uuid.v4(),
      );
      return _disposed ? null : result;
    } on TransferException catch (error) {
      if (!_disposed) _error = error.failure;
      return null;
    } catch (_) {
      if (!_disposed) _error = TransferFailure.unexpected;
      return null;
    } finally {
      if (!_disposed) {
        _confirming = false;
        _notify();
      }
    }
  }

  void _scheduleQuote() {
    _quoteDebounce?.cancel();
    if (_beneficiary == null || !hasUsableDestination || _activeAmount <= 0) {
      return;
    }
    _quoteDebounce = Timer(const Duration(milliseconds: 550), _requestQuote);
  }

  Future<void> _requestQuote() async {
    final contact = _beneficiary;
    final destinationId = contact?.destinationId;
    if (_disposed ||
        contact == null ||
        destinationId == null ||
        destinationId.trim().isEmpty ||
        _activeAmount <= 0) {
      return;
    }
    final generation = ++_quoteGeneration;
    _quoting = true;
    _error = null;
    _notify();
    try {
      final result = await _transfers.createQuote(
        beneficiaryId: contact.id,
        destinationId: destinationId,
        sentAmount: _amountInput == TransferAmountInput.sent
            ? _sentAmount
            : null,
        receivedAmount: _amountInput == TransferAmountInput.received
            ? _receivedAmount
            : null,
        sentCurrency: _sentCurrency,
      );
      if (!_disposed && generation == _quoteGeneration) {
        _quote = result;
        _sentAmount = result.sentAmount;
        _receivedAmount = result.receivedAmount;
        _idempotencyKey = _uuid.v4();
      }
    } on TransferException catch (error) {
      if (!_disposed && generation == _quoteGeneration) {
        _error = error.failure;
      }
    } catch (_) {
      if (!_disposed && generation == _quoteGeneration) {
        _error = TransferFailure.unexpected;
      }
    } finally {
      if (!_disposed && generation == _quoteGeneration) {
        _quoting = false;
        _notify();
      }
    }
  }

  num _parseAmount(String rawValue) {
    final normalized = rawValue.trim().replaceAll(',', '.');
    return num.tryParse(normalized) ?? 0;
  }

  void _invalidateQuote() {
    _quoteGeneration++;
    _quote = null;
    _idempotencyKey = null;
    _error = null;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _quoteDebounce?.cancel();
    _quoteGeneration++;
    super.dispose();
  }
}
