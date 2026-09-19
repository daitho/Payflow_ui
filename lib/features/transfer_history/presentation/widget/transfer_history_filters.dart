import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/transfer_history_filter.dart';
import '../../domain/model/transfer_history_page_model.dart';
import 'transfer_format.dart';

class TransferHistoryFilters extends StatelessWidget {
  final TransferHistoryFilter filter;
  final TransferHistoryPageModel? page;
  final bool enabled;
  final ValueChanged<TransferHistoryFilter> onChanged;
  const TransferHistoryFilters({super.key, required this.filter,
    required this.page, required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final beneficiaries = {for (final item in
      page?.beneficiaries ?? <TransferHistoryBeneficiaryModel>[])
        item.id: item.displayName};
    if (filter.beneficiaryId != null) {
      beneficiaries.putIfAbsent(filter.beneficiaryId!, () => l10n.transferBeneficiary);
    }
    final statuses = {...?page?.availableStatuses,
      if (filter.status != null) filter.status!};
    final years = {...?page?.availableYears,
      if (filter.year != null) filter.year!}.toList()
      ..sort((a, b) => b.compareTo(a));
    final statusField = _dropdown(
      label: l10n.transferStatusLabel,
      allLabel: l10n.transferAllStatuses,
      value: filter.status,
      options: {for (final status in statuses) status: transferStatus(l10n, status)},
      onSelected: (value) => onChanged(TransferHistoryFilter(
        beneficiaryId: filter.beneficiaryId, status: value, year: filter.year)),
    );
    final yearField = _dropdown(
      label: l10n.transferYearLabel,
      allLabel: l10n.transferAllYears,
      value: filter.year?.toString(),
      options: {for (final year in years) '$year': '$year'},
      onSelected: (value) => onChanged(TransferHistoryFilter(
        beneficiaryId: filter.beneficiaryId, status: filter.status,
        year: value == null ? null : int.parse(value))),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(children: [
        _dropdown(
          label: l10n.transferBeneficiary,
          allLabel: l10n.transferAllBeneficiaries,
          value: filter.beneficiaryId,
          options: beneficiaries,
          onSelected: (value) => onChanged(TransferHistoryFilter(
            beneficiaryId: value, status: filter.status, year: filter.year)),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 300 ||
              MediaQuery.textScalerOf(context).scale(14) > 20) {
            return Column(children: [
              statusField, const SizedBox(height: 12), yearField,
            ]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: statusField),
            const SizedBox(width: 12),
            Expanded(child: yearField),
          ]);
        }),
      ]),
    );
  }

  Widget _dropdown({
    required String label,
    required String allLabel,
    required String? value,
    required Map<String, String> options,
    required ValueChanged<String?> onSelected,
  }) {
    // Zero represents all options without reserving a possible backend ID.
    final keys = options.keys.toList();
    final selectedIndex = value == null ? 0 : keys.indexOf(value) + 1;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        enabled: enabled,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedIndex,
          isExpanded: true,
          menuMaxHeight: 320,
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem(value: 0,
              child: Text(allLabel, maxLines: 1, overflow: TextOverflow.ellipsis)),
            for (var index = 0; index < keys.length; index++)
              DropdownMenuItem(value: index + 1,
                child: Text(options[keys[index]]!, maxLines: 1,
                  overflow: TextOverflow.ellipsis)),
          ],
          onChanged: enabled ? (index) {
            if (index == null || index == selectedIndex) return;
            onSelected(index == 0 ? null : keys[index - 1]);
          } : null,
        ),
      ),
    );
  }
}
