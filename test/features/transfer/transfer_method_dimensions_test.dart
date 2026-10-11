import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pay_flow_ui/features/beneficiaries/domain/service/beneficiary_service.dart';
import 'package:pay_flow_ui/features/transfer/domain/exception/transfer_exception.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_draft_seed.dart';
import 'package:pay_flow_ui/features/transfer/domain/service/transfer_service.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view/transfer_view.dart';
import 'package:pay_flow_ui/features/transfer/presentation/view_model/transfer_view_model.dart';
import 'package:pay_flow_ui/l10n/app_localizations.dart';
import 'transfer_view_model_test.dart' as fixtures;

Future<TransferViewModel> mountForm(WidgetTester tester, {
  double width = 430, double textScale = 1, TransferFailure? failure,
}) async {
  tester.view.physicalSize = Size(width, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final transfers = fixtures.TransfersFake()..quoteFailure = failure;
  final vm = TransferViewModel(
    transferService: TransferService(transfers),
    beneficiaryService: BeneficiaryService(fixtures.BeneficiariesFake()),
    seed: const TransferDraftSeed(beneficiaryId: 'beneficiary-1'),
  );
  await vm.initialize();
  await vm.ensureQuote();
  await tester.pumpWidget(ChangeNotifierProvider.value(
    value: vm,
    child: MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)), child: child!),
      home: const TransferView(),
    ),
  ));
  await tester.pumpAndSettle();
  return vm;
}

void main() {
  for (final width in [320.0, 430.0]) {
    testWidgets('painted funding and reception fields match at width $width', (tester) async {
      final vm = await mountForm(tester, width: width, textScale: 1.3);
      final funding = find.descendant(
        of: find.byKey(const ValueKey('transfer-funding-field')),
        matching: find.byType(InputDecorator));
      expect(funding, findsOneWidget);
      final fundingSize = tester.getSize(funding);
      for (final id in ['mtn', 'wave']) {
        final payoutSize = tester.getSize(find.byKey(ValueKey('transfer-payout-$id')));
        expect(payoutSize.width, fundingSize.width);
        expect(payoutSize.height, fundingSize.height);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      vm.dispose();
    });
  }
  testWidgets('provider outage keeps the contact and shows a retry without a false missing-contact alert', (tester) async {
    final vm = await mountForm(tester, failure: TransferFailure.providerUnavailable);
    expect(find.text('Le service de transfert est momentanément indisponible. Réessayez dans un instant.'), findsOneWidget);
    expect(find.text('Ce bénéficiaire ou sa destination n’est plus disponible.'), findsNothing);
    expect(find.text(fixtures.contact.fullName), findsOneWidget);
    expect(vm.canContinue, isFalse);
    expect(vm.canRequestQuote, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    vm.dispose();
  });
}
