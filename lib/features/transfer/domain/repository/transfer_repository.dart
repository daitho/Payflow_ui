import '../model/transfer_quote.dart';

abstract interface class TransferRepository {
  Future<TransferQuote> createQuote({
    required String beneficiaryId,
    required String destinationId,
    required num sentAmount,
    required String sentCurrency,
  });

  Future<ConfirmedTransfer> confirm({
    required String quoteId,
    required String idempotencyKey,
  });
}
