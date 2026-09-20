import 'package:dio/dio.dart';

import '../dto/transfer_quote_dto.dart';

class TransferApiService {
  final Dio _dio;
  const TransferApiService(this._dio);

  Future<TransferQuoteDto> createQuote({
    required String beneficiaryId,
    required String destinationId,
    required num sentAmount,
    required String sentCurrency,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/transfer-quotes',
      data: {
        'beneficiaryId': beneficiaryId,
        'destinationId': destinationId,
        'sentAmount': sentAmount,
        'sentCurrency': sentCurrency,
      },
    );
    final data = response.data;
    if (data == null) throw StateError('Empty transfer quote response');
    return TransferQuoteDto(data);
  }

  Future<ConfirmedTransferDto> confirm({
    required String quoteId,
    required String idempotencyKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/v1/transfers',
      data: {'quoteId': quoteId},
      options: Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
    final data = response.data;
    if (data == null) throw StateError('Empty transfer response');
    return ConfirmedTransferDto(data);
  }
}
