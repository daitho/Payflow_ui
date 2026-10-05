import '../model/saved_payment_card.dart';
import '../repository/saved_payment_card_repository.dart';

class SavedPaymentCardService {
  const SavedPaymentCardService(this._repository);
  final SavedPaymentCardRepository _repository;

  Future<List<SavedPaymentCard>> list() => _repository.list();
  Future<SavedPaymentCard> add(NewSavedPaymentCard card) => _repository.add(card);
  Future<void> remove(String id) => _repository.remove(id);
}
