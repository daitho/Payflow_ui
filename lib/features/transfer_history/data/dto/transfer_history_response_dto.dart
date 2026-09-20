import 'transfer_history_beneficiary_dto.dart';
import 'transfer_history_item_dto.dart';
import 'transfer_history_summary_dto.dart';

final class TransferHistoryResponseDto {
  // ===========================================================
  // HISTORY ITEMS
  // ===========================================================

  final List<TransferHistoryItemDto> items;

  // ===========================================================
  // FILTER OPTIONS
  // ===========================================================

  final List<TransferHistoryBeneficiaryDto> beneficiaries;
  final List<String> availableStatuses;
  final List<int> availableYears;

  // ===========================================================
  // PAGINATION
  // ===========================================================

  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;

  // ===========================================================
  // SUMMARY
  // ===========================================================

  final TransferHistorySummaryDto summary;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================

  const TransferHistoryResponseDto({
    required this.items,
    required this.beneficiaries,
    required this.availableStatuses,
    this.availableYears = const [],
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.summary,
  });

  // ===========================================================
  // JSON
  // ===========================================================

  factory TransferHistoryResponseDto.fromJson(Map<String, dynamic> json) {
    return TransferHistoryResponseDto(
      // -------------------------------------------------------
      // HISTORY ITEMS
      // -------------------------------------------------------

      items: (json['items'] as List<dynamic>)
          .map(
            (item) =>
                TransferHistoryItemDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),

      // -------------------------------------------------------
      // BENEFICIARIES
      // -------------------------------------------------------
      beneficiaries: (json['beneficiaries'] as List<dynamic>)
          .map(
            (item) => TransferHistoryBeneficiaryDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),

      // -------------------------------------------------------
      // AVAILABLE STATUSES
      // -------------------------------------------------------
      availableStatuses: (json['availableStatuses'] as List<dynamic>)
          .map((status) => status as String)
          .toList(growable: false),

      // -------------------------------------------------------
      // PAGINATION
      // -------------------------------------------------------
      availableYears: (json['availableYears'] as List<dynamic>? ?? const [])
          .map((year) => year as int)
          .toList(growable: false),

      page: json['page'] as int,

      size: json['size'] as int,

      totalElements: json['totalElements'] as int,

      totalPages: json['totalPages'] as int,

      hasNext: json['hasNext'] as bool,

      // -------------------------------------------------------
      // SUMMARY
      // -------------------------------------------------------
      summary: TransferHistorySummaryDto.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
    );
  }
}
