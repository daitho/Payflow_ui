import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/model/beneficiary_contact.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/model/iban.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/service/beneficiary_service.dart';
import 'package:pay_flow_ui/features/payments/domain/mobile_money_sandbox_funding.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_draft_seed.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_quote.dart';
import 'package:pay_flow_ui/features/transfer/domain/service/transfer_service.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view_model/transfer_view_model.dart';
import 'transfer_view_model_test.dart' as fixtures;

const bankContact=BeneficiaryContact(id:'bank-beneficiary',fullName:'Bank Sandbox',countryId:'fr',countryName:'France',countryCode:'FR',
  destinationId:'bank-destination',operatorId:'bank',operatorName:'Banque · simulation',phoneE164:'+33612345678',currencyCode:'EUR',
  payoutMethod:'BANK_ACCOUNT',maskedIban:'FR •••• 2606');
class BankContacts extends fixtures.BeneficiariesFake {
  BankContacts():super(savedContact:bankContact);
  @override Future<BeneficiaryCatalog> catalog() async => BeneficiaryCatalog(
    [const BeneficiaryCountry('fr','France','FR','33')],
    [const BeneficiaryOperator('bank','fr','Banque · simulation','EUR',payoutMethod:'BANK_ACCOUNT')]);
}
class MobileFunding implements MobileMoneySandboxFunding {
  bool enabled=true;
  int starts=0;
  MobileMoneyFundingProgress? active;
  @override Future<MobileMoneyFundingOptions> options() async => MobileMoneyFundingOptions(enabled:enabled,sourceCurrency:'XAF',activePayment:active,
    providers:enabled ? [const MobileMoneyFundingOption(provider:'MTN_MOMO_CMR',label:'MTN Mobile Money',countryCode:'CM',currency:'XAF',maskedPhone:'•••• 3456')] : []);
  @override Future<MobileMoneyFundingProgress> start({required String quoteId,required String provider,required String idempotencyKey}) async {
    starts++;expect(provider,'MTN_MOMO_CMR');
    return const MobileMoneyFundingProgress(paymentIntentId:'funding',status:'CONSUMED',depositId:'deposit',depositStatus:'COMPLETED',bankStatus:'PENDING',maskedIban:'FR •••• 2606',transferId:'bank-transfer');
  }
  @override Future<MobileMoneyFundingProgress> progress(String id) async => throw StateError('Not needed after server confirmation');
}
void main() {
  test('IBAN normalization and invalid or unsupported account checks',(){
    expect(isSupportedIban('fr14 2004 1010 0505 0001 3m02 606'),isTrue);
    expect(isSupportedIban('FR0020041010050500013M02606'),isFalse);
    expect(isSupportedIban('FR1420041010050500013M0260'),isFalse);
    expect(isSupportedIban('BE68539007547034'),isFalse);
    expect(isSupportedIban('FR1420041010050500013M02606<script>'),isFalse);
  });
  test('bank quote uses server source currency and has mobile-money funding only',() async {
    final mobile=MobileFunding(),transfers=fixtures.TransfersFake();
    final vm=TransferViewModel(transferService:TransferService(transfers),beneficiaryService:BeneficiaryService(BankContacts()),mobileMoneyFunding:mobile,
      seed:const TransferDraftSeed(beneficiaryId:'bank-beneficiary',sentAmount:1000));
    await vm.initialize();await vm.ensureQuote();
    expect(vm.sentCurrency,'XAF');expect(transfers.sentCurrency,'XAF');
    expect(vm.availableFundingMethods,[TransferFundingMethod.mobileMoney]);
    expect(vm.fundingSelectionValue,'MOBILE_MONEY');expect(vm.canContinue,isTrue);
    final result=await vm.confirm();
    expect(result?.id,'bank-transfer');expect(result?.status,'PENDING');expect(mobile.starts,1);
    expect(transfers.confirmedFundingMethod,isNull); // The server worker confirms once after its authenticated deposit check.
    vm.dispose();
  });
  test('missing source configuration blocks bank funding instead of using a card',() async {
    final mobile=MobileFunding()..enabled=false;
    final vm=TransferViewModel(transferService:TransferService(fixtures.TransfersFake()),beneficiaryService:BeneficiaryService(BankContacts()),mobileMoneyFunding:mobile,
      seed:const TransferDraftSeed(beneficiaryId:'bank-beneficiary',sentAmount:1000,sentCurrency:'XAF'));
    await vm.initialize();await vm.ensureQuote();expect(vm.canContinue,isFalse);
    expect(await vm.confirm(),isNull);expect(mobile.starts,0);vm.dispose();
  });
  test('reopening an in-flight transfer recovers its server ID without a new collection',() async {
    final mobile=MobileFunding()..active=const MobileMoneyFundingProgress(paymentIntentId:'existing',status:'CONSUMED',depositId:'existing-deposit',depositStatus:'COMPLETED',bankStatus:'PENDING',maskedIban:'FR •••• 2606',transferId:'existing-transfer');
    final vm=TransferViewModel(transferService:TransferService(fixtures.TransfersFake()),beneficiaryService:BeneficiaryService(BankContacts()),mobileMoneyFunding:mobile);
    await vm.initialize();expect(vm.collectionPending,isTrue);
    final result=await vm.continueMobileMoney();expect(result?.id,'existing-transfer');expect(mobile.starts,0);vm.dispose();
  });
}
