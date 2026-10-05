import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../beneficiaries/domain/exception/beneficiary_exception.dart';
import '../../../beneficiaries/domain/model/beneficiary_contact.dart';
import '../../../beneficiaries/domain/service/beneficiary_service.dart';
import '../../../payment_cards/domain/model/saved_payment_card.dart';
import '../../../payment_cards/domain/service/saved_payment_card_service.dart';
import '../../domain/exception/transfer_exception.dart';
import '../../domain/model/transfer_draft_seed.dart';
import '../../domain/model/transfer_amount_input.dart';
import '../../domain/model/transfer_quote.dart';
import '../../domain/service/transfer_service.dart';
import '../../domain/service/transfer_amount_suggestions.dart';

class TransferViewModel extends ChangeNotifier {
  final TransferService _transfers;
  final BeneficiaryService _beneficiaries;
  final SavedPaymentCardService? _savedCardService;
  final TransferDraftSeed seed;
  final Uuid _uuid;

  TransferViewModel({
    required TransferService transferService,
    required BeneficiaryService beneficiaryService,
    SavedPaymentCardService? savedCardService,
    this.seed = const TransferDraftSeed(),
    Uuid uuid = const Uuid(),
  }) : _transfers = transferService,
       _beneficiaries = beneficiaryService,
       _savedCardService = savedCardService,
       _uuid = uuid,
       _sentAmount = seed.sentAmount ?? 10,
       _sentCurrency = (seed.sentCurrency ?? 'EUR').toUpperCase();

  BeneficiaryContact? _beneficiary;
  BeneficiaryCatalog? _catalog;
  String? _selectedOperatorId;
  String? _quotedOperatorId;
  final Map<String, Future<String>> _alternativeDestinations = {};
  TransferQuote? _quote;
  TransferFailure? _error;
  num _sentAmount;
  num _receivedAmount = 0;
  TransferAmountInput _amountInput = TransferAmountInput.sent;
  final String _sentCurrency;
  TransferFundingMethod _fundingMethod = TransferFundingMethod.applePay;
  PaypalPaymentIntent? _paypalPayment;
  List<SavedPaymentCard> _savedCards = const [];
  String? _selectedCardId;
  bool _initializing = false;
  bool _quoting = false;
  bool _confirming = false;
  bool _disposed = false;
  int _quoteGeneration = 0;
  Timer? _quoteDebounce;
  String? _idempotencyKey;
  String? _paymentIdempotencyKey;
  String? _captureIdempotencyKey;

  BeneficiaryContact? get beneficiary => _beneficiary;
  String? get selectedPayoutOperatorId => _selectedOperatorId;
  String? get selectedPayoutName {
    for (final option in payoutOptions) {
      if (option.id == _selectedOperatorId) return option.name;
    }
    return _beneficiary?.operatorName;
  }

  List<BeneficiaryOperator> get payoutOptions {
    final contact = _beneficiary;
    if (contact == null) return const [];
    final options = <BeneficiaryOperator>[];
    BeneficiaryOperator? primary;
    for (final option in _catalog?.operators ?? const <BeneficiaryOperator>[]) {
      if (option.countryId == contact.countryId &&
          option.id == contact.operatorId) {
        primary = option;
        break;
      }
    }
    if (contact.operatorId != null && (_catalog == null || primary != null)) {
      options.add(
        primary ??
            BeneficiaryOperator(
              contact.operatorId!,
              contact.countryId,
              contact.operatorName ?? '',
              contact.currencyCode ?? '',
              networkIndependent:
                  contact.operatorName?.trim().toUpperCase() == 'WAVE',
            ),
      );
    }
    final independentOptions = <BeneficiaryOperator>[];
    for (final option in _catalog?.operators ?? const <BeneficiaryOperator>[]) {
      if (contact.phoneE164?.trim().isNotEmpty == true &&
          option.countryId == contact.countryId &&
          option.id != contact.operatorId &&
          option.networkIndependent &&
          !independentOptions.any((existing) => existing.id == option.id)) {
        independentOptions.add(option);
      }
    }
    // Wave is the first alternative; later independent services follow it.
    independentOptions.sort((a, b) {
      final aWave = a.name.trim().toUpperCase() == 'WAVE';
      final bWave = b.name.trim().toUpperCase() == 'WAVE';
      if (aWave != bWave) return aWave ? -1 : 1;
      return a.name.compareTo(b.name);
    });
    options.addAll(independentOptions);
    return options;
  }
  TransferQuote? get quote => _quote;
  TransferFailure? get error => _error;
  num get sentAmount => _sentAmount;
  num get receivedAmount => _receivedAmount;
  TransferAmountInput get amountInput => _amountInput;
  String get sentCurrency => _sentCurrency;
  List<num> get suggestedAmounts =>
      TransferAmountSuggestions.forCurrency(_sentCurrency);
  TransferFundingMethod get fundingMethod => _fundingMethod;
  bool get hasSavedCard => savedCards.isNotEmpty;
  List<SavedPaymentCard> get savedCards =>
      _savedCards.where((card) => !card.expired).toList(growable: false);
  String? get selectedCardId => _selectedCardId;
  SavedPaymentCard? get selectedCard {
    for (final card in savedCards) {
      if (card.id == _selectedCardId) return card;
    }
    return null;
  }
  PaypalPaymentIntent? get paypalPayment => _paypalPayment;
  bool get initializing => _initializing;
  bool get quoting => _quoting;
  bool get confirming => _confirming;
  bool get busy => _initializing || _quoting || _confirming;
  bool get hasUsableDestination =>
      _selectedOperatorId != null &&
      (_catalog == null ||
          payoutOptions.any((option) => option.id == _selectedOperatorId)) &&
      _beneficiary?.destinationId?.trim().isNotEmpty == true &&
      (_selectedOperatorId == _beneficiary?.operatorId ||
          _beneficiary?.phoneE164?.trim().isNotEmpty == true);
  num get _activeAmount => _amountInput == TransferAmountInput.sent
      ? _sentAmount
      : _receivedAmount;
  bool get hasBlockingAmountError =>
      _error == TransferFailure.amountBelowMinimum ||
      _error == TransferFailure.amountAboveMaximum;

  bool get canContinue =>
      _beneficiary != null &&
      hasUsableDestination &&
      _activeAmount > 0 &&
      (_fundingMethod != TransferFundingMethod.card || selectedCard != null) &&
      !busy &&
      !hasBlockingAmountError;

  String get initialAmountText {
    final value = _sentAmount.toDouble();
    return value == value.roundToDouble()
        ? value.toStringAsFixed(2)
        : value.toString();
  }

  Future<void> initialize() async {
    final id = seed.beneficiaryId?.trim();
    if (_initializing || _disposed) return;
    if (id == null || id.isEmpty) {
      await _loadCatalog();
      await refreshCards();
      return;
    }
    _initializing = true;
    _error = null;
    _notify();
    try {
      final contact = await _beneficiaries.get(id);
      if (_disposed) return;
      _beneficiary = contact;
      _selectedOperatorId = contact.operatorId;
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
    await _loadCatalog();
    await refreshCards();
  }

  Future<void> refreshCards() async {
    final service = _savedCardService;
    if (service == null || _disposed) return;
    try {
      final cards = await service.list();
      if (_disposed) return;
      _savedCards = cards;
      final available = savedCards;
      if (!available.any((card) => card.id == _selectedCardId)) {
        _selectedCardId = available.isEmpty ? null : available.first.id;
      }
      if (available.isEmpty && _fundingMethod == TransferFundingMethod.card) {
        selectFundingMethod(TransferFundingMethod.applePay);
      }
      _notify();
    } catch (_) {
      // Other funding methods remain available if card listing fails.
    }
  }

  void selectCard(String id) {
    if (_disposed || !savedCards.any((card) => card.id == id)) return;
    _selectedCardId = id;
    _notify();
  }

  Future<void> _loadCatalog() async {
    if (_catalog != null || _disposed) return;
    try {
      final catalog = await _beneficiaries.catalog();
      if (!_disposed) {
        _catalog = catalog;
        if (_beneficiary != null &&
            !payoutOptions.any((option) => option.id == _selectedOperatorId)) {
          final options = payoutOptions;
          _selectedOperatorId = options.isEmpty ? null : options.first.id;
          _invalidateQuote();
          _scheduleQuote();
        }
        _notify();
      }
    } catch (_) {
      // The saved primary destination remains usable if the catalog is down.
    }
  }

  void selectBeneficiary(BeneficiaryContact contact) {
    if (_disposed) return;
    _beneficiary = contact;
    _selectedOperatorId = contact.operatorId;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
    if (_catalog == null) _loadCatalog();
  }

  void selectPayoutOperator(String operatorId) {
    if (_disposed || _confirming || _selectedOperatorId == operatorId ||
        !payoutOptions.any((option) => option.id == operatorId)) return;
    _selectedOperatorId = operatorId;
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
    if (_disposed || _fundingMethod == method ||
        method == TransferFundingMethod.card && !hasSavedCard) return;
    _fundingMethod = method;
    _paypalPayment = null;
    _paymentIdempotencyKey = null;
    _captureIdempotencyKey = null;
    _notify();
  }

  Future<TransferQuote?> ensureQuote() async {
    _quoteDebounce?.cancel();
    final quoteMatchesInput = _amountInput == TransferAmountInput.sent
        ? _quote?.sentAmount == _sentAmount
        : _quote?.receivedAmount == _receivedAmount;
    if (_quote?.isUsable == true &&
        quoteMatchesInput &&
        _quotedOperatorId == _selectedOperatorId &&
        _quote!.beneficiaryId == _beneficiary?.id) {
      return _quote;
    }
    await _requestQuote();
    return _quote?.isUsable == true ? _quote : null;
  }

  Future<PaypalPaymentIntent?> startPaypalPayment() async {
    if (_confirming || _disposed) return null;
    final currentQuote = await ensureQuote();
    if (currentQuote == null || _disposed) return null;
    _confirming = true;
    _error = null;
    _notify();
    try {
      final payment = await _transfers.createPaypalPayment(
        quoteId: currentQuote.id,
        idempotencyKey: _paymentIdempotencyKey ??= _uuid.v4(),
      );
      if (!_disposed) _paypalPayment = payment;
      return _disposed ? null : payment;
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

  Future<ConfirmedTransfer?> capturePaypalAndConfirm() async {
    if (_confirming || _disposed) return null;
    final currentQuote = await ensureQuote();
    final payment = _paypalPayment;
    if (currentQuote == null || payment == null || _disposed) return null;
    _confirming = true;
    _error = null;
    _notify();
    try {
      final captured = await _transfers.capturePaypalPayment(
        paymentIntentId: payment.id,
        idempotencyKey: _captureIdempotencyKey ??= _uuid.v4(),
      );
      if (!captured.completed) {
        _error = TransferFailure.unavailable;
        return null;
      }
      _paypalPayment = captured;
      final result = await _transfers.confirm(
        quoteId: currentQuote.id,
        fundingMethod: TransferFundingMethod.paypal,
        paymentIntentId: captured.id,
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

  Future<ConfirmedTransfer?> confirm() async {
    if (_fundingMethod == TransferFundingMethod.paypal) {
      return capturePaypalAndConfirm();
    }
    if (_confirming || _disposed) return null;
    if (_fundingMethod == TransferFundingMethod.card && selectedCard == null) {
      _error = TransferFailure.invalid;
      _notify();
      return null;
    }
    final currentQuote = await ensureQuote();
    if (currentQuote == null || _disposed) return null;
    _confirming = true;
    _error = null;
    _notify();
    try {
      final result = await _transfers.confirm(
        quoteId: currentQuote.id,
        fundingMethod: _fundingMethod,
        cardId: _fundingMethod == TransferFundingMethod.card
            ? _selectedCardId : null,
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
    final operatorId = _selectedOperatorId;
    if (_disposed ||
        contact == null ||
        operatorId == null ||
        !hasUsableDestination ||
        _activeAmount <= 0) {
      return;
    }
    final generation = ++_quoteGeneration;
    _quoting = true;
    _error = null;
    _notify();
    try {
      final destinationId = operatorId == contact.operatorId
          ? contact.destinationId!
          : await _resolveAlternativeDestination(contact, operatorId);
      if (_disposed || generation != _quoteGeneration) return;
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
        if (result.destinationId != destinationId) {
          throw const TransferException(TransferFailure.invalidResponse);
        }
        _quote = result;
        _quotedOperatorId = operatorId;
        _sentAmount = result.sentAmount;
        _receivedAmount = result.receivedAmount;
        _idempotencyKey = _uuid.v4();
      }
    } on BeneficiaryException {
      if (!_disposed && generation == _quoteGeneration) {
        _error = TransferFailure.unavailable;
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

  Future<String> _resolveAlternativeDestination(
    BeneficiaryContact contact,
    String operatorId,
  ) async {
    final phone = contact.phoneE164!;
    final key = '${contact.id}:$operatorId:$phone';
    final request = _alternativeDestinations.putIfAbsent(
      key,
      () => _beneficiaries.ensureSecondaryDestination(
        beneficiaryId: contact.id,
        operatorId: operatorId,
        phoneE164: phone,
      ),
    );
    try {
      return await request;
    } catch (_) {
      _alternativeDestinations.remove(key);
      rethrow;
    }
  }

  num _parseAmount(String rawValue) {
    final normalized = rawValue.trim().replaceAll(',', '.');
    return num.tryParse(normalized) ?? 0;
  }

  void _invalidateQuote() {
    _quoteGeneration++;
    _quote = null;
    _quotedOperatorId = null;
    _quoting = false;
    _idempotencyKey = null;
    _paymentIdempotencyKey = null;
    _captureIdempotencyKey = null;
    _paypalPayment = null;
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
