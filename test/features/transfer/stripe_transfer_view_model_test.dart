import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pay_flow_ui/l10n/app_localizations.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view/transfer_view.dart';
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
  Completer<void>? initialization;
  String? paymentId = 'stripe-payment-1';
  String? receivedCardId;
  @override bool enabled = true;
  @override bool supported = true;
  @override bool supportsApplePay = false;
  @override bool supportsGooglePay = true;
  @override Future<void> initialize() async { await initialization?.future; }
  @override Future<SavedPaymentCard?> saveCard() async => null;
  @override Future<String?> pay({required String quoteId, required TransferFundingMethod method,
      String? cardId, required String idempotencyKey}) async {
    receivedCardId = cardId;
    return paymentId;
  }
}

class FailingCardsFake extends fixtures.CardsFake {
  @override Future<List<SavedPaymentCard>> list() async => throw StateError('Card list unavailable');
}

void main() {
  TransferViewModel model(FundingFake funding, {fixtures.CardsFake? cards}) => TransferViewModel(
    transferService: TransferService(fixtures.TransfersFake()),
    beneficiaryService: BeneficiaryService(fixtures.BeneficiariesFake()),
    savedCardService: SavedPaymentCardService(cards ?? fixtures.CardsFake()),
    fundingService: funding,
  );

  test('initialization and capability refresh cannot retain an unavailable wallet', () async {
    final funding = FundingFake()..initialization = Completer<void>();
    final vm = model(funding);
    expect(vm.fundingSelectionValue, isNull);
    final initializing = vm.refreshCards();
    expect(vm.paymentConfigurationLoading, isTrue);
    expect(await vm.confirm(), isNull);
    funding.initialization!.complete();
    await initializing;
    expect(vm.fundingMethod, TransferFundingMethod.googlePay);
    expect(vm.fundingSelectionValue, 'GOOGLE_PAY');
    vm.selectFundingMethod(TransferFundingMethod.applePay);
    expect(vm.fundingMethod, TransferFundingMethod.googlePay);
    funding.supportsApplePay = true;
    await vm.refreshCards();
    vm.selectFundingMethod(TransferFundingMethod.applePay);
    expect(vm.fundingSelectionValue, 'APPLE_PAY');
    funding.supportsApplePay = false;
    funding.supportsGooglePay = false;
    await vm.refreshCards();
    expect(vm.fundingSelectionValue, 'PAYPAL');
    vm.dispose();
  });

  test('duplicate card IDs produce one item and deleting the selected card restores a valid choice', () async {
    const card = SavedPaymentCard(id: 'card-token', holderName: 'Amina',
      brand: 'VISA', lastFour: '4242', expiryMonth: 12, expiryYear: 2030, tokenized: true);
    final cards = fixtures.CardsFake()..saved = [card, card];
    final funding = FundingFake()..supportsGooglePay = false;
    final vm = model(funding, cards: cards);
    await vm.refreshCards();
    expect(vm.savedCards, hasLength(1));
    vm.selectFundingMethod(TransferFundingMethod.card);
    expect(vm.fundingSelectionValue, 'card:card-token');
    cards.saved = [];
    await vm.refreshCards();
    expect(vm.fundingSelectionValue, 'PAYPAL');
    vm.dispose();
  });

  test('a card-list failure after wallet detection still removes the stale Apple Pay selection', () async {
    final vm = model(FundingFake()..supportsGooglePay = false, cards: FailingCardsFake());
    await vm.refreshCards();
    expect(vm.paymentConfigurationFailed, isTrue);
    expect(vm.fundingSelectionValue, 'PAYPAL');
    expect(vm.paymentConfigurationLoading, isFalse);
    expect(vm.canContinue, isFalse);
    vm.dispose();
  });

  testWidgets('TransferView stays valid before, during and after Apple Pay disappears', (tester) async {
    final funding = FundingFake()
      ..supportsApplePay = true
      ..initialization = Completer<void>();
    final vm = model(funding);
    await tester.pumpWidget(ChangeNotifierProvider.value(value: vm,
      child: MaterialApp(locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TransferView())));
    expect(tester.takeException(), isNull);
    final initializing = vm.refreshCards();
    funding.supportsApplePay = false;
    await tester.pump();
    expect(tester.takeException(), isNull);
    funding.initialization!.complete();
    await initializing;
    await tester.pump();
    expect(tester.takeException(), isNull);
    final field = tester.widget<DropdownButton<String>>(
      find.byType(DropdownButton<String>));
    expect(field.value, 'GOOGLE_PAY');
    expect(field.items!.where((item) => item.value == field.value), hasLength(1));
    expect(field.items!.any((item) => item.value == 'APPLE_PAY'), isFalse);
    funding.supportsApplePay = true;
    await vm.refreshCards();
    vm.selectFundingMethod(TransferFundingMethod.applePay);
    await tester.pump();
    expect(tester.takeException(), isNull);
    final ready = tester.widget<DropdownButton<String>>(
      find.byType(DropdownButton<String>));
    expect(ready.value, 'APPLE_PAY');
    expect(ready.items!.where((item) => item.value == ready.value), hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
    vm.dispose();
  });

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
