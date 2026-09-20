import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/exception/transfer_history_exception.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_detail_model.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_history_filter.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_history_item_model.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_history_page_model.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/repository/transfer_history_repository.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/service/transfer_history_service.dart';
import 'package:pay_flow_ui/features/transfer_history/presentation/view_model/transfer_history_view_model.dart';

class PendingRequest {
  final TransferHistoryFilter filter;
  final int page;
  final completer = Completer<TransferHistoryPageModel>();
  PendingRequest(this.filter, this.page);
}

class FakeRepository implements TransferHistoryRepository {
  final requests = <PendingRequest>[];
  TransferHistoryFilter? exportedFilter;
  String? exportedLocale;
  Completer<List<int>>? document;
  @override
  Future<List<int>> getStatement(TransferHistoryFilter filter, String locale) {
    exportedFilter = filter;
    exportedLocale = locale;
    document = Completer<List<int>>();
    return document!.future;
  }

  @override
  Future<List<int>> getReceipt(String transferId, String locale) =>
      throw UnimplementedError();
  @override
  Future<TransferHistoryPageModel> getHistory({
    required TransferHistoryFilter filter,
    required int page,
    int size = 20,
  }) {
    final request = PendingRequest(filter, page);
    requests.add(request);
    return request.completer.future;
  }

  @override
  Future<TransferDetailModel> getDetail(String transferId) =>
      throw UnimplementedError();
}

TransferHistoryItemModel item(String id) => TransferHistoryItemModel(
  id: id,
  reference: id,
  beneficiaryName: 'Alice',
  status: 'COMPLETED',
  sentAmount: 10,
  receivedAmount: 6500,
  sourceCurrencyCode: 'EUR',
  targetCurrencyCode: 'XAF',
  createdAt: DateTime.utc(2026, 9, 17),
);

TransferHistoryPageModel page(
  List<String> ids, {
  int index = 0,
  bool more = false,
}) => TransferHistoryPageModel(
  items: ids.map(item).toList(),
  beneficiaries: [],
  availableStatuses: ['COMPLETED'],
  sentTotals: [
    const TransferHistoryCurrencyTotalModel('EUR', 10),
    const TransferHistoryCurrencyTotalModel('USD', 20),
  ],
  page: index,
  transactionCount: 3,
  hasNext: more,
);

void main() {
  late FakeRepository repository;
  late TransferHistoryViewModel vm;
  setUp(() {
    repository = FakeRepository();
    vm = TransferHistoryViewModel(
      service: TransferHistoryService(repository: repository),
    );
  });

  test('a filter change ignores an older response', () async {
    final old = vm.refresh();
    final current = vm.setFilter(
      const TransferHistoryFilter(status: 'COMPLETED'),
    );
    expect(repository.requests.last.filter.status, 'COMPLETED');
    expect(repository.requests.last.page, 0);
    repository.requests.last.completer.complete(page(['new']));
    await current;
    repository.requests.first.completer.complete(page(['old']));
    await old;
    expect(vm.items.single.id, 'new');
    expect(vm.page!.sentTotals.map((total) => total.currencyCode), [
      'EUR',
      'USD',
    ]);
    vm.dispose();
  });

  test(
    'pagination appends without duplicates and blocks concurrent loads',
    () async {
      final first = vm.refresh();
      repository.requests[0].completer.complete(page(['a'], more: true));
      await first;
      final next = vm.loadMore();
      await vm.loadMore();
      expect(repository.requests.length, 2);
      expect(repository.requests[1].page, 1);
      repository.requests[1].completer.complete(page(['a', 'b'], index: 1));
      await next;
      expect(vm.items.map((item) => item.id), ['a', 'b']);
      await vm.loadMore();
      expect(repository.requests.length, 2);
      vm.dispose();
    },
  );

  test('failed next page keeps items and can retry the same page', () async {
    final first = vm.refresh();
    repository.requests[0].completer.complete(page(['a'], more: true));
    await first;
    final next = vm.loadMore();
    repository.requests[1].completer.completeError(
      const TransferHistoryException(TransferHistoryFailure.network),
    );
    await next;
    expect(vm.items.single.id, 'a');
    expect(vm.error, TransferHistoryFailure.network);
    final retry = vm.loadMore();
    expect(repository.requests[2].page, 1);
    repository.requests[2].completer.complete(page(['b'], index: 1));
    await retry;
    expect(vm.error, isNull);
    expect(vm.items.map((item) => item.id), ['a', 'b']);
    vm.dispose();
  });

  test('refresh invalidates an in-flight next page', () async {
    final first = vm.refresh();
    repository.requests[0].completer.complete(page(['a'], more: true));
    await first;
    final next = vm.loadMore();
    final refresh = vm.refresh();
    repository.requests[2].completer.complete(page(['fresh']));
    await refresh;
    repository.requests[1].completer.complete(page(['stale'], index: 1));
    await next;
    expect(vm.items.single.id, 'fresh');
    vm.dispose();
  });

  test('completion after disposal does not notify listeners', () async {
    var notifications = 0;
    vm.addListener(() => notifications++);
    final request = vm.refresh();
    expect(notifications, 1);
    vm.dispose();
    repository.requests.single.completer.complete(page(['a']));
    await request;
    expect(notifications, 1);
  });

  test(
    'summary and export cover the full active filter, not the loaded page',
    () async {
      final first = vm.setFilter(
        const TransferHistoryFilter(
          beneficiaryId: 'alice',
          status: 'COMPLETED',
          year: 2024,
        ),
      );
      repository.requests.single.completer.complete(page(['a'], more: true));
      await first;
      expect(vm.items.length, 1);
      expect(vm.page!.transactionCount, 3);
      final export = vm.exportHistory('fr-FR');
      expect(repository.exportedFilter!.beneficiaryId, 'alice');
      expect(repository.exportedFilter!.status, 'COMPLETED');
      expect(repository.exportedFilter!.year, 2024);
      expect(repository.requests.single.filter.year, 2024);
      expect(repository.exportedLocale, 'fr-FR');
      expect(vm.isExporting, isTrue);
      await vm.setFilter(const TransferHistoryFilter());
      expect(vm.filter.beneficiaryId, 'alice');
      repository.document!.complete([37, 80, 68, 70, 45]);
      expect(await export, [37, 80, 68, 70, 45]);
      expect(vm.isExporting, isFalse);
      vm.dispose();
    },
  );

  test('export failure preserves results and reports its own error', () async {
    final first = vm.refresh();
    repository.requests.single.completer.complete(page(['a']));
    await first;
    final export = vm.exportHistory('en');
    repository.document!.completeError(
      const TransferHistoryException(TransferHistoryFailure.network),
    );
    expect(await export, isNull);
    expect(vm.exportError, TransferHistoryFailure.network);
    expect(vm.error, isNull);
    expect(vm.items.single.id, 'a');
    expect(vm.isExporting, isFalse);
    vm.dispose();
  });
}
