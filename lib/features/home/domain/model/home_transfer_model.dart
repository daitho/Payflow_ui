import 'home_transfer_status.dart';

class HomeTransferModel {
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

  final HomeTransferStatus status;

  final DateTime createdAt;
  final DateTime? finalizedAt;

  const HomeTransferModel({
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
}