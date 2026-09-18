import 'transfer_history_currency_total_dto.dart';

final class TransferHistorySummaryDto {
  // ===========================================================
  // FIELDS
  // ===========================================================

  final int transactionCount;

  final List<TransferHistoryCurrencyTotalDto>
  sentTotals;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================

  const TransferHistorySummaryDto({
    required this.transactionCount,
    required this.sentTotals,
  });

  // ===========================================================
  // JSON
  // ===========================================================

  factory TransferHistorySummaryDto.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransferHistorySummaryDto(
      transactionCount:
      json['transactionCount'] as int,

      sentTotals:
      (json['sentTotals'] as List<dynamic>)
          .map(
            (item) =>
            TransferHistoryCurrencyTotalDto
                .fromJson(
              item as Map<String, dynamic>,
            ),
      )
          .toList(),
    );
  }
}
