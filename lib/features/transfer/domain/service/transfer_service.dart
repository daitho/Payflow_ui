import '../exception/transfer_exception.dart';
import '../model/transfer_quote.dart';
import '../repository/transfer_repository.dart';

class TransferService {
  final TransferRepository _repository;
  const TransferService(this._repository);

  Future<TransferQuote> createQuote({
    required String beneficiaryId,
    required String destinationId,
    required num sentAmount,
    required String sentCurrency,
  }) {
    final currency = sentCurrency.trim().toUpperCase();
    if (beneficiaryId.trim().isEmpty ||
        destinationId.trim().isEmpty ||
        sentAmount <= 0 ||
        !RegExp(r'^[A-Z]{3}$').hasMatch(currency)) {
      throw const TransferException(TransferFailure.invalid);
    }
    return _repository.createQuote(
      beneficiaryId: beneficiaryId,
      destinationId: destinationId,
      sentAmount: sentAmount,
      sentCurrency: currency,
    );
  }

  Future<ConfirmedTransfer> confirm({
    required String quoteId,
    required String idempotencyKey,
  }) {
    if (quoteId.trim().isEmpty || idempotencyKey.trim().isEmpty) {
      throw const TransferException(TransferFailure.invalid);
    }
    return _repository.confirm(
      quoteId: quoteId,
      idempotencyKey: idempotencyKey,
    );
  }
}
