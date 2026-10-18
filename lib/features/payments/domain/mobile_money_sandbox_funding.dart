class MobileMoneyFundingOption {
  final String provider, label, countryCode, currency, maskedPhone;
  const MobileMoneyFundingOption({required this.provider, required this.label,
    required this.countryCode, required this.currency, required this.maskedPhone});
}

class MobileMoneyFundingProgress {
  final String paymentIntentId, status, depositId, depositStatus, bankStatus, maskedIban;
  final String? transferId;
  const MobileMoneyFundingProgress({required this.paymentIntentId, required this.status,
    required this.depositId, required this.depositStatus, required this.bankStatus,
    required this.maskedIban, this.transferId});
  bool get terminal => status == 'FAILED' || status == 'REFUNDED' || status == 'CANCELLED';
  bool get pending => !terminal && transferId == null;
}

class MobileMoneyFundingOptions {
  final bool enabled;
  final String? sourceCurrency;
  final List<MobileMoneyFundingOption> providers;
  final MobileMoneyFundingProgress? activePayment;
  const MobileMoneyFundingOptions({required this.enabled, this.sourceCurrency,
    this.providers = const [], this.activePayment});
}

abstract class MobileMoneySandboxFunding {
  Future<MobileMoneyFundingOptions> options();
  Future<MobileMoneyFundingProgress> start({required String quoteId,
    required String provider, required String idempotencyKey});
  Future<MobileMoneyFundingProgress> progress(String paymentId);
}
