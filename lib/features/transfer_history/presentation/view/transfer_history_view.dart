import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../view_model/transfer_history_view_model.dart';
import '../widget/transfer_format.dart';
import '../widget/transfer_history_filters.dart';
import '../widget/transfer_history_summary.dart';
import '../widget/transfer_history_tile.dart';
import 'transfer_pdf_view.dart';

class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key});

  Future<void> _export(
    BuildContext context,
    TransferHistoryViewModel vm,
  ) async {
    final l10n = AppLocalizations.of(context);
    final bytes = await vm.exportHistory(
      Localizations.localeOf(context).toLanguageTag(),
    );
    if (!context.mounted) return;
    if (bytes != null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => TransferPdfView(
            bytes: bytes,
            title: l10n.transferHistoryTitle,
            filename: 'payflow-history.pdf',
          ),
        ),
      );
    } else if (vm.exportError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(transferError(l10n, vm.exportError!))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferHistoryViewModel>();
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppBar(title: Text(l10n.transferHistoryTitle), centerTitle: true),
      bottomNavigationBar: TransferHistorySummary(
        page: vm.page,
        busy: vm.isLoading || vm.isLoadingMore,
        exporting: vm.isExporting,
        onExport: () => _export(context, vm),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TransferHistoryFilters(
              filter: vm.filter,
              page: vm.page,
              enabled: !vm.isExporting && !vm.isLoading,
              onChanged: vm.setFilter,
            ),
            if (vm.isLoading) const LinearProgressIndicator(minHeight: 2),
            if (vm.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: Text(transferError(l10n, vm.error!))),
                    TextButton(
                      onPressed: vm.isLoading ? null : vm.refresh,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: vm.refresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (!vm.isLoading && vm.error == null && vm.items.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              l10n.transferHistoryEmpty,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index.isOdd)
                              return const Divider(
                                height: 1,
                                indent: 66,
                                endIndent: 14,
                                color: Color(0xFFF0ECE9),
                              );
                            final item = vm.items[index ~/ 2];
                            return TransferHistoryTile(
                              item: item,
                              onTap: () => context.push(
                                AppRoutes.transactionDetailPath(item.id),
                              ),
                            );
                          },
                          childCount: vm.items.isEmpty
                              ? 0
                              : vm.items.length * 2 - 1,
                        ),
                      ),
                    ),
                    if (vm.page?.hasNext == true)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          child: OutlinedButton(
                            onPressed:
                                vm.isLoading ||
                                    vm.isLoadingMore ||
                                    vm.isExporting
                                ? null
                                : vm.loadMore,
                            child: vm.isLoadingMore
                                ? const CircularProgressIndicator()
                                : Text(l10n.transferLoadMore),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
