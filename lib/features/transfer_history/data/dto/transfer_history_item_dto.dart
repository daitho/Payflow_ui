final class TransferHistoryItemDto {
  // ===========================================================
  // FIELDS
  // ===========================================================
  final String id;
  final String reference;
  final String beneficiaryId;
  final String beneficiaryName;
  final num sentAmount;
  final String sourceCurrencyCode;
  final num receivedAmount;
  final String targetCurrencyCode;
  final String status;
  final DateTime createdAt;
  final DateTime? receivedAt;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================
  const TransferHistoryItemDto({
    required this.id,
    required this.reference,
    required this.beneficiaryId,
    required this.beneficiaryName,
    required this.sentAmount,
    required this.sourceCurrencyCode,
    required this.receivedAmount,
    required this.targetCurrencyCode,
    required this.status,
    required this.createdAt,
    required this.receivedAt,
  });

  // ===========================================================
  // JSON
  // ===========================================================
  factory TransferHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return TransferHistoryItemDto(
      id: json['id'] as String,
      reference: json['reference'] as String,
      beneficiaryId: json['beneficiaryId'] as String,
      beneficiaryName: json['beneficiaryName'] as String,
      sentAmount: json['sentAmount'] as num,
      sourceCurrencyCode: json['sourceCurrencyCode'] as String,
      receivedAmount: json['receivedAmount'] as num,
      targetCurrencyCode: json['targetCurrencyCode'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      receivedAt: json['receivedAt'] == null
          ? null
          : DateTime.parse(json['receivedAt'] as String),
    );
  }
}
