import 'package:flutter/foundation.dart';
import '../../domain/model/beneficiary_contact.dart';
import '../../domain/model/iban.dart';
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
  List<BeneficiaryOperator> get operators {
    if (!(catalog?.countries.any((c) => c.id == countryId) ?? false)) {
      return const [];
    }
    // One dropdown value per operator, scoped to the selected country.
    final byId = <String, BeneficiaryOperator>{};
    for (final operator in catalog!.operators) {
      if (operator.countryId == countryId) {
        byId.putIfAbsent(operator.id, () => operator);
      }
    }
    return List.unmodifiable(byId.values);
  }
  bool get isBankAccount => operators.any((o) => o.id == operatorId && o.isBankAccount);
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
      operatorId = operators.any((o) => o.id == contact?.operatorId)
          ? contact?.operatorId
          : null;
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
    if (saving || _disposed || countryId == value) return;
    if (value != null && !(catalog?.countries.any((c) => c.id == value) ?? false)) {
      return;
    }
    countryId = value;
    operatorId = null;
    notifyListeners();
  }

  void selectOperator(String? value) {
    if (saving || _disposed) return;
    if (value != null && !operators.any((o) => o.id == value)) return;
    operatorId = value;
    notifyListeners();
  }

  void selectGender(BeneficiaryGender? value) {
    if (!saving) {
      gender = value;
      notifyListeners();
    }
  }

  Future<BeneficiaryContact?> save(String fullName, String phone, {String? iban}) async {
    if (saving || !ready || _disposed) return null;
    if (countryId == null ||
        !catalog!.countries.any((c) => c.id == countryId) ||
        operatorId == null ||
        !operators.any((o) => o.id == operatorId)) {
      error = BeneficiaryFailure.invalid;
      notifyListeners();
      return null;
    }
    if (isBankAccount && (iban == null || !isSupportedIban(iban))) {
      error = BeneficiaryFailure.invalid; notifyListeners(); return null;
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
          iban: isBankAccount ? normalizeIban(iban!) : null,
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

