import '../model/beneficiary_contact.dart';
import '../repository/beneficiary_repository.dart';
import '../exception/beneficiary_exception.dart';

class BeneficiaryService {
  final BeneficiaryRepository repository;
  BeneficiaryService(this.repository);
  Future<List<BeneficiaryContact>> list() => repository.list();
  Future<BeneficiaryContact> get(String id) => repository.get(id);
  Future<BeneficiaryCatalog> catalog() => repository.catalog();
  Future<BeneficiaryContact> save(BeneficiaryContactInput input, {String? id}) {
    final name = input.fullName.trim().replaceAll(RegExp(r'\s+'), ' ');
    final phone = input.phoneE164.replaceAll(RegExp(r'[\s().-]'), '');
    if (name.isEmpty || name.length > 120 ||
        !RegExp(r'^\+[1-9][0-9]{6,14}$').hasMatch(phone)) {
      throw const BeneficiaryException(BeneficiaryFailure.invalid);
    }
    return repository.save(BeneficiaryContactInput(fullName: name,
      countryId: input.countryId, operatorId: input.operatorId,
      phoneE164: phone, gender: input.gender), id: id);
  }
}
