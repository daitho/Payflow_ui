import '../../payment_cards/domain/model/saved_payment_card.dart';
import '../../transfer/domain/model/transfer_quote.dart';

/// Provider-neutral contract used by the view models. Card credentials stay in the SDK.
abstract class TestFundingService {
  bool get enabled;
  bool get supported;
  bool get supportsApplePay;
  bool get supportsGooglePay;
  Future<void> initialize();
  Future<SavedPaymentCard?> saveCard();
  Future<String?> pay({required String quoteId, required TransferFundingMethod method,
    String? cardId, required String idempotencyKey});
}
