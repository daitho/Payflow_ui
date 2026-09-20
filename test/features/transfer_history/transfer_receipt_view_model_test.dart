import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_detail_model.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_history_filter.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_history_page_model.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/repository/transfer_history_repository.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/service/transfer_history_service.dart';
import 'package:pay_flow_ui/features/transfer_history/presentation/view_model/transfer_detail_view_model.dart';

class ReceiptRepository implements TransferHistoryRepository {
  bool receiptAvailable = false;
  int requests = 0;
  @override
  Future<TransferDetailModel> getDetail(String transferId) async => TransferDetailModel(
    id: transferId, reference: 'PF-1', status: 'COMPLETED',
    beneficiaryId: 'beneficiary-1', beneficiaryName: 'Alice',
    operatorName: 'MTN', countryCode: 'CM',
    destination: '***1234', sourceCurrencyCode: 'EUR', targetCurrencyCode: 'XAF',
    sentAmount: 10, receivedAmount: 6500, fee: 1, totalChargedAmount: 11,
    appliedRate: 650, createdAt: DateTime.utc(2026), timeline: [],
    receiptAvailable: receiptAvailable, repeatAllowed: false,
  );
  @override
  Future<List<int>> getReceipt(String transferId, String locale) async {
    requests++;
    return [37, 80, 68, 70, 45];
  }
  @override
  Future<TransferHistoryPageModel> getHistory({required TransferHistoryFilter filter,
    required int page, int size = 20}) => throw UnimplementedError();
  @override
  Future<List<int>> getStatement(TransferHistoryFilter filter, String locale) =>
      throw UnimplementedError();
}

void main() {
  test('receipt requires backend eligibility even for a completed transfer', () async {
    final repository = ReceiptRepository();
    final vm = TransferDetailViewModel(
      service: TransferHistoryService(repository: repository), transferId: 't1');
    await vm.load();
    expect(await vm.exportReceipt('fr'), isNull);
    expect(repository.requests, 0);
    repository.receiptAvailable = true;
    await vm.load();
    expect(await vm.exportReceipt('fr'), [37, 80, 68, 70, 45]);
    expect(repository.requests, 1);
    vm.dispose();
  });
}
