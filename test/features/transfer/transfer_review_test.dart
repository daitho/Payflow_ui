import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/service/beneficiary_service.dart';
import 'package:pay_flow_ui/features/payment_cards/domain/model/saved_payment_card.dart';
import 'package:pay_flow_ui/features/payment_cards/domain/service/saved_payment_card_service.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_draft_seed.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_quote.dart';
import 'package:pay_flow_ui/features/transfer/domain/service/transfer_service.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view/transfer_view.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view_model/transfer_view_model.dart';
import 'package:pay_flow_ui/l10n/app_localizations.dart';

import 'stripe_transfer_view_model_test.dart' as stripe;
import 'transfer_view_model_test.dart' as fixtures;

class ReviewFundingFake extends stripe.FundingFake {
  int calls = 0;
  Completer<String?>? pendingPayment;

  @override
  Future<String?> pay({
    required String quoteId,
    required TransferFundingMethod method,
    String? cardId,
    required String idempotencyKey,
  }) async {
    calls++;
    return await pendingPayment?.future;
  }
}

const backKey = ValueKey('transfer-review-back');
const rowNames = ['phone', 'payout', 'sent', 'funding', 'fee'];

Future<TransferViewModel> openReview(
  WidgetTester tester,
  ReviewFundingFake funding, {
  TransferFundingMethod method = TransferFundingMethod.googlePay,
  double width = 430,
  double textScale = 1,
}) async {
  tester.view.physicalSize = Size(width, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  funding.supportsApplePay = true;
  final cards = fixtures.CardsFake()
    ..saved = [
      const SavedPaymentCard(
        id: 'tokenized-card',
        holderName: 'Amina Test',
        brand: 'VISA',
        lastFour: '4242',
        expiryMonth: 12,
        expiryYear: 2030,
        tokenized: true,
      ),
    ];
  final vm = TransferViewModel(
    transferService: TransferService(fixtures.TransfersFake()),
    beneficiaryService: BeneficiaryService(fixtures.BeneficiariesFake()),
    savedCardService: SavedPaymentCardService(cards),
    fundingService: funding,
    seed: const TransferDraftSeed(
      beneficiaryId: 'beneficiary-1',
      sentAmount: 25,
    ),
  );
  await vm.initialize();
  vm.selectFundingMethod(method);
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: vm,
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        ),
        home: const TransferView(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continuer à envoyer'));
  await tester.pumpAndSettle();
  expect(find.byKey(backKey), findsOneWidget);
  expect(tester.takeException(), isNull);
  return vm;
}

Future<void> disposeReview(WidgetTester tester, TransferViewModel vm) async {
  await tester.pumpWidget(const SizedBox.shrink());
  vm.dispose();
}

void main() {
  testWidgets('back restores the form and retains the draft without payment', (
    tester,
  ) async {
    final funding = ReviewFundingFake();
    final vm = await openReview(
      tester,
      funding,
      method: TransferFundingMethod.card,
    );
    final quote = vm.quote;
    await tester.tap(find.byKey(backKey));
    await tester.pumpAndSettle();
    expect(find.byKey(backKey), findsNothing);
    expect(find.byType(TransferView), findsOneWidget);
    expect(find.text('Continuer à envoyer'), findsOneWidget);
    expect(vm.quote, same(quote));
    expect(vm.beneficiary, fixtures.contact);
    expect(vm.fundingSelectionValue, 'card:tokenized-card');
    expect(vm.selectedCard!.lastFour, '4242');
    expect(
      tester.widgetList<TextField>(find.byType(TextField))
          .any((field) => field.controller?.text == '25'),
      isTrue,
    );
    expect(funding.calls, 0);
    // The form is still editable and can open another review.
    vm.selectFundingMethod(TransferFundingMethod.googlePay);
    await tester.pump();
    await tester.tap(find.text('Continuer à envoyer'));
    await tester.pumpAndSettle();
    expect(find.byKey(backKey), findsOneWidget);
    expect(funding.calls, 0);
    await disposeReview(tester, vm);
  });

  testWidgets('system back closes only the review', (tester) async {
    final funding = ReviewFundingFake();
    final vm = await openReview(tester, funding);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(backKey), findsNothing);
    expect(find.byType(TransferView), findsOneWidget);
    expect(vm.fundingMethod, TransferFundingMethod.googlePay);
    expect(funding.calls, 0);
    await disposeReview(tester, vm);
  });

  for (final method in TransferFundingMethod.values) {
    testWidgets('review rows have equal dimensions and order for $method', (
      tester,
    ) async {
      final vm = await openReview(tester, ReviewFundingFake(), method: method);
      final rects = [
        for (final name in rowNames)
          tester.getRect(find.byKey(ValueKey('transfer-review-$name'))),
      ];
      for (final rect in rects) {
        expect(rect.width, rects.first.width);
        expect(rect.height, rects.first.height);
      }
      for (var i = 1; i < rects.length; i++) {
        expect(rects[i].top, closeTo(rects[i - 1].bottom, 0.1));
      }
      if (method == TransferFundingMethod.card) {
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('transfer-review-funding')),
            matching: find.text('Visa •••• 4242'),
          ),
          findsOneWidget,
        );
      }
      await disposeReview(tester, vm);
    });
  }

  testWidgets('narrow review with large text stays readable and back is visible', (
    tester,
  ) async {
    final vm = await openReview(
      tester,
      ReviewFundingFake(),
      width: 320,
      textScale: 2,
    );
    expect(find.byKey(backKey).hitTestable(), findsOneWidget);
    final scroll = find.ancestor(
      of: find.byKey(const ValueKey('transfer-review-funding')),
      matching: find.byType(SingleChildScrollView),
    );
    await tester.drag(scroll, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await disposeReview(tester, vm);
  });

  testWidgets('back waits for an in-progress payment to finish', (tester) async {
    final funding = ReviewFundingFake()..pendingPayment = Completer<String?>();
    final vm = await openReview(tester, funding);
    await tester.tap(find.text('Confirmer le transfert'));
    await tester.pump();
    expect(vm.confirming, isTrue);
    expect(tester.widget<IconButton>(find.byKey(backKey)).onPressed, isNull);
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byKey(backKey), findsOneWidget);
    funding.pendingPayment!.complete(null);
    await tester.pumpAndSettle();
    expect(vm.confirming, isFalse);
    await tester.tap(find.byKey(backKey));
    await tester.pumpAndSettle();
    expect(find.byKey(backKey), findsNothing);
    expect(funding.calls, 1);
    await disposeReview(tester, vm);
  });
}
