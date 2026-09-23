enum TransferFundingMethod {
  applePay,
  googlePay,
  paypal,
  card,
}

extension TransferFundingMethodApi on TransferFundingMethod {
  String get apiValue => switch (this) {
    TransferFundingMethod.applePay => 'APPLE_PAY',
    TransferFundingMethod.googlePay => 'GOOGLE_PAY',
    TransferFundingMethod.paypal => 'PAYPAL',
    TransferFundingMethod.card => 'CARD',
  };
}

class PaypalPaymentIntent {
  final String id;
  final String status;
  final String? approvalUrl;

  const PaypalPaymentIntent({
    required this.id,
    required this.status,
    this.approvalUrl,
  });

  bool get requiresPayerAction =>
      status.toUpperCase() == 'PAYER_ACTION_REQUIRED' &&
      approvalUrl?.trim().isNotEmpty == true;

  bool get completed {
    final normalized = status.toUpperCase();
    return normalized == 'COMPLETED' || normalized == 'CONSUMED';
  }
}

class TransferQuote {
  final String id;
  final String beneficiaryId;
  final String destinationId;
  final num sentAmount;
  final String sentCurrency;
  final num customerRate;
  final num fee;
  final num totalDebited;
  final num receivedAmount;
  final String receivedCurrency;
  final DateTime expiresAt;
  final String status;

  const TransferQuote({
    required this.id,
    required this.beneficiaryId,
    required this.destinationId,
    required this.sentAmount,
    required this.sentCurrency,
    required this.customerRate,
    required this.fee,
    required this.totalDebited,
    required this.receivedAmount,
    required this.receivedCurrency,
    required this.expiresAt,
    required this.status,
  });

  bool get isUsable =>
      status.toUpperCase() == 'ACTIVE' && DateTime.now().isBefore(expiresAt);
}

class ConfirmedTransfer {
  final String id;
  final String status;

  const ConfirmedTransfer({required this.id, required this.status});
}
