import '../../domain/model/transfer_quote.dart';

final class TransferQuoteDto {
  final Map<String, dynamic> json;
  const TransferQuoteDto(this.json);

  TransferQuote toDomain() => TransferQuote(
    id: json['quoteId'] as String,
    beneficiaryId: json['beneficiaryId'] as String,
    destinationId: json['destinationId'] as String,
    sentAmount: json['sentAmount'] as num,
    sentCurrency: json['sentCurrency'] as String,
    customerRate: json['customerRate'] as num,
    fee: json['fee'] as num,
    totalDebited: json['totalDebited'] as num,
    receivedAmount: json['receivedAmount'] as num,
    receivedCurrency: json['receivedCurrency'] as String,
    expiresAt: DateTime.parse(json['expiresAt'] as String),
    status: json['status'] as String,
  );
}

final class ConfirmedTransferDto {
  final Map<String, dynamic> json;
  const ConfirmedTransferDto(this.json);

  ConfirmedTransfer toDomain() => ConfirmedTransfer(
    id: json['transferId'] as String,
    status: json['status'] as String,
  );
}
