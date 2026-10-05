import '../model/saved_payment_card.dart';

abstract class SavedPaymentCardRepository {
  Future<List<SavedPaymentCard>> list();
  Future<SavedPaymentCard> add(NewSavedPaymentCard card);
  Future<void> remove(String id);
}
