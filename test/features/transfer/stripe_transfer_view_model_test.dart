import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/payments/domain/test_funding_service.dart';
import 'package:pay_flow_ui/features/payment_cards/domain/model/saved_payment_card.dart';
import 'package:pay_flow_ui/features/payment_cards/domain/service/saved_payment_card_service.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/service/beneficiary_service.dart';
import 'package:pay_flow_ui/features/transfer/domain/service/transfer_service.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_quote.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_draft_seed.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view_model/transfer_view_model.dart';
import 'transfer_view_model_test.dart' as fixtures;

class FundingFake implements TestFundingService {
  String? paymentId = 'stripe-payment-1';
  String? receivedCardId;
  @override bool enabled = true;
  @override bool supported = true;
  @override bool supportsApplePay = false;
  @override bool supportsGooglePay = true;
  @override Future<void> initialize() async {}
  @override Future<SavedPaymentCard?> saveCard() async => null;
  @override Future<String?> pay({required String quoteId, required TransferFundingMethod method,
      String? cardId, required String idempotencyKey}) async {
    receivedCardId = cardId;
    return paymentId;
  }
}

void main() {
  test('selected card and verified payment ID reach the backend; cancellation does not confirm', () async {
    final transfers = fixtures.TransfersFake();
    final funding = FundingFake();
    final cards = fixtures.CardsFake();
    cards.saved = [const SavedPaymentCard(id: 'tokenized-card', holderName: 'Amina',
      brand: 'VISA', lastFour: '4242', expiryMonth: 12, expiryYear: 2030, tokenized: true),
      ...cards.saved];
    final vm = TransferViewModel(transferService: TransferService(transfers),
      beneficiaryService: BeneficiaryService(fixtures.BeneficiariesFake()),
      savedCardService: SavedPaymentCardService(cards), fundingService: funding,
      seed: const TransferDraftSeed(beneficiaryId: 'beneficiary-1'));
    await vm.initialize();
    expect(vm.savedCards.map((card) => card.id), ['tokenized-card']);
    expect(vm.selectedCard!.displayLabel, 'Visa •••• 4242');
    vm.selectFundingMethod(TransferFundingMethod.card);
    funding.paymentId = null;
    expect(await vm.confirm(), isNull);
    expect(transfers.confirmedPaymentIntentId, isNull);
    funding.paymentId = 'stripe-payment-1';
    expect(await vm.confirm(), isNotNull);
    expect(funding.receivedCardId, 'tokenized-card');
    expect(transfers.confirmedCardId, 'tokenized-card');
    expect(transfers.confirmedPaymentIntentId, 'stripe-payment-1');
    expect(transfers.idempotencyKey, 'stripe-stripe-payment-1');
    vm.dispose();
  });

  test('Stripe mode blocks unsupported platforms without reverting to a simulation', () async {
    final funding = FundingFake()..supported = false;
    final vm = TransferViewModel(transferService: TransferService(fixtures.TransfersFake()),
      beneficiaryService: BeneficiaryService(fixtures.BeneficiariesFake()),
      savedCardService: SavedPaymentCardService(fixtures.CardsFake()), fundingService: funding,
      seed: const TransferDraftSeed(beneficiaryId: 'beneficiary-1'));
    await vm.initialize();
    expect(vm.stripeEnabled, isTrue);
    expect(vm.stripeUnsupported, isTrue);
    expect(vm.canContinue, isFalse);
    expect(await vm.confirm(), isNull);
    vm.dispose();
  });
}
