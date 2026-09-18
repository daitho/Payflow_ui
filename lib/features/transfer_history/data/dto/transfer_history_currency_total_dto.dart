final class TransferHistoryCurrencyTotalDto {
  // ===========================================================
  // FIELDS
  // ===========================================================

  final String currencyCode;
  final num amount;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================

  const TransferHistoryCurrencyTotalDto({
    required this.currencyCode,
    required this.amount,
  });

  // ===========================================================
  // JSON
  // ===========================================================

  factory TransferHistoryCurrencyTotalDto.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransferHistoryCurrencyTotalDto(
      currencyCode:
      json['currencyCode'] as String,

      amount:
      json['amount'] as num,
    );
  }
}
