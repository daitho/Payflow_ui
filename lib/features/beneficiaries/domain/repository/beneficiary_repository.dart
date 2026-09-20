import '../model/beneficiary_contact.dart';

abstract interface class BeneficiaryRepository {
  Future<List<BeneficiaryContact>> list();
  Future<BeneficiaryContact> get(String id);
  Future<BeneficiaryCatalog> catalog();
  Future<BeneficiaryContact> save(BeneficiaryContactInput input, {String? id});
}
