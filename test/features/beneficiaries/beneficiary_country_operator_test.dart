import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/model/beneficiary_contact.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/service/beneficiary_service.dart';
import 'package:pay_flow_ui/features/beneficiaries/presentation/view_model/beneficiary_form_view_model.dart';
import 'beneficiaries_test.dart' show FakeRepository, alice;

class CatalogueRepository extends FakeRepository {
  final BeneficiaryCatalog value;
  final BeneficiaryContact contact;
  CatalogueRepository(this.value, {this.contact = alice});
  @override
  Future<BeneficiaryCatalog> catalog() async => value;
  @override
  Future<BeneficiaryContact> get(String id) async => contact;
}

BeneficiaryCatalog catalogue() => BeneficiaryCatalog(
  [const BeneficiaryCountry('cm', 'Cameroun', 'CM', '+237'),
   const BeneficiaryCountry('cg', 'Congo-Brazzaville', 'CG', '+242')],
  [const BeneficiaryOperator('mtn', 'cm', 'MTN', 'XAF'),
   const BeneficiaryOperator('airtel', 'cg', 'Airtel', 'XAF')],
);

void main() {
  test('country change removes old selection and rejects a foreign operator', () async {
    final repo = CatalogueRepository(catalogue());
    final vm = BeneficiaryFormViewModel(BeneficiaryService(repo));
    await vm.load();
    vm.selectCountry('cm'); vm.selectOperator('mtn');
    expect(vm.operatorId, 'mtn');
    vm.selectCountry('cg');
    expect(vm.operatorId, isNull);
    expect(vm.operators.map((o) => o.id), ['airtel']);
    vm.selectOperator('mtn');
    expect(vm.operatorId, isNull);
    expect(await vm.save('Alice', '+242061234567'), isNull);
    expect(repo.saves, 0);
    vm.dispose();
  });
  test('duplicates for a country produce one dropdown value per operator', () async {
    final base = catalogue();
    final repo = CatalogueRepository(BeneficiaryCatalog(base.countries,
      [...base.operators, base.operators.first]));
    final vm = BeneficiaryFormViewModel(BeneficiaryService(repo));
    await vm.load(); vm.selectCountry('cm');
    expect(vm.operators.length, 1);
    vm.dispose();
  });
  test('editing a stale operator requires choosing an active country operator', () async {
    final repo = CatalogueRepository(catalogue(), contact: const BeneficiaryContact(
      id: 'old', fullName: 'Alice', countryId: 'cg', countryName: 'Congo-Brazzaville',
      countryCode: 'CG', operatorId: 'mtn', phoneE164: '+242061234567'));
    final vm = BeneficiaryFormViewModel(BeneficiaryService(repo), id: 'old');
    await vm.load();
    expect(vm.countryId, 'cg'); expect(vm.operatorId, isNull);
    expect(vm.original!.operatorId, 'mtn'); // History is retained; unavailable option is not selectable.
    expect(await vm.save('Alice', '+242061234567'), isNull);
    expect(repo.saves, 0); vm.dispose();
  });
  test('invalid country cannot inject a valid-looking foreign operator', () async {
    final vm = BeneficiaryFormViewModel(BeneficiaryService(CatalogueRepository(catalogue())));
    await vm.load(); vm.selectCountry('unknown'); vm.selectOperator('mtn');
    expect(vm.countryId, isNull); expect(vm.operatorId, isNull);
    expect(vm.operators, isEmpty); vm.dispose();
  });
}
