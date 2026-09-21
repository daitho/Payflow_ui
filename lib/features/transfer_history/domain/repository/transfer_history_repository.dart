import '../model/transfer_detail_model.dart';
import '../model/transfer_history_filter.dart';
import '../model/transfer_history_page_model.dart';

abstract interface class TransferHistoryRepository {
  Future<TransferHistoryPageModel> getHistory({
    required TransferHistoryFilter filter,
    required int page,
    int size = 20,
  });
  Future<TransferDetailModel> getDetail(String transferId);
  Future<List<int>> getReceipt(String transferId, String locale);
  Future<List<int>> getStatement(TransferHistoryFilter filter, String locale);
}
