import 'package:dio/dio.dart';
import '../../domain/exception/transfer_history_exception.dart';
import '../../domain/model/transfer_detail_model.dart';
import '../../domain/model/transfer_history_filter.dart';
import '../../domain/model/transfer_history_page_model.dart';
import '../../domain/repository/transfer_history_repository.dart';
import '../mapper/transfer_history_mapper.dart';
import '../service_api/transfer_history_api_service.dart';

class TransferHistoryRepositoryImpl implements TransferHistoryRepository {
  final TransferHistoryApiService _api;
  TransferHistoryRepositoryImpl({required TransferHistoryApiService apiService})
    : _api = apiService;

  @override
  Future<TransferHistoryPageModel> getHistory({
    required TransferHistoryFilter filter,
    required int page,
    int size = 20,
  }) => _guard(
    () async => TransferHistoryMapper.page(
      await _api.getHistory(
        beneficiaryId: filter.beneficiaryId,
        status: filter.status,
        year: filter.year,
        page: page,
        size: size,
      ),
    ),
  );

  @override
  Future<TransferDetailModel> getDetail(String transferId) => _guard(
    () async => TransferHistoryMapper.detail(
      await _api.getDetail(transferId: transferId),
    ),
  );

  @override
  Future<List<int>> getReceipt(String transferId, String locale) => _guard(
    () =>
        _api.getReceipt(transferId: transferId, locale: locale, download: true),
  );

  @override
  Future<List<int>> getStatement(TransferHistoryFilter filter, String locale) =>
      _guard(
        () => _api.getStatement(
          beneficiaryId: filter.beneficiaryId,
          status: filter.status,
          year: filter.year,
          locale: locale,
        ),
      );

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      final failure = switch (status) {
        401 => TransferHistoryFailure.sessionExpired,
        404 => TransferHistoryFailure.notFound,
        _ => switch (error.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout => TransferHistoryFailure.timeout,
          DioExceptionType.connectionError => TransferHistoryFailure.network,
          DioExceptionType.badResponse => TransferHistoryFailure.server,
          _ => TransferHistoryFailure.unexpected,
        },
      };
      throw TransferHistoryException(failure);
    } on FormatException {
      throw const TransferHistoryException(
        TransferHistoryFailure.invalidResponse,
      );
    } on TypeError {
      throw const TransferHistoryException(
        TransferHistoryFailure.invalidResponse,
      );
    } on StateError {
      throw const TransferHistoryException(
        TransferHistoryFailure.invalidResponse,
      );
    }
  }
}
