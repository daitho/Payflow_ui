import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../view_model/transfer_history_view_model.dart';
import '../widget/transfer_format.dart';
import '../widget/transfer_history_filters.dart';
import '../widget/transfer_history_tile.dart';

class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferHistoryViewModel>();
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppBar(title: Text(l10n.transferHistoryTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              TransferHistoryFilters(
                filter: vm.filter, page: vm.page, enabled: !vm.isLoading,
                onChanged: vm.setFilter,
              ),
              const SizedBox(height: 20),
              if (vm.isLoading) const LinearProgressIndicator(),
              if (vm.error != null)
                Card(child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Text(transferError(l10n, vm.error!)),
                    TextButton.icon(
                      onPressed: vm.isLoading || vm.isLoadingMore ? null :
                        () { vm.refresh(); },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ]),
                )),
              if (vm.page != null) ...[
                Card(child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${l10n.transferCountLabel} : ${vm.page!.transactionCount}',
                        style: Theme.of(context).textTheme.titleMedium),
                      if (vm.page!.sentTotals.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(l10n.transferSentTotalLabel),
                        ...vm.page!.sentTotals.map((total) => Text(
                          transferMoney(context, total.amount, total.currencyCode),
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
                      ],
                    ],
                  ),
                )),
                const SizedBox(height: 16),
              ],
              if (!vm.isLoading && vm.error == null && vm.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(children: [
                    const Icon(Icons.receipt_long_outlined, size: 48),
                    const SizedBox(height: 16),
                    Text(l10n.transferHistoryEmpty, textAlign: TextAlign.center),
                  ]),
                ),
              ...vm.items.map((item) => TransferHistoryTile(
                item: item,
                onTap: () => context.push(AppRoutes.transactionDetailPath(item.id)),
              )),
              if (vm.page?.hasNext == true)
                OutlinedButton(
                  onPressed: vm.isLoading || vm.isLoadingMore ? null : vm.loadMore,
                  child: vm.isLoadingMore
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.transferLoadMore),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
