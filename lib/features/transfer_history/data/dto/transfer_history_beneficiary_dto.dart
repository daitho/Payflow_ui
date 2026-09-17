final class TransferHistoryBeneficiaryDto {
  // ===========================================================
  // FIELDS
  // ===========================================================

  final String id;
  final String displayName;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================

  const TransferHistoryBeneficiaryDto({
    required this.id,
    required this.displayName,
  });

  // ===========================================================
  // JSON
  // ===========================================================

  factory TransferHistoryBeneficiaryDto.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransferHistoryBeneficiaryDto(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
    );
  }
}