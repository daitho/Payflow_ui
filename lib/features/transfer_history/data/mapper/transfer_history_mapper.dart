import '../dto/transfer_detail_dto.dart';
import '../dto/transfer_history_response_dto.dart';
import '../../domain/model/transfer_detail_model.dart';
import '../../domain/model/transfer_history_item_model.dart';
import '../../domain/model/transfer_history_page_model.dart';

abstract final class TransferHistoryMapper {
  static TransferHistoryPageModel page(TransferHistoryResponseDto dto) {
    return TransferHistoryPageModel(
      items: dto.items.map((item) => TransferHistoryItemModel(
        id: item.id, reference: item.reference,
        beneficiaryName: item.beneficiaryName, status: item.status,
        sentAmount: item.sentAmount, receivedAmount: item.receivedAmount,
        sourceCurrencyCode: item.sourceCurrencyCode,
        targetCurrencyCode: item.targetCurrencyCode, createdAt: item.createdAt,
      )).toList(),
      beneficiaries: dto.beneficiaries.map((item) =>
        TransferHistoryBeneficiaryModel(item.id, item.displayName)).toList(),
      availableStatuses: dto.availableStatuses,
      sentTotals: dto.summary.sentTotals.map((item) =>
        TransferHistoryCurrencyTotalModel(item.currencyCode, item.amount)).toList(),
      page: dto.page, transactionCount: dto.summary.transactionCount,
      hasNext: dto.hasNext,
    );
  }

  static TransferDetailModel detail(TransferDetailDto dto) {
    return TransferDetailModel(
      id: dto.id, reference: dto.reference, status: dto.status,
      beneficiaryName: dto.recipient.beneficiaryName,
      operatorName: dto.recipient.operatorName,
      countryCode: dto.recipient.countryIsoCode2,
      destination: dto.recipient.maskedReference ?? dto.recipient.phoneE164,
      sourceCurrencyCode: dto.sourceCurrencyCode,
      targetCurrencyCode: dto.targetCurrencyCode,
      sentAmount: dto.sentAmount, receivedAmount: dto.receivedAmount,
      fee: dto.fee, totalChargedAmount: dto.totalChargedAmount,
      appliedRate: dto.appliedRate, createdAt: dto.createdAt,
      receivedAt: dto.receivedAt, providerReference: dto.providerReference,
      receiptAvailable: dto.receiptAvailable, repeatAllowed: dto.repeatAllowed,
      timeline: dto.statusTimeline.map((item) =>
        TransferTimelineEntry(item.status, item.occurredAt)).toList(),
    );
  }
}
