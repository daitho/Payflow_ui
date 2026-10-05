import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uuid/uuid.dart';

import '../../payment_cards/domain/model/saved_payment_card.dart';
import '../../transfer/domain/model/transfer_quote.dart';
import '../domain/test_funding_service.dart';

class StripeTestFundingService implements TestFundingService {
  StripeTestFundingService(this._dio);
  final Dio _dio;
  static const _path = '/api/v1/payments/stripe-test';
  Future<void>? _initializing;
  bool _enabled = false;
  bool _apple = false;
  bool _google = false;
  String _country = 'FR';
  @override bool get enabled => _enabled;
  @override bool get supported => !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
  @override bool get supportsApplePay => _apple;
  @override bool get supportsGooglePay => _google;

  @override Future<void> initialize() async {
    try { await (_initializing ??= _initialize()); }
    catch (_) { _initializing = null; rethrow; }
  }
  Future<void> _initialize() async {
    final response = await _dio.get<Map<String, dynamic>>('$_path/config');
    final config = response.data;
    if (config == null) throw StateError('Missing payment configuration');
    _enabled = config['enabled'] == true;
    if (!_enabled) return;
    final key = config['publishableKey'] as String?;
    if (key == null || !key.startsWith('pk_test_')) throw StateError('Test key required');
    _country = config['merchantCountryCode'] as String? ?? 'FR';
    if (!supported) return;
    Stripe.publishableKey = key;
    Stripe.urlScheme = 'payflow';
    final merchant = config['appleMerchantId'] as String?;
    if (merchant?.isNotEmpty == true) Stripe.merchantIdentifier = merchant!;
    await Stripe.instance.applySettings();
    // Wallet setup may be unavailable without preventing card/PayPal tests.
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS && merchant?.isNotEmpty == true) {
        _apple = await Stripe.instance.isPlatformPaySupported();
      }
      if (defaultTargetPlatform == TargetPlatform.android) {
        _google = await Stripe.instance.isPlatformPaySupported(
          googlePay: const IsGooglePaySupportedParams(testEnv: true));
      }
    } catch (_) { _apple = false; _google = false; }
  }
  void _requireSupported() {
    if (!enabled || !supported) throw UnsupportedError('Stripe test requires iOS or Android');
  }
  @override Future<SavedPaymentCard?> saveCard() async {
    await initialize(); _requireSupported();
    final setup = (await _dio.post<Map<String, dynamic>>('$_path/setup',
      options: Options(headers: {'Idempotency-Key': const Uuid().v4()}))).data!;
    try {
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        setupIntentClientSecret: setup['clientSecret'] as String,
        merchantDisplayName: 'PayFlow', returnURL: 'payflow://stripe-return',
      ));
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return null;
      rethrow;
    }
    final card = (await _dio.post<Map<String, dynamic>>('$_path/setup/complete',
      data: {'setupIntentId': setup['id']})).data!;
    return SavedPaymentCard(id: card['id'] as String, holderName: card['holderName'] as String,
      brand: card['brand'] as String, lastFour: card['lastFour'] as String,
      expiryMonth: card['expiryMonth'] as int, expiryYear: card['expiryYear'] as int,
      tokenized: true);
  }
  @override Future<String?> pay({required String quoteId, required TransferFundingMethod method,
      String? cardId, required String idempotencyKey}) async {
    await initialize(); _requireSupported();
    final funding = (await _dio.post<Map<String, dynamic>>('$_path/funding',
      data: {'quoteId': quoteId, 'method': method.apiValue, if (cardId != null) 'cardId': cardId},
      options: Options(headers: {'Idempotency-Key': idempotencyKey}))).data!;
    // Reuse an already paid intent after a lost response. The server verifies it again.
    if (funding['status'] == 'succeeded') return funding['id'] as String;
    final secret = funding['clientSecret'] as String;
    try {
      switch (method) {
        case TransferFundingMethod.card:
          await Stripe.instance.confirmPayment(paymentIntentClientSecret: secret,
            data: PaymentMethodParams.cardFromMethodId(paymentMethodData: PaymentMethodDataCardFromMethod(
              paymentMethodId: funding['paymentMethodId'] as String)));
        case TransferFundingMethod.applePay:
          await Stripe.instance.confirmPlatformPayPaymentIntent(clientSecret: secret,
            confirmParams: PlatformPayConfirmParams.applePay(applePay: ApplePayParams(
              merchantCountryCode: _country, currencyCode: funding['currency'] as String,
              cartItems: [ApplePayCartSummaryItem.immediate(label: 'PayFlow',
                amount: ((funding['amountMinor'] as num) / 100).toStringAsFixed(2))])));
        case TransferFundingMethod.googlePay:
          await Stripe.instance.confirmPlatformPayPaymentIntent(clientSecret: secret,
            confirmParams: PlatformPayConfirmParams.googlePay(googlePay: GooglePayParams(
              testEnv: true, merchantCountryCode: _country, merchantName: 'PayFlow',
              currencyCode: funding['currency'] as String)));
        case TransferFundingMethod.paypal:
          await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: secret, merchantDisplayName: 'PayFlow',
            returnURL: 'payflow://stripe-return'));
          await Stripe.instance.presentPaymentSheet();
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return null;
      rethrow;
    }
    return funding['id'] as String;
  }
}
