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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(children: [
        _dropdown(
          label: l10n.transferBeneficiary,
          allLabel: l10n.transferAllBeneficiaries,
          value: filter.beneficiaryId,
          options: beneficiaries,
          onSelected: (value) => onChanged(TransferHistoryFilter(
            beneficiaryId: value, status: filter.status)),
        ),
        const SizedBox(height: 12),
        _dropdown(
          label: l10n.transferStatusLabel,
          allLabel: l10n.transferAllStatuses,
          value: filter.status,
          options: {for (final status in statuses) status: transferStatus(l10n, status)},
          onSelected: (value) => onChanged(TransferHistoryFilter(
            beneficiaryId: filter.beneficiaryId, status: value)),
        ),
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
