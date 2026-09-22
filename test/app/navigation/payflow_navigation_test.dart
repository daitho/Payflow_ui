import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/app/navigation/payflow_bottom_navigation.dart';
import 'package:pay_flow_ui/app/navigation/payflow_transfer_button.dart';

void main() {
  const items = [
    PayflowNavigationItem(
      selectedIcon: Icons.home,
      unselectedIcon: Icons.home_outlined,
      label: 'Accueil',
    ),
    PayflowNavigationItem(
      selectedIcon: Icons.people,
      unselectedIcon: Icons.people_outline,
      label: 'Contacts',
    ),
  ];

  Widget navigation({
    required double progress,
    required ValueChanged<int> onSelected,
    required VoidCallback onExpand,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 340,
            child: PayflowBottomNavigation(
              selectedIndex: 0,
              collapseProgress: progress,
              items: items,
              onSelected: onSelected,
              onExpand: onExpand,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('expanded navigation selects a tab', (tester) async {
    int? selected;
    await tester.pumpWidget(
      navigation(
        progress: 0,
        onSelected: (index) => selected = index,
        onExpand: () {},
      ),
    );

    await tester.tap(find.text('Contacts'));
    await tester.pump();

    expect(selected, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('collapsed navigation remains recoverable', (tester) async {
    var expanded = false;
    await tester.pumpWidget(
      navigation(
        progress: 1,
        onSelected: (_) {},
        onExpand: () => expanded = true,
      ),
    );

    await tester.tap(find.byType(PayflowBottomNavigation));
    await tester.pump();

    expect(expanded, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('transfer action supports both motion endpoints', (tester) async {
    Widget button(double progress) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: PayflowTransferButton(
            label: 'Transfert',
            collapseProgress: progress,
            onTap: () {},
          ),
        ),
      ),
    );

    await tester.pumpWidget(button(0));
    expect(find.text('Transfert'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(button(1));
    await tester.pump();
    expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
