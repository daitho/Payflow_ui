import 'package:flutter/foundation.dart';

import '../../domain/model/saved_payment_card.dart';
import '../../domain/service/saved_payment_card_service.dart';

class SavedPaymentCardsViewModel extends ChangeNotifier {
  SavedPaymentCardsViewModel(this._service);
  final SavedPaymentCardService _service;

  List<SavedPaymentCard> _cards = const [];
  List<SavedPaymentCard> get cards => _cards;
  bool loading = false;
  bool saving = false;
  bool failed = false;
  bool _disposed = false;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> load() async {
    loading = true;
    failed = false;
    _notify();
    try {
      final cards = await _service.list();
      if (!_disposed) _cards = cards;
    } catch (_) {
      failed = true;
    } finally {
      loading = false;
      _notify();
    }
  }

  Future<bool> add(NewSavedPaymentCard card) async {
    if (saving) return false;
    saving = true;
    failed = false;
    _notify();
    try {
      final saved = await _service.add(card);
      _cards = [saved, ..._cards];
      return true;
    } catch (_) {
      failed = true;
      return false;
    } finally {
      saving = false;
      _notify();
    }
  }

  Future<bool> remove(String id) async {
    if (saving) return false;
    saving = true;
    failed = false;
    _notify();
    try {
      await _service.remove(id);
      _cards = _cards.where((card) => card.id != id).toList();
      return true;
    } catch (_) {
      failed = true;
      return false;
    } finally {
      saving = false;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
