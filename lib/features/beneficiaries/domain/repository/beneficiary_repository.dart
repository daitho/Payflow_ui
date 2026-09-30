import '../model/beneficiary_contact.dart';

abstract interface class BeneficiaryRepository {
  Future<List<BeneficiaryContact>> list();
  Future<BeneficiaryContact> get(String id);
  Future<BeneficiaryCatalog> catalog();
  Future<BeneficiaryContact> save(BeneficiaryContactInput input, {String? id});
  Future<String> ensureSecondaryDestination({
    required String beneficiaryId,
    required String operatorId,
    required String phoneE164,
  });
}
