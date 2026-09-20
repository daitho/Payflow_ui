import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/model/beneficiary_contact.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/repository/beneficiary_repository.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/service/beneficiary_service.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_draft_seed.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_quote.dart';
import 'package:pay_flow_ui/features/transfer/domain/repository/transfer_repository.dart';
import 'package:pay_flow_ui/features/transfer/domain/service/transfer_service.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view_model/transfer_view_model.dart';

const contact = BeneficiaryContact(
  id: 'beneficiary-1',
  fullName: 'Amina Test',
  countryId: 'country-cm',
  countryName: 'Cameroun',
  countryCode: 'CM',
  destinationId: 'destination-1',
  operatorId: 'mtn',
  operatorName: 'MTN',
  phoneE164: '+237690000000',
  currencyCode: 'XAF',
);

class BeneficiariesFake implements BeneficiaryRepository {
  @override
  Future<BeneficiaryContact> get(String id) async => contact;
  @override
  Future<List<BeneficiaryContact>> list() async => [contact];
  @override
  Future<BeneficiaryCatalog> catalog() => throw UnimplementedError();
  @override
  Future<BeneficiaryContact> save(BeneficiaryContactInput input, {String? id}) =>
      throw UnimplementedError();
}

class TransfersFake implements TransferRepository {
  int quoteRequests = 0;
  String? beneficiaryId, destinationId, sentCurrency, idempotencyKey;
  num? sentAmount;

  @override
  Future<TransferQuote> createQuote({required String beneficiaryId,
      required String destinationId, required num sentAmount,
      required String sentCurrency}) async {
    quoteRequests++;
    this.beneficiaryId = beneficiaryId;
    this.destinationId = destinationId;
    this.sentAmount = sentAmount;
    this.sentCurrency = sentCurrency;
    return TransferQuote(
      id: 'quote-1', beneficiaryId: beneficiaryId,
      destinationId: destinationId, sentAmount: sentAmount,
      sentCurrency: sentCurrency, customerRate: 655.96, fee: 1,
      totalDebited: sentAmount + 1, receivedAmount: sentAmount * 655.96,
      receivedCurrency: 'XAF', expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      status: 'ACTIVE');
  }

  @override
  Future<ConfirmedTransfer> confirm({required String quoteId,
      required String idempotencyKey}) async {
    this.idempotencyKey = idempotencyKey;
    return const ConfirmedTransfer(id: 'transfer-1', status: 'COMPLETED');
  }
}

void main() {
  test('repeat seed resolves beneficiary and requests backend quote', () async {
    final transfers = TransfersFake();
    final vm = TransferViewModel(
      transferService: TransferService(transfers),
      beneficiaryService: BeneficiaryService(BeneficiariesFake()),
      seed: const TransferDraftSeed(
        beneficiaryId: 'beneficiary-1', sentAmount: 25, sentCurrency: 'eur'),
    );
    await vm.initialize();
    expect(vm.beneficiary, contact);
    expect(transfers.beneficiaryId, 'beneficiary-1');
    expect(transfers.destinationId, 'destination-1');
    expect(transfers.sentAmount, 25);
    expect(transfers.sentCurrency, 'EUR');
    expect(vm.quote!.receivedCurrency, 'XAF');
    vm.dispose();
  });

  test('confirmation reuses the active quote and sends idempotency key', () async {
    final transfers = TransfersFake();
    final vm = TransferViewModel(
      transferService: TransferService(transfers),
      beneficiaryService: BeneficiaryService(BeneficiariesFake()),
      seed: const TransferDraftSeed(beneficiaryId: 'beneficiary-1'),
    );
    await vm.initialize();
    final result = await vm.confirm();
    expect(result!.id, 'transfer-1');
    expect(transfers.quoteRequests, 1);
    expect(transfers.idempotencyKey, isNotEmpty);
    vm.dispose();
  });
}
