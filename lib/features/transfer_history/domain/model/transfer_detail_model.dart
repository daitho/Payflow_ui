class TransferTimelineEntry {
  final String status;
  final DateTime occurredAt;
  const TransferTimelineEntry(this.status, this.occurredAt);
}

class TransferDetailModel {
  final String id, reference, status, beneficiaryName, operatorName;
  final String countryCode, sourceCurrencyCode, targetCurrencyCode;
  final String? destination;
  final num sentAmount, receivedAmount, fee, totalChargedAmount, appliedRate;
  final DateTime createdAt;
  final List<TransferTimelineEntry> timeline;
  TransferDetailModel({
    required this.id, required this.reference, required this.status,
    required this.beneficiaryName, required this.operatorName,
    required this.countryCode, required this.destination,
    required this.sourceCurrencyCode, required this.targetCurrencyCode,
    required this.sentAmount, required this.receivedAmount, required this.fee,
    required this.totalChargedAmount, required this.appliedRate,
    required this.createdAt, required List<TransferTimelineEntry> timeline,
  }) : timeline = List.unmodifiable(timeline);
}
