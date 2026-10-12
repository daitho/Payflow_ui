import 'package:dio/dio.dart';

import '../../domain/exception/transfer_error_codes.dart';
import '../../domain/exception/transfer_exception.dart';
import '../../domain/model/transfer_quote.dart';
import '../../domain/repository/transfer_repository.dart';
import '../service_api/transfer_api_service.dart';

class TransferRepositoryImpl implements TransferRepository {
  final TransferApiService _api;
  const TransferRepositoryImpl(this._api);

  @override
  Future<TransferQuote> createQuote({
    required String beneficiaryId,
    required String destinationId,
    num? sentAmount,
    num? receivedAmount,
    required String sentCurrency,
  }) => _guard(
    () async => (await _api.createQuote(
      beneficiaryId: beneficiaryId,
      destinationId: destinationId,
      sentAmount: sentAmount,
      receivedAmount: receivedAmount,
      sentCurrency: sentCurrency,
    )).toDomain(),
  );

  @override
  Future<PaypalPaymentIntent> createPaypalPayment({
    required String quoteId,
    required String idempotencyKey,
  }) => _guard(
    () async => (await _api.createPaypalPayment(
      quoteId: quoteId,
      idempotencyKey: idempotencyKey,
    )).toDomain(),
  );

  @override
  Future<PaypalPaymentIntent> capturePaypalPayment({
    required String paymentIntentId,
    required String idempotencyKey,
  }) => _guard(
    () async => (await _api.capturePaypalPayment(
      paymentIntentId: paymentIntentId,
      idempotencyKey: idempotencyKey,
    )).toDomain(),
  );

  @override
  Future<ConfirmedTransfer> confirm({
    required String quoteId,
    required TransferFundingMethod fundingMethod,
    String? paymentIntentId,
    String? cardId,
    required String idempotencyKey,
  }) => _guard(
    () async => (await _api.confirm(
      quoteId: quoteId,
      fundingMethod: fundingMethod,
      paymentIntentId: paymentIntentId,
      cardId: cardId,
      idempotencyKey: idempotencyKey,
    )).toDomain(),
  );

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      final errorCode = _errorCode(error.response?.data);
      final failure = switch (errorCode) {
        TransferErrorCodes.beneficiaryNotFound ||
        TransferErrorCodes.destinationNotFound => TransferFailure.notFound,
        TransferErrorCodes.paymentOperatorUnavailable ||
        TransferErrorCodes.paymentOperatorNotFound ||
        TransferErrorCodes.countryOperatorNotFound => TransferFailure.payoutUnavailable,
        TransferErrorCodes.amountBelowMinimum =>
          TransferFailure.amountBelowMinimum,
        TransferErrorCodes.amountAboveMaximum =>
          TransferFailure.amountAboveMaximum,
        TransferErrorCodes.paymentProviderUnavailable ||
        TransferErrorCodes.paymentProviderError => TransferFailure.providerUnavailable,
        TransferErrorCodes.paymentCaptureFailed ||
        TransferErrorCodes.cardNotFound =>
          TransferFailure.unavailable,
        TransferErrorCodes.cardInvalid ||
        TransferErrorCodes.cardRequired => TransferFailure.invalid,
        TransferErrorCodes.paymentIntentNotFound => TransferFailure.conflict,
        TransferErrorCodes.paymentNotReady ||
        TransferErrorCodes.paymentAmountMismatch ||
        TransferErrorCodes.paymentRequired =>
          TransferFailure.conflict,
        TransferErrorCodes.paymentNotCompleted => TransferFailure.paymentNotCompleted,
        _ => switch (error.response?.statusCode) {
        400 => TransferFailure.invalid,
        401 => TransferFailure.sessionExpired,
        // Only explicit beneficiary error codes can label a contact as missing.
        404 => TransferFailure.server,
        502 || 503 => TransferFailure.providerUnavailable,
        409 => TransferFailure.conflict,
        410 => TransferFailure.quoteExpired,
        422 => TransferFailure.unavailable,
        _ => switch (error.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout => TransferFailure.timeout,
          DioExceptionType.connectionError => TransferFailure.network,
          DioExceptionType.badResponse => TransferFailure.server,
          _ => TransferFailure.unexpected,
        },
      },
      };
      throw TransferException(failure);
    } on FormatException {
      throw const TransferException(TransferFailure.invalidResponse);
    } on TypeError {
      throw const TransferException(TransferFailure.invalidResponse);
    } on StateError {
      throw const TransferException(TransferFailure.invalidResponse);
    }
  }

  String? _errorCode(Object? responseData) {
    if (responseData case final Map<dynamic, dynamic> data) {
      final code = data['code'];
      return code is String ? code : null;
    }
    return null;
  }
}
