import 'package:dio/dio.dart';

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
  Future<ConfirmedTransfer> confirm({
    required String quoteId,
    required String idempotencyKey,
  }) => _guard(
    () async => (await _api.confirm(
      quoteId: quoteId,
      idempotencyKey: idempotencyKey,
    )).toDomain(),
  );

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      final failure = switch (error.response?.statusCode) {
        400 => TransferFailure.invalid,
        401 => TransferFailure.sessionExpired,
        404 => TransferFailure.notFound,
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
}
