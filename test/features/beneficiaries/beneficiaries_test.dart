import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/model/beneficiary_contact.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/repository/beneficiary_repository.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/service/beneficiary_service.dart';
import 'package:pay_flow_ui/features/beneficiaries/presentation/view_model/beneficiary_form_view_model.dart';
import 'package:pay_flow_ui/features/beneficiaries/presentation/view_model/beneficiaries_view_model.dart';
import 'package:pay_flow_ui/features/beneficiaries/presentation/widget/beneficiary_avatar.dart';

const alice = BeneficiaryContact(id: 'alice', fullName: 'Émilie Dupont', countryId: 'cm',
  countryName: 'Cameroun', countryCode: 'CM', operatorId: 'mtn',
  phoneE164: '+237690000000', gender: BeneficiaryGender.female);

class FakeRepository implements BeneficiaryRepository {
  int saves = 0;
  String? savedId;
  BeneficiaryContactInput? savedInput;
  final pending = Completer<BeneficiaryContact>();
  @override
  Future<BeneficiaryCatalog> catalog() async => BeneficiaryCatalog(
    [const BeneficiaryCountry('cm', 'Cameroun', 'CM', '237'),
     const BeneficiaryCountry('sn', 'Sénégal', 'SN', '221')],
    [const BeneficiaryOperator('mtn', 'cm', 'MTN', 'XAF'),
     const BeneficiaryOperator('wave', 'sn', 'Wave', 'XOF')]);
  @override
  Future<BeneficiaryContact> get(String id) async => alice;
  @override
  Future<List<BeneficiaryContact>> list() async => [alice];
  @override
  Future<BeneficiaryContact> save(BeneficiaryContactInput input, {String? id}) {
    saves++; savedId = id; savedInput = input; return pending.future;
  }
}

void main() {
  test('all alphabet colors are distinct and stable across case and accents', () {
    expect(BeneficiaryPalette.colors.toSet().length, 26);
    expect(BeneficiaryPalette.forName('Émilie'), BeneficiaryPalette.forName('emma'));
    expect(BeneficiaryPalette.forName('Maffo'), BeneficiaryPalette.forName('maurice'));
    expect(beneficiaryFlag('CM'), '🇨🇲');
  });
  test('search ignores accents and case', () async {
    final vm = BeneficiariesViewModel(BeneficiaryService(FakeRepository()));
    await vm.load(); vm.search('emilie'); expect(vm.items.single.id, 'alice');
    vm.search('absent'); expect(vm.items, isEmpty); vm.dispose();
  });
  test('new form is blank and editing loads stored gender and destination', () async {
    final service = BeneficiaryService(FakeRepository());
    final blank = BeneficiaryFormViewModel(service); await blank.load();
    expect(blank.original, isNull); expect(blank.countryId, isNull); expect(blank.gender, isNull);
    final edit = BeneficiaryFormViewModel(service, id: 'alice'); await edit.load();
    expect(edit.original!.fullName, 'Émilie Dupont'); expect(edit.gender, BeneficiaryGender.female);
    expect(edit.operatorId, 'mtn'); edit.selectCountry('sn');
    expect(edit.operatorId, isNull); expect(edit.operators.single.id, 'wave');
    blank.dispose(); edit.dispose();
  });
  test('save retains edit ID, normalizes phone and blocks double taps', () async {
    final repo = FakeRepository();
    final vm = BeneficiaryFormViewModel(BeneficiaryService(repo), id: 'alice'); await vm.load();
    final save = vm.save(' Émilie  Dupont ', '+237 690 00 00 00');
    expect(await vm.save('Émilie', '+237690000000'), isNull);
    expect(repo.saves, 1); expect(repo.savedId, 'alice');
    expect(repo.savedInput!.phoneE164, '+237690000000');
    expect(repo.savedInput!.fullName, 'Émilie Dupont');
    expect(repo.savedInput!.gender, BeneficiaryGender.female);
    repo.pending.complete(alice); expect(await save, alice); vm.dispose();
  });
}
