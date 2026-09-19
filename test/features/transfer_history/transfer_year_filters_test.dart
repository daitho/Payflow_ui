import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/l10n/app_localizations.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_history_filter.dart';
import 'package:pay_flow_ui/features/transfer_history/domain/model/transfer_history_page_model.dart';
import 'package:pay_flow_ui/features/transfer_history/presentation/widget/transfer_history_filters.dart';

void main() {
  testWidgets('year and status are adjacent and changes preserve other filters', (tester) async {
    var filter = const TransferHistoryFilter(
      beneficiaryId: 'alice', status: 'COMPLETED', year: 2026);
    final page = TransferHistoryPageModel(
      items: [], beneficiaries: [const TransferHistoryBeneficiaryModel('alice', 'Alice')],
      availableStatuses: ['COMPLETED', 'FAILED'], availableYears: [2026, 2024],
      sentTotals: [], page: 0, transactionCount: 0, hasNext: false,
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: StatefulBuilder(builder: (context, setState) =>
        TransferHistoryFilters(filter: filter, page: page, enabled: true,
          onChanged: (value) => setState(() => filter = value)))),
    ));
    final dropdowns = find.byType(DropdownButton<int>);
    expect(dropdowns, findsNWidgets(3));
    expect(tester.getTopLeft(dropdowns.at(1)).dy,
      tester.getTopLeft(dropdowns.at(2)).dy);
    await tester.tap(dropdowns.at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2024').last);
    await tester.pumpAndSettle();
    expect(filter.year, 2024);
    expect(filter.status, 'COMPLETED');
    expect(filter.beneficiaryId, 'alice');

    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Échoué').last);
    await tester.pumpAndSettle();
    expect(filter.status, 'FAILED');
    expect(filter.year, 2024);
    expect(filter.beneficiaryId, 'alice');

    await tester.tap(dropdowns.at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Toutes les années').last);
    await tester.pumpAndSettle();
    expect(filter.year, isNull);
    expect(filter.status, 'FAILED');
    expect(filter.beneficiaryId, 'alice');
  });
}
