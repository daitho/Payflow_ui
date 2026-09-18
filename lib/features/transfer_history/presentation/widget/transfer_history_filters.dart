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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(children: [
          _chip(l10n.transferAllBeneficiaries, filter.beneficiaryId == null,
            () => onChanged(TransferHistoryFilter(status: filter.status))),
          ...beneficiaries.entries.map((entry) => _chip(entry.value,
            filter.beneficiaryId == entry.key,
            () => onChanged(TransferHistoryFilter(
              beneficiaryId: entry.key, status: filter.status)))),
        ]),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(children: [
          _chip(l10n.transferAllStatuses, filter.status == null,
            () => onChanged(TransferHistoryFilter(beneficiaryId: filter.beneficiaryId))),
          ...statuses.map((status) => _chip(transferStatus(l10n, status),
            filter.status == status,
            () => onChanged(TransferHistoryFilter(
              beneficiaryId: filter.beneficiaryId, status: status)))),
        ]),
      ),
    ]);
  }

  Widget _chip(String label, bool selected, VoidCallback action) => Padding(
    padding: const EdgeInsets.only(right: 10),
    child: ChoiceChip(
      label: Text(label), selected: selected, showCheckmark: false,
      selectedColor: const Color(0xFFE96C15),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: selected ? Colors.white : const Color(0xFF302B28),
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
      shape: const StadiumBorder(),
      onSelected: enabled ? (_) => action() : null,
    ),
  );
}
