import '../../domain/model/saved_payment_card.dart';
import '../../domain/repository/saved_payment_card_repository.dart';
import '../service_api/saved_payment_card_api_service.dart';

class SavedPaymentCardRepositoryImpl implements SavedPaymentCardRepository {
  const SavedPaymentCardRepositoryImpl(this._api);
  final SavedPaymentCardApiService _api;

  @override
  Future<List<SavedPaymentCard>> list() => _api.list();
  @override
  Future<SavedPaymentCard> add(NewSavedPaymentCard card) => _api.add(card);
  @override
  Future<void> remove(String id) => _api.remove(id);
}
