import '../dto/transfer_detail_dto.dart';
import '../dto/transfer_history_response_dto.dart';

abstract interface class TransferHistoryApiService {
  // ===========================================================
  // HISTORY
  // ===========================================================
  Future<TransferHistoryResponseDto> getHistory({
    String? beneficiaryId,
    String? status,
    int? year,
    required int page,
    required int size,
  });

  // ===========================================================
  // DETAIL
  // ===========================================================
  Future<TransferDetailDto> getDetail({required String transferId});

  // ===========================================================
  // RECEIPT
  // ===========================================================
  Future<List<int>> getReceipt({
    required String transferId,
    bool download = false,
    String? locale,
  });
  Future<List<int>> getStatement({
    String? beneficiaryId,
    String? status,
    int? year,
    required String locale,
  });
}
