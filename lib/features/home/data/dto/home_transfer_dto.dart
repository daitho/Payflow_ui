class HomeTransferDto {
  final String id;
  final String reference;

  final String beneficiaryId;
  final String? beneficiaryName;

  final num sentAmount;
  final num receivedAmount;

  final String sourceCurrencyId;
  final String sourceCurrencyCode;
  final String? sourceCurrencySymbol;

  final String targetCurrencyId;
  final String targetCurrencyCode;
  final String? targetCurrencySymbol;

  final String status;

  final DateTime createdAt;
  final DateTime? finalizedAt;

  const HomeTransferDto({
    required this.id,
    required this.reference,
    required this.beneficiaryId,
    required this.beneficiaryName,
    required this.sentAmount,
    required this.receivedAmount,
    required this.sourceCurrencyId,
    required this.sourceCurrencyCode,
    required this.sourceCurrencySymbol,
    required this.targetCurrencyId,
    required this.targetCurrencyCode,
    required this.targetCurrencySymbol,
    required this.status,
    required this.createdAt,
    required this.finalizedAt,
  });

  factory HomeTransferDto.fromJson(Map<String, dynamic> json) {
    return HomeTransferDto(
      id: json['id'] as String,
      reference: json['reference'] as String,

      beneficiaryId: json['beneficiaryId'] as String,

      beneficiaryName: json['beneficiaryName'] as String?,

      sentAmount: json['sentAmount'] as num,

      receivedAmount: json['receivedAmount'] as num,

      sourceCurrencyId: json['sourceCurrencyId'] as String,

      sourceCurrencyCode: json['sourceCurrencyCode'] as String,

      sourceCurrencySymbol: json['sourceCurrencySymbol'] as String?,

      targetCurrencyId: json['targetCurrencyId'] as String,

      targetCurrencyCode: json['targetCurrencyCode'] as String,

      targetCurrencySymbol: json['targetCurrencySymbol'] as String?,

      status: json['status'] as String,

      createdAt: DateTime.parse(json['createdAt'] as String),

      finalizedAt: json['finalizedAt'] == null
          ? null
          : DateTime.parse(json['finalizedAt'] as String),
    );
  }
}
