import 'package:dio/dio.dart';

import '../dto/transfer_detail_dto.dart';
import '../dto/transfer_history_response_dto.dart';
import 'transfer_history_api_service.dart';

final class TransferHistoryApiServiceImpl implements TransferHistoryApiService {
  // ===========================================================
  // ENDPOINTS
  // ===========================================================

  static const String _basePath = '/api/v1/transfers';

  static const String _historyPath = '$_basePath/history';

  // ===========================================================
  // DEPENDENCIES
  // ===========================================================

  final Dio _dio;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================

  TransferHistoryApiServiceImpl({required Dio dio}) : _dio = dio;

  // ===========================================================
  // HISTORY
  // ===========================================================

  @override
  Future<TransferHistoryResponseDto> getHistory({
    String? beneficiaryId,
    String? status,
    int? year,
    required int page,
    required int size,
  }) async {
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'page': page,
      'size': size,
      if (year != null) 'year': year,
    };

    final String? normalizedBeneficiaryId = _normalizeOptionalString(
      beneficiaryId,
    );

    final String? normalizedStatus = _normalizeOptionalString(status);

    if (normalizedBeneficiaryId != null) {
      queryParameters['beneficiaryId'] = normalizedBeneficiaryId;
    }

    if (normalizedStatus != null) {
      queryParameters['status'] = normalizedStatus;
    }

    final Response<Map<String, dynamic>> response = await _dio
        .get<Map<String, dynamic>>(
          _historyPath,
          queryParameters: queryParameters,
        );

    final Map<String, dynamic> data = _requireJsonBody(
      response.data,
      endpoint: _historyPath,
    );

    return TransferHistoryResponseDto.fromJson(data);
  }

  // ===========================================================
  // DETAIL
  // ===========================================================

  @override
  Future<TransferDetailDto> getDetail({required String transferId}) async {
    final String normalizedTransferId = _requireIdentifier(
      transferId,
      parameterName: 'transferId',
    );

    final String path = '$_basePath/detail/$normalizedTransferId';

    final Response<Map<String, dynamic>> response = await _dio
        .get<Map<String, dynamic>>(path);

    final Map<String, dynamic> data = _requireJsonBody(
      response.data,
      endpoint: path,
    );

    return TransferDetailDto.fromJson(data);
  }

  // ===========================================================
  // RECEIPT
  // ===========================================================

  @override
  Future<List<int>> getReceipt({
    required String transferId,
    bool download = false,
    String? locale,
  }) async {
    final String normalizedTransferId = _requireIdentifier(
      transferId,
      parameterName: 'transferId',
    );

    final String path = '$_basePath/receipt/$normalizedTransferId';

    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'download': download,
    };

    final String? normalizedLocale = _normalizeOptionalString(locale);

    if (normalizedLocale != null) {
      queryParameters['locale'] = normalizedLocale;
    }

    final Response<List<int>> response = await _dio.get<List<int>>(
      path,
      queryParameters: queryParameters,
      options: Options(responseType: ResponseType.bytes),
    );

    final List<int>? bytes = response.data;

    if (bytes == null || bytes.isEmpty) {
      throw StateError('La réponse PDF reçue depuis $path est vide.');
    }

    return _requirePdf(bytes);
  }

  // ===========================================================
  // INTERNAL - JSON RESPONSE
  // ===========================================================

  Map<String, dynamic> _requireJsonBody(
    Map<String, dynamic>? data, {
    required String endpoint,
  }) {
    if (data == null) {
      throw StateError(
        'La réponse reçue depuis $endpoint '
        'ne contient aucun corps JSON.',
      );
    }

    return data;
  }

  // ===========================================================
  // INTERNAL - REQUIRED IDENTIFIER
  // ===========================================================

  String _requireIdentifier(String value, {required String parameterName}) {
    final String normalized = value.trim();

    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        parameterName,
        '$parameterName ne peut pas être vide.',
      );
    }

    return normalized;
  }

  // ===========================================================
  // INTERNAL - OPTIONAL STRING
  // ===========================================================

  String? _normalizeOptionalString(String? value) {
    if (value == null) {
      return null;
    }

    final String normalized = value.trim();

    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  @override
  Future<List<int>> getStatement({
    String? beneficiaryId,
    String? status,
    int? year,
    required String locale,
  }) async {
    final String? normalizedBeneficiaryId = _normalizeOptionalString(
      beneficiaryId,
    );
    final String? normalizedStatus = _normalizeOptionalString(status);
    final String? normalizedLocale = _normalizeOptionalString(locale);

    final response = await _dio.get<List<int>>(
      '$_historyPath/export/pdf',
      queryParameters: {
        if (normalizedBeneficiaryId != null)
          'beneficiaryId': normalizedBeneficiaryId,
        if (normalizedStatus != null) 'status': normalizedStatus,
        if (normalizedLocale != null) 'locale': normalizedLocale,
        'download': true,
        if (year != null) 'year': year,
      },
      options: Options(responseType: ResponseType.bytes),
    );
    return _requirePdf(response.data);
  }

  List<int> _requirePdf(List<int>? bytes) {
    // Reject a successful HTTP response that actually contains JSON/HTML.
    const signature = [0x25, 0x50, 0x44, 0x46, 0x2D];
    if (bytes == null || bytes.length < signature.length) {
      throw StateError('Empty PDF response');
    }
    for (var i = 0; i < signature.length; i++) {
      if (bytes[i] != signature[i]) throw StateError('Invalid PDF response');
    }
    return bytes;
  }
}
