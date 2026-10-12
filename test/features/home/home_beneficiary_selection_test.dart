import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pay_flow_ui/features/home/domain/model/home_beneficiary_model.dart';
import 'package:pay_flow_ui/features/home/domain/model/home_model.dart';
import 'package:pay_flow_ui/features/home/domain/model/home_user_model.dart';
import 'package:pay_flow_ui/features/home/domain/repository/home_repository.dart';
import 'package:pay_flow_ui/features/home/domain/service/home_service.dart';
import 'package:pay_flow_ui/features/home/presentation/view/home_view.dart';
import 'package:pay_flow_ui/features/home/presentation/view_model/home_view_model.dart';
import 'package:pay_flow_ui/l10n/app_localizations.dart';

const contacts = [
  HomeBeneficiaryModel(
    id: 'a', displayName: 'Alice Adkins', countryId: 'cm',
    countryIsoCode2: 'CM', countryFlagUrl: null,
    phoneE164: '+237670123456', operatorName: 'MTN Mobile Money', favorite: false,
  ),
  HomeBeneficiaryModel(
    id: 'b', displayName: 'Benoit Martin', countryId: 'cm',
    countryIsoCode2: 'CM', countryFlagUrl: null,
    phoneE164: '+237690123456', operatorName: 'Orange Money', favorite: false,
  ),
  HomeBeneficiaryModel(
    id: 'c', displayName: 'Chloe Dupont', countryId: 'cm',
    countryIsoCode2: 'CM', countryFlagUrl: null,
    phoneE164: '+237670234567', operatorName: 'MTN Mobile Money', favorite: false,
  ),
  HomeBeneficiaryModel(
    id: 'd', displayName: 'David Michel', countryId: 'cm',
    countryIsoCode2: 'CM', countryFlagUrl: null,
    phoneE164: '+237690234567', operatorName: 'Orange Money', favorite: false,
  ),
];

class _HomeRepository implements HomeRepository {
  @override
  Future<HomeModel> getHome() async => const HomeModel(
    user: HomeUserModel(publicId: 'user', firstName: 'Gaston', lastName: 'Adkins', verified: true),
    exchangeRate: null,
    recentBeneficiaries: contacts,
    recentTransactions: [],
  );
}

class _Harness extends StatefulWidget {
  const _Harness({this.reduceMotion = false, this.textScale = 1});
  final bool reduceMotion;
  final double textScale;
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  HomeBeneficiaryModel? selected;
  String? openedBeneficiaryId;
  int transferOpenCount = 0;
  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: widget.reduceMotion,
        textScaler: TextScaler.linear(widget.textScale),
      ),
      child: child!,
    ),
    home: Scaffold(
      body: HomeView(
        selectedBeneficiary: selected,
        onBeneficiarySelected: (contact) => setState(() => selected = contact),
        onBeneficiaryCleared: () => setState(() => selected = null),
        onTransferTap: () {
          openedBeneficiaryId = selected?.id;
          transferOpenCount++;
        },
      ),
    ),
  );
}

Future<void> mount(WidgetTester tester, {
  bool reduceMotion = false, double textScale = 1, double width = 390,
}) async {
  tester.view.physicalSize = Size(width, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final vm = HomeViewModel(service: HomeService(repository: _HomeRepository()));
  await vm.load();
  await tester.pumpWidget(ChangeNotifierProvider.value(
    value: vm,
    child: _Harness(reduceMotion: reduceMotion, textScale: textScale),
  ));
  await tester.pumpAndSettle();
  addTearDown(vm.dispose);
}

Finder details(String id) => find.byKey(ValueKey('home-beneficiary-details-$id'));
Finder get network => find.byKey(const ValueKey('home-payment-network'));

Future<void> tapContact(WidgetTester tester, String id) async {
  await tester.tap(find.byKey(ValueKey('home-quick-beneficiary-$id')));
  await tester.pump();
}

Offset slidePosition(WidgetTester tester, Finder content) {
  final slide = find.ancestor(of: content, matching: find.byType(SlideTransition)).first;
  return tester.widget<SlideTransition>(slide).position.value;
}

void main() {
  testWidgets('card opens transfer with the current contact or an empty seed', (tester) async {
    await mount(tester);
    final state = tester.state<_HarnessState>(find.byType(_Harness));
    final card = find.byKey(const ValueKey('home-beneficiary-card'));
    await tester.tap(card);
    expect(state.transferOpenCount, 1);
    expect(state.openedBeneficiaryId, isNull);

    await tapContact(tester, 'a');
    // A tap during the animation uses the new selection immediately.
    await tester.tap(card);
    expect(state.transferOpenCount, 2);
    expect(state.openedBeneficiaryId, 'a');
    await tester.pumpAndSettle();

    await tapContact(tester, 'b');
    await tester.pumpAndSettle();
    await tester.tap(card);
    expect(state.transferOpenCount, 3);
    expect(state.openedBeneficiaryId, 'b');

    await tapContact(tester, 'b');
    await tester.pumpAndSettle();
    await tester.tap(card);
    expect(state.transferOpenCount, 4);
    expect(state.openedBeneficiaryId, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('second tap clears selection; another contact replaces it', (tester) async {
    await mount(tester);
    expect(network, findsOneWidget);
    await tapContact(tester, 'a');
    await tester.pumpAndSettle();
    expect(details('a'), findsOneWidget);
    expect(find.text('+237670123456'), findsOneWidget);
    expect(network, findsNothing);
    await tapContact(tester, 'b');
    await tester.pumpAndSettle();
    expect(details('a'), findsNothing);
    expect(details('b'), findsOneWidget);
    await tapContact(tester, 'b');
    await tester.pumpAndSettle();
    expect(network, findsOneWidget);
    expect(details('b'), findsNothing);
    expect(tester.state<_HarnessState>(find.byType(_Harness)).selected, isNull);
  });

  testWidgets('entry, replacement and clearing follow the requested directions', (tester) async {
    await mount(tester);
    final initialSize = tester.getSize(find.byKey(const ValueKey('home-beneficiary-card')));
    await tapContact(tester, 'a');
    await tester.pump(const Duration(milliseconds: 60));
    expect(slidePosition(tester, details('a')).dy, lessThan(0));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(const ValueKey('home-beneficiary-card'))), initialSize);
    await tapContact(tester, 'd');
    await tester.pump(const Duration(milliseconds: 60));
    expect(slidePosition(tester, details('d')).dx, lessThan(0));
    expect(slidePosition(tester, details('a')).dx, greaterThan(0));
    await tester.pumpAndSettle();
    await tapContact(tester, 'b');
    await tester.pump(const Duration(milliseconds: 60));
    expect(slidePosition(tester, details('b')).dx, greaterThan(0));
    expect(slidePosition(tester, details('d')).dx, lessThan(0));
    await tester.pumpAndSettle();
    await tapContact(tester, 'b');
    await tester.pump(const Duration(milliseconds: 60));
    expect(slidePosition(tester, network).dy, greaterThan(0));
    expect(slidePosition(tester, details('b')).dy, lessThan(0));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('rapid taps settle on the latest selection and can clear it', (tester) async {
    await mount(tester);
    for (final id in ['a', 'b', 'a', 'c', 'd']) {
      await tapContact(tester, id);
      await tester.pump(const Duration(milliseconds: 30));
    }
    await tester.pumpAndSettle();
    expect(details('d'), findsOneWidget);
    for (final id in ['a', 'b', 'c']) {
      expect(details(id), findsNothing);
    }
    await tapContact(tester, 'd');
    await tester.pumpAndSettle();
    expect(network, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.3, 2.0]) {
    testWidgets('320px screen retains all shortcuts at text scale $scale', (tester) async {
      await mount(tester, width: 320, textScale: scale);
      expect(network, findsOneWidget);
      for (final contact in contacts) {
        expect(find.byKey(ValueKey('home-quick-beneficiary-${contact.id}')), findsOneWidget);
      }
      await tapContact(tester, 'd');
      await tester.pumpAndSettle();
      expect(details('d'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('reduced motion changes content immediately', (tester) async {
    await mount(tester, reduceMotion: true);
    await tapContact(tester, 'a');
    await tester.pump();
    expect(details('a'), findsOneWidget);
    expect(network, findsNothing);
    expect(slidePosition(tester, details('a')), Offset.zero);
    await tapContact(tester, 'a');
    await tester.pump();
    expect(network, findsOneWidget);
    expect(details('a'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
