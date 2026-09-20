final class TransferStatusTimelineDto {
  // ===========================================================
  // FIELDS
  // ===========================================================
  final String? previousStatus;
  final String status;
  final DateTime occurredAt;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================
  const TransferStatusTimelineDto({
    required this.previousStatus,
    required this.status,
    required this.occurredAt,
  });

  // ===========================================================
  // JSON
  // ===========================================================
  factory TransferStatusTimelineDto.fromJson(Map<String, dynamic> json) {
    return TransferStatusTimelineDto(
      previousStatus: json['previousStatus'] as String?,
      status: json['status'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
    );
  }
}
