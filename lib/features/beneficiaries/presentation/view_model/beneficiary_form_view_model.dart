import 'package:flutter/foundation.dart';
import '../../domain/model/beneficiary_contact.dart';
import '../../domain/exception/beneficiary_exception.dart';
import '../../domain/service/beneficiary_service.dart';

class BeneficiaryFormViewModel extends ChangeNotifier {
  final BeneficiaryService service;
  final String? id;
  BeneficiaryFormViewModel(this.service, {this.id});
  BeneficiaryCatalog? catalog;
  BeneficiaryContact? original;
  String? countryId, operatorId;
  BeneficiaryGender? gender;
  bool loading = true, saving = false, _disposed = false;
  BeneficiaryFailure? error;
  int _generation = 0;
  bool get ready => catalog != null && (id == null || original != null);
  List<BeneficiaryOperator> get operators =>
      catalog?.operators.where((o) => o.countryId == countryId).toList() ?? [];
  Future<void> load() async {
    final generation = ++_generation;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await service.catalog();
      final contact = id == null ? null : await service.get(id!);
      if (_disposed || generation != _generation) return;
      catalog = result;
      original = contact;
      countryId = contact?.countryId;
      operatorId = contact?.operatorId;
      gender = contact?.gender;
    } catch (e) {
      if (!_disposed && generation == _generation)
        error = e is BeneficiaryException
            ? e.failure
            : BeneficiaryFailure.server;
    } finally {
      if (!_disposed && generation == _generation) {
        loading = false;
        notifyListeners();
      }
    }
  }

  void selectCountry(String? value) {
    if (saving || countryId == value) return;
    countryId = value;
    operatorId = null;
    notifyListeners();
  }

  void selectOperator(String? value) {
    if (!saving) {
      operatorId = value;
      notifyListeners();
    }
  }

  void selectGender(BeneficiaryGender? value) {
    if (!saving) {
      gender = value;
      notifyListeners();
    }
  }

  Future<BeneficiaryContact?> save(String fullName, String phone) async {
    if (saving || !ready || _disposed) return null;
    if (countryId == null ||
        operatorId == null ||
        !operators.any((o) => o.id == operatorId)) {
      error = BeneficiaryFailure.invalid;
      notifyListeners();
      return null;
    }
    saving = true;
    error = null;
    notifyListeners();
    try {
      return await service.save(
        BeneficiaryContactInput(
          fullName: fullName,
          countryId: countryId!,
          operatorId: operatorId!,
          phoneE164: phone,
          gender: gender,
        ),
        id: id,
      );
    } catch (e) {
      if (!_disposed)
        error = e is BeneficiaryException
            ? e.failure
            : BeneficiaryFailure.server;
      return null;
    } finally {
      if (!_disposed) {
        saving = false;
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
