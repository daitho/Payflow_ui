import '../model/transfer_detail_model.dart';
import '../model/transfer_history_filter.dart';
import '../model/transfer_history_page_model.dart';
import '../repository/transfer_history_repository.dart';

class TransferHistoryService {
  final TransferHistoryRepository _repository;
  TransferHistoryService({required TransferHistoryRepository repository})
      : _repository = repository;

  Future<TransferHistoryPageModel> getHistory({
    required TransferHistoryFilter filter, required int page,
  }) => _repository.getHistory(filter: filter, page: page);

  Future<TransferDetailModel> getDetail(String transferId) =>
      _repository.getDetail(transferId);
  Future<List<int>> getReceipt(String transferId, String locale) =>
      _repository.getReceipt(transferId, locale);

  Future<List<int>> getStatement(TransferHistoryFilter filter, String locale) =>
      _repository.getStatement(filter, locale);
}
