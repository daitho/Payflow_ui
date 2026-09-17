import 'transfer_detail_recipient_dto.dart';
import 'transfer_status_timeline_dto.dart';

final class TransferDetailDto {
  // ===========================================================
  // IDENTIFICATION
  // ===========================================================
  final String id;
  final String reference;
  final String status;

  // ===========================================================
  // DATES
  // ===========================================================
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? finalizedAt;
  final DateTime? receivedAt;

  // ===========================================================
  // QUOTE
  // ===========================================================
  final String quoteId;

  // ===========================================================
  // RECIPIENT
  // ===========================================================
  final TransferDetailRecipientDto recipient;

  // ===========================================================
  // SENT AMOUNT
  // ===========================================================
  final num sentAmount;
  final String sourceCurrencyCode;
  final String? sourceCurrencySymbol;

  // ===========================================================
  // FEES / TOTAL
  // ===========================================================
  final num fee;
  final num totalChargedAmount;

  // ===========================================================
  // EXCHANGE RATE
  // ===========================================================
  final num appliedRate;

  // ===========================================================
  // RECEIVED AMOUNT
  // ===========================================================
  final num receivedAmount;
  final String targetCurrencyCode;
  final String? targetCurrencySymbol;

  // ===========================================================
  // PROVIDER
  // ===========================================================
  final String? providerReference;

  // ===========================================================
  // AVAILABLE ACTIONS
  // ===========================================================
  final bool receiptAvailable;
  final bool repeatAllowed;

  // ===========================================================
  // STATUS TIMELINE
  // ===========================================================
  final List<TransferStatusTimelineDto> statusTimeline;

  // ===========================================================
  // CONSTRUCTOR
  // ===========================================================
  const TransferDetailDto({
    required this.id,
    required this.reference,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.finalizedAt,
    required this.receivedAt,
    required this.quoteId,
    required this.recipient,
    required this.sentAmount,
    required this.sourceCurrencyCode,
    required this.sourceCurrencySymbol,
    required this.fee,
    required this.totalChargedAmount,
    required this.appliedRate,
    required this.receivedAmount,
    required this.targetCurrencyCode,
    required this.targetCurrencySymbol,
    required this.providerReference,
    required this.receiptAvailable,
    required this.repeatAllowed,
    required this.statusTimeline,
  });

  // ===========================================================
  // JSON
  // ===========================================================
  factory TransferDetailDto.fromJson(Map<String, dynamic> json) {
    return TransferDetailDto(
      // -------------------------------------------------------
      // IDENTIFICATION
      // -------------------------------------------------------
      id: json['id'] as String,
      reference: json['reference'] as String,
      status: json['status'] as String,

      // -------------------------------------------------------
      // DATES
      // -------------------------------------------------------
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      finalizedAt: json['finalizedAt'] == null
          ? null
          : DateTime.parse(json['finalizedAt'] as String),

      receivedAt: json['receivedAt'] == null
          ? null
          : DateTime.parse(json['receivedAt'] as String),

      // -------------------------------------------------------
      // QUOTE
      // -------------------------------------------------------
      quoteId: json['quoteId'] as String,

      // -------------------------------------------------------
      // RECIPIENT
      // -------------------------------------------------------
      recipient: TransferDetailRecipientDto.fromJson(
        json['recipient'] as Map<String, dynamic>,
      ),

      // -------------------------------------------------------
      // SENT AMOUNT
      // -------------------------------------------------------
      sentAmount: json['sentAmount'] as num,
      sourceCurrencyCode: json['sourceCurrencyCode'] as String,
      sourceCurrencySymbol: json['sourceCurrencySymbol'] as String?,

      // -------------------------------------------------------
      // FEES / TOTAL
      // -------------------------------------------------------
      fee: json['fee'] as num,
      totalChargedAmount: json['totalChargedAmount'] as num,

      // -------------------------------------------------------
      // EXCHANGE RATE
      // -------------------------------------------------------
      appliedRate: json['appliedRate'] as num,

      // -------------------------------------------------------
      // RECEIVED AMOUNT
      // -------------------------------------------------------
      receivedAmount: json['receivedAmount'] as num,
      targetCurrencyCode: json['targetCurrencyCode'] as String,
      targetCurrencySymbol: json['targetCurrencySymbol'] as String?,

      // -------------------------------------------------------
      // PROVIDER
      // -------------------------------------------------------
      providerReference: json['providerReference'] as String?,

      // -------------------------------------------------------
      // ACTIONS
      // -------------------------------------------------------
      receiptAvailable: json['receiptAvailable'] as bool,
      repeatAllowed: json['repeatAllowed'] as bool,

      // -------------------------------------------------------
      // STATUS TIMELINE
      // -------------------------------------------------------
      statusTimeline: (json['statusTimeline'] as List<dynamic>)
          .map(
            (item) => TransferStatusTimelineDto.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
