import '../model/transfer_quote.dart';

abstract final class TransferFundingAvailability {
  static List<TransferFundingMethod> resolve({
    required bool supportsGooglePay,
    required bool hasSavedCard,
  }) {
    return [
      TransferFundingMethod.applePay,
      if (supportsGooglePay) TransferFundingMethod.googlePay,
      TransferFundingMethod.paypal,
      if (hasSavedCard) TransferFundingMethod.card,
    ];
  }
}
