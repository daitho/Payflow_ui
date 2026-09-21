import 'transfer_history_item_model.dart';

class TransferHistoryBeneficiaryModel {
  final String id, displayName;
  const TransferHistoryBeneficiaryModel(this.id, this.displayName);
}

class TransferHistoryCurrencyTotalModel {
  final String currencyCode;
  final num amount;
  const TransferHistoryCurrencyTotalModel(this.currencyCode, this.amount);
}

class TransferHistoryPageModel {
  final List<TransferHistoryItemModel> items;
  final List<TransferHistoryBeneficiaryModel> beneficiaries;
  final List<String> availableStatuses;
  final List<int> availableYears;
  final List<TransferHistoryCurrencyTotalModel> sentTotals;
  final int page, transactionCount;
  final bool hasNext;
  TransferHistoryPageModel({
    required List<TransferHistoryItemModel> items,
    required List<TransferHistoryBeneficiaryModel> beneficiaries,
    required List<String> availableStatuses,
    List<int> availableYears = const [],
    required List<TransferHistoryCurrencyTotalModel> sentTotals,
    required this.page,
    required this.transactionCount,
    required this.hasNext,
  }) : items = List.unmodifiable(items),
       beneficiaries = List.unmodifiable(beneficiaries),
       availableStatuses = List.unmodifiable(availableStatuses),
       availableYears = List.unmodifiable(availableYears),
       sentTotals = List.unmodifiable(sentTotals);
}
