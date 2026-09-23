import '../exception/transfer_exception.dart';
import '../model/transfer_quote.dart';
import '../repository/transfer_repository.dart';

class TransferService {
  final TransferRepository _repository;
  const TransferService(this._repository);

  Future<TransferQuote> createQuote({
    required String beneficiaryId,
    required String destinationId,
    num? sentAmount,
    num? receivedAmount,
    required String sentCurrency,
  }) {
    final currency = sentCurrency.trim().toUpperCase();
    final hasSentAmount = sentAmount != null && sentAmount > 0;
    final hasReceivedAmount = receivedAmount != null && receivedAmount > 0;
    if (beneficiaryId.trim().isEmpty ||
        destinationId.trim().isEmpty ||
        hasSentAmount == hasReceivedAmount ||
        !RegExp(r'^[A-Z]{3}$').hasMatch(currency)) {
      throw const TransferException(TransferFailure.invalid);
    }
    return _repository.createQuote(
      beneficiaryId: beneficiaryId,
      destinationId: destinationId,
      sentAmount: hasSentAmount ? sentAmount : null,
      receivedAmount: hasReceivedAmount ? receivedAmount : null,
      sentCurrency: currency,
    );
  }

  Future<PaypalPaymentIntent> createPaypalPayment({
    required String quoteId,
    required String idempotencyKey,
  }) {
    if (quoteId.trim().isEmpty || idempotencyKey.trim().isEmpty) {
      throw const TransferException(TransferFailure.invalid);
    }
    return _repository.createPaypalPayment(
      quoteId: quoteId,
      idempotencyKey: idempotencyKey,
    );
  }

  Future<PaypalPaymentIntent> capturePaypalPayment({
    required String paymentIntentId,
    required String idempotencyKey,
  }) {
    if (paymentIntentId.trim().isEmpty || idempotencyKey.trim().isEmpty) {
      throw const TransferException(TransferFailure.invalid);
    }
    return _repository.capturePaypalPayment(
      paymentIntentId: paymentIntentId,
      idempotencyKey: idempotencyKey,
    );
  }

  Future<ConfirmedTransfer> confirm({
    required String quoteId,
    required TransferFundingMethod fundingMethod,
    String? paymentIntentId,
    required String idempotencyKey,
  }) {
    if (quoteId.trim().isEmpty ||
        idempotencyKey.trim().isEmpty ||
        (fundingMethod == TransferFundingMethod.paypal &&
            (paymentIntentId == null || paymentIntentId.trim().isEmpty))) {
      throw const TransferException(TransferFailure.invalid);
    }
    return _repository.confirm(
      quoteId: quoteId,
      fundingMethod: fundingMethod,
      paymentIntentId: paymentIntentId,
      idempotencyKey: idempotencyKey,
    );
  }
}
