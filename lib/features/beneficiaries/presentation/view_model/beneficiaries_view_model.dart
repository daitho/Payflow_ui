import 'package:flutter/foundation.dart';
import '../../domain/model/beneficiary_contact.dart';
import '../../domain/exception/beneficiary_exception.dart';
import '../../domain/service/beneficiary_service.dart';

class BeneficiariesViewModel extends ChangeNotifier {
  final BeneficiaryService service;
  BeneficiariesViewModel(this.service);
  List<BeneficiaryContact> _items = [];
  String _query = '';
  bool loading = false, _disposed = false;
  BeneficiaryFailure? error;
  int _generation = 0;
  List<BeneficiaryContact> get items => List.unmodifiable(
    _items.where(
      (r) => beneficiarySearchKey(
        r.fullName,
      ).contains(beneficiarySearchKey(_query)),
    ),
  );
  void search(String value) {
    _query = value;
    notifyListeners();
  }

  Future<void> load() async {
    final generation = ++_generation;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await service.list();
      if (!_disposed && generation == _generation) _items = result;
    } catch (e) {
      if (!_disposed && generation == _generation) {
        error = e is BeneficiaryException
            ? e.failure
            : BeneficiaryFailure.server;
      }
    } finally {
      if (!_disposed && generation == _generation) {
        loading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
