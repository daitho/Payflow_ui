class TransferHistoryItemModel {
  final String id, reference, beneficiaryName, status;
  final num sentAmount, receivedAmount;
  final String sourceCurrencyCode, targetCurrencyCode;
  final DateTime createdAt;
  const TransferHistoryItemModel({
    required this.id,
    required this.reference,
    required this.beneficiaryName,
    required this.status,
    required this.sentAmount,
    required this.receivedAmount,
    required this.sourceCurrencyCode,
    required this.targetCurrencyCode,
    required this.createdAt,
  });
}
