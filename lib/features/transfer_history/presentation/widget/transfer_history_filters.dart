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
  const TransferHistoryFilters({
    super.key, required this.filter, required this.page,
    required this.enabled, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final beneficiaries = {
      for (final item in page?.beneficiaries ?? <TransferHistoryBeneficiaryModel>[])
        item.id: item.displayName,
    };
    if (filter.beneficiaryId != null) {
      beneficiaries.putIfAbsent(filter.beneficiaryId!, () => l10n.transferBeneficiary);
    }
    final statuses = {...?page?.availableStatuses, if (filter.status != null) filter.status!};
    return Column(children: [
      DropdownButtonFormField<String>(
        key: ValueKey('beneficiary-${filter.beneficiaryId}'),
        initialValue: filter.beneficiaryId ?? '',
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.transferBeneficiary),
        items: [
          DropdownMenuItem(value: '', child: Text(l10n.transferAllBeneficiaries)),
          ...beneficiaries.entries.map((item) =>
            DropdownMenuItem(value: item.key, child: Text(item.value))),
        ],
        onChanged: enabled ? (value) => onChanged(TransferHistoryFilter(
          beneficiaryId: value == '' ? null : value, status: filter.status,
        )) : null,
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        key: ValueKey('status-${filter.status}'),
        initialValue: filter.status ?? '',
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.transferStatusLabel),
        items: [
          DropdownMenuItem(value: '', child: Text(l10n.transferAllStatuses)),
          ...statuses.map((status) => DropdownMenuItem(
            value: status, child: Text(transferStatus(l10n, status)))),
        ],
        onChanged: enabled ? (value) => onChanged(TransferHistoryFilter(
          beneficiaryId: filter.beneficiaryId, status: value == '' ? null : value,
        )) : null,
      ),
      if (filter.status != null || filter.beneficiaryId != null)
        Align(alignment: Alignment.centerRight, child: TextButton(
          onPressed: enabled ? () => onChanged(const TransferHistoryFilter()) : null,
          child: Text(l10n.transferResetFilters),
        )),
    ]);
  }
}
