import '../model/transfer_quote.dart';

abstract interface class TransferRepository {
  Future<TransferQuote> createQuote({
    required String beneficiaryId,
    required String destinationId,
    num? sentAmount,
    num? receivedAmount,
    required String sentCurrency,
  });

  Future<PaypalPaymentIntent> createPaypalPayment({
    required String quoteId,
    required String idempotencyKey,
  });

  Future<PaypalPaymentIntent> capturePaypalPayment({
    required String paymentIntentId,
    required String idempotencyKey,
  });

  Future<ConfirmedTransfer> confirm({
    required String quoteId,
    required TransferFundingMethod fundingMethod,
    String? paymentIntentId,
    required String idempotencyKey,
  });
}
