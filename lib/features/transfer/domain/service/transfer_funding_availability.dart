import '../model/transfer_quote.dart';

abstract final class TransferFundingAvailability {
  static List<TransferFundingMethod> resolve({
    bool supportsApplePay = true,
    required bool supportsGooglePay,
    required bool hasSavedCard,
  }) {
    return [
      if (supportsApplePay) TransferFundingMethod.applePay,
      if (supportsGooglePay) TransferFundingMethod.googlePay,
      TransferFundingMethod.paypal,
      if (hasSavedCard) TransferFundingMethod.card,
    ];
  }
}
