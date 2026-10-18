import '../../../payments/domain/test_funding_service.dart';
import '../../../payments/domain/mobile_money_sandbox_funding.dart';
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
import '../../domain/service/transfer_funding_availability.dart';

class TransferViewModel extends ChangeNotifier {
  final TransferService _transfers;
  final BeneficiaryService _beneficiaries;
  final SavedPaymentCardService? _savedCardService;
  final TestFundingService? _fundingService;
  final MobileMoneySandboxFunding? _mobileMoneyFunding;
  MobileMoneyFundingOptions? _mobileOptions;
  MobileMoneyFundingProgress? _mobilePayment;
  String? _sourceProvider;
  bool get isBankTransfer => _beneficiary?.isBankAccount == true || collectionPending;
  MobileMoneyFundingProgress? get mobilePayment => _mobilePayment;
  bool get collectionPending => _mobilePayment != null && !_mobilePayment!.terminal;
  List<MobileMoneyFundingOption> get sourceProviders => _mobileOptions?.providers ?? const [];
  String? get sourceProvider => _sourceProvider;
  String? get sourceFundingLabel {
    for (final p in sourceProviders) { if(p.provider == _sourceProvider) return '${p.label} · ${p.maskedPhone}'; }
    return null;
  }
  bool get mobileMoneyAvailable => _mobileOptions?.enabled == true && sourceProviders.isNotEmpty;
  void selectSourceProvider(String? value) {
    if (_confirming || collectionPending || !sourceProviders.any((p) => p.provider == value)) return;
    _sourceProvider = value; _notify();
  }
  Future<void> refreshMobileMoney() async {
    if (_disposed) return;
    try {
      final options = await _mobileMoneyFunding?.options();
      if (_disposed) return;
      _mobileOptions = options;
      _mobilePayment = options?.activePayment ?? _mobilePayment;
      if (!sourceProviders.any((p) => p.provider == _sourceProvider)) {
        _sourceProvider = sourceProviders.isEmpty ? null : sourceProviders.first.provider;
      }
      // Source currency is owned profile data returned by the server, never a phone/country selector.
      final currency = options?.sourceCurrency;
      if (currency != null && currency != _sentCurrency) {
        _sentCurrency = currency; _invalidateQuote();
      }
    } catch (_) { /* The normal card flow remains available if mobile-money setup is unavailable. */ }
    _notify();
  }
  Future<ConfirmedTransfer?> continueMobileMoney() async {
    if (_disposed || _confirming || _mobileMoneyFunding == null) return null;
    final pending = _mobilePayment;
    final existingTransfer = pending?.transferId;
    if (existingTransfer != null && pending != null) {
      return ConfirmedTransfer(id: existingTransfer, status: pending.bankStatus);
    }
    _confirming = true; _error = null; _notify();
    try {
      if (pending?.pending != true) {
        final currentQuote = await ensureQuote();
        if (_disposed || currentQuote == null || !mobileMoneyAvailable || _sourceProvider == null) return null;
        _mobilePayment = await _mobileMoneyFunding!.start(quoteId: currentQuote.id,
          provider: _sourceProvider!, idempotencyKey: _paymentIdempotencyKey ??= _uuid.v4());
      }
      // Bound the foreground wait. The durable server worker continues after navigation/app closure.
      for (var attempt = 0; attempt < 20 && !_disposed; attempt++) {
        final payment = _mobilePayment!;
        _notify();
        if (payment.transferId != null) return ConfirmedTransfer(id: payment.transferId!, status: payment.bankStatus);
        if (payment.terminal) { _error = TransferFailure.paymentNotCompleted; return null; }
        await Future<void>.delayed(const Duration(seconds: 2));
        if (_disposed) return null;
        _mobilePayment = await _mobileMoneyFunding!.progress(payment.paymentIntentId);
      }
      final latest = _mobilePayment;
      if (!_disposed && latest != null && latest.transferId != null) return ConfirmedTransfer(id: latest.transferId!, status: latest.bankStatus);
      return null;
    } on TransferException catch(e) {
      if (!_disposed) _error = e.failure;
      await refreshMobileMoney(); // Recover a server-created payment after a lost POST response.
      return null;
    } catch (_) {
      if (!_disposed) _error = TransferFailure.unexpected;
      await refreshMobileMoney(); return null;
    } finally {
      if (!_disposed) { _confirming = false; _notify(); }
    }
  }
  bool _paymentConfigurationFailed = false;
  bool _loadingPaymentOptions = false;
  bool _paymentOptionsLoaded = false;
  bool get paymentConfigurationFailed => !isBankTransfer && _paymentConfigurationFailed;
  bool get paymentConfigurationLoading =>
      !isBankTransfer && (_loadingPaymentOptions || (_fundingService != null && !_paymentOptionsLoaded));
  bool get stripeEnabled => _fundingService?.enabled == true;
  bool get stripeUnsupported => !isBankTransfer && stripeEnabled && _fundingService?.supported != true;
  bool get supportsStripeApplePay => _fundingService?.supportsApplePay == true;
  bool get supportsStripeGooglePay => _fundingService?.supportsGooglePay == true;
  bool get applePayRequiresIos => kIsWeb || defaultTargetPlatform != TargetPlatform.iOS;
  List<TransferFundingMethod> get availableFundingMethods =>
      isBankTransfer ? const [TransferFundingMethod.mobileMoney] : TransferFundingAvailability.resolve(
        supportsApplePay: !stripeEnabled || supportsStripeApplePay,
        supportsGooglePay: stripeEnabled ? supportsStripeGooglePay
            : kIsWeb || (defaultTargetPlatform != TargetPlatform.iOS &&
                defaultTargetPlatform != TargetPlatform.fuchsia),
        hasSavedCard: hasSavedCard,
      );
  String? get fundingSelectionValue {
    if (paymentConfigurationLoading || !availableFundingMethods.contains(_fundingMethod)) return null;
    return _fundingMethod == TransferFundingMethod.card
        ? (selectedCard == null ? null : 'card:${selectedCard!.id}')
        : _fundingMethod.apiValue;
  }
  final TransferDraftSeed seed;
  final Uuid _uuid;

  TransferViewModel({
    required TransferService transferService,
    required BeneficiaryService beneficiaryService,
    SavedPaymentCardService? savedCardService,
    TestFundingService? fundingService,
    MobileMoneySandboxFunding? mobileMoneyFunding,
    this.seed = const TransferDraftSeed(),
    Uuid uuid = const Uuid(),
  }) : _transfers = transferService,
       _beneficiaries = beneficiaryService,
       _savedCardService = savedCardService,
       _fundingService = fundingService,
       _mobileMoneyFunding = mobileMoneyFunding,
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
  String _sentCurrency;
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
              payoutMethod: contact.payoutMethod,
            ),
      );
    }
    final independentOptions = <BeneficiaryOperator>[];
    for (final option in _catalog?.operators ?? const <BeneficiaryOperator>[]) {
      if (!contact.isBankAccount && contact.phoneE164?.trim().isNotEmpty == true &&
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
  List<SavedPaymentCard> get savedCards => {
    for (final card in _savedCards)
      if (card.id.isNotEmpty && !card.expired && (!stripeEnabled || card.tokenized))
        card.id: card,
  }.values.toList(growable: false);
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
  bool get busy => _initializing || _quoting || _confirming || collectionPending || paymentConfigurationLoading;
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
  bool get canRequestQuote =>
      _beneficiary != null && hasUsableDestination && _activeAmount > 0 && !busy;
  bool get hasBlockingDestinationError =>
      _error == TransferFailure.notFound ||
      _error == TransferFailure.payoutUnavailable ||
      (_error == TransferFailure.providerUnavailable && _quote?.isUsable != true);

  bool get canContinue =>
      _beneficiary != null &&
      hasUsableDestination &&
      _activeAmount > 0 &&
      (_fundingMethod != TransferFundingMethod.card || selectedCard != null) &&
      availableFundingMethods.contains(_fundingMethod) &&
      !busy &&
      !stripeUnsupported &&
      !paymentConfigurationFailed &&
      (!isBankTransfer || mobileMoneyAvailable) &&
      !hasBlockingAmountError && !hasBlockingDestinationError;

  String get initialAmountText {
    final value = _sentAmount.toDouble();
    return value == value.roundToDouble()
        ? value.toStringAsFixed(2)
        : value.toString();
  }

  Future<void> initialize() async {
    await refreshMobileMoney();
    if (collectionPending) {
      await _loadCatalog(); await refreshCards(); return;
    }
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
      if (contact.isBankAccount) _fundingMethod = TransferFundingMethod.mobileMoney;
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
    if (_disposed || _loadingPaymentOptions) return;
    _loadingPaymentOptions = true;
    _notify();
    try {
      await _fundingService?.initialize();
      if (_disposed) return;
      _paymentConfigurationFailed = false;
      final cards = service == null ? <SavedPaymentCard>[] : await service.list();
      if (_disposed) return;
      _savedCards = cards;
      final available = savedCards;
      if (!available.any((card) => card.id == _selectedCardId)) {
        _selectedCardId = available.isEmpty ? null : available.first.id;
        if (_fundingMethod == TransferFundingMethod.card) {
          _invalidateQuote();
          _scheduleQuote();
        }
      }
    } catch (_) {
      if (!_disposed) _paymentConfigurationFailed = true;
    } finally {
      if (!_disposed) {
        _paymentOptionsLoaded = true;
        _loadingPaymentOptions = false;
        _notify();
      }
    }
  }

  void selectCard(String id) {
    if (_disposed || !savedCards.any((card) => card.id == id)) return;
    if (_confirming) return;
    _selectedCardId = id;
    _invalidateQuote();
    _scheduleQuote();
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
    if (_disposed || _confirming || collectionPending) return;
    _beneficiary = contact;
    if (contact.isBankAccount) _fundingMethod = TransferFundingMethod.mobileMoney;
    _selectedOperatorId = contact.operatorId;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
    if (_catalog == null) _loadCatalog();
  }

  void selectPayoutOperator(String operatorId) {
    if (_disposed || _confirming || collectionPending || _selectedOperatorId == operatorId ||
        !payoutOptions.any((option) => option.id == operatorId)) return;
    _selectedOperatorId = operatorId;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void setSentAmount(String rawValue) {
    if (_disposed || _confirming || collectionPending) return;
    _amountInput = TransferAmountInput.sent;
    _sentAmount = _parseAmount(rawValue);
    _receivedAmount = 0;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void setReceivedAmount(String rawValue) {
    if (_disposed || _confirming || collectionPending) return;
    _amountInput = TransferAmountInput.received;
    _receivedAmount = _parseAmount(rawValue);
    _sentAmount = 0;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void selectSuggestedAmount(num amount) {
    if (_disposed || _confirming || collectionPending || amount <= 0) return;
    _amountInput = TransferAmountInput.sent;
    _sentAmount = amount;
    _receivedAmount = 0;
    _invalidateQuote();
    _scheduleQuote();
    _notify();
  }

  void selectFundingMethod(TransferFundingMethod method) {
    if (_disposed || _confirming || paymentConfigurationLoading ||
        _fundingMethod == method || !availableFundingMethods.contains(method)) return;
    _fundingMethod = method;
    _invalidateQuote();
    _scheduleQuote();
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
    if (_mobilePayment?.terminal != true && _quote?.isUsable == true &&
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
    if (isBankTransfer || collectionPending) return continueMobileMoney();
    if (paymentConfigurationLoading || !availableFundingMethods.contains(_fundingMethod)) return null;
    if (!stripeEnabled && _fundingMethod == TransferFundingMethod.paypal) {
      return capturePaypalAndConfirm();
    }
    if (_confirming || _disposed || _paymentConfigurationFailed || stripeUnsupported) return null;
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
      String? stripePaymentId;
      if (stripeEnabled) {
        stripePaymentId = await _fundingService!.pay(
          quoteId: currentQuote.id, method: _fundingMethod,
          cardId: _fundingMethod == TransferFundingMethod.card ? _selectedCardId : null,
          idempotencyKey: _paymentIdempotencyKey ??= _uuid.v4());
        if (stripePaymentId == null || _disposed) return null;
      }
      final result = await _transfers.confirm(
        quoteId: currentQuote.id,
        fundingMethod: _fundingMethod,
        paymentIntentId: stripePaymentId,
        cardId: _fundingMethod == TransferFundingMethod.card
            ? _selectedCardId : null,
        idempotencyKey: stripePaymentId == null ? (_idempotencyKey ??= _uuid.v4()) : 'stripe-$stripePaymentId',
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
    if (_mobilePayment?.terminal == true) _mobilePayment = null;
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
    if (_disposed) return;
    if (!paymentConfigurationLoading && availableFundingMethods.isNotEmpty && !availableFundingMethods.contains(_fundingMethod)) {
      _fundingMethod = availableFundingMethods.first;
      _invalidateQuote();
      _scheduleQuote();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _quoteDebounce?.cancel();
    _quoteGeneration++;
    super.dispose();
  }
}
