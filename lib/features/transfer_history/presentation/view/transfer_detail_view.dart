import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../transfer/domain/model/transfer_draft_seed.dart';
import '../view_model/transfer_detail_view_model.dart';
import '../widget/transfer_detail_actions.dart';
import '../widget/transfer_detail_header.dart';
import '../widget/transfer_detail_section.dart';
import '../widget/transfer_format.dart';
import '../widget/transfer_status_timeline.dart';
import 'transfer_pdf_view.dart';

class TransferDetailView extends StatelessWidget {
  const TransferDetailView({super.key});

  Future<void> _receipt(
    BuildContext context,
    TransferDetailViewModel vm,
  ) async {
    final l10n = AppLocalizations.of(context);
    final bytes = await vm.exportReceipt(
      Localizations.localeOf(context).toLanguageTag(),
    );
    if (!context.mounted) return;
    if (bytes != null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => TransferPdfView(
            bytes: bytes,
            title: l10n.transferReceiptAction,
            filename: 'payflow-receipt.pdf',
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
    final vm = context.watch<TransferDetailViewModel>();
    final detail = vm.detail;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(l10n.transferDetailTitle),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              if (vm.isLoading) const LinearProgressIndicator(),
              if (vm.error != null)
                Column(
                  children: [
                    Text(transferError(l10n, vm.error!)),
                    TextButton(
                      onPressed: vm.isLoading ? null : vm.load,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              if (detail != null) ...[
                TransferDetailHeader(detail: detail),
                TransferStatusTimeline(detail: detail),
                TransferDetailActions(
                  receiptAvailable: detail.receiptAvailable,
                  repeatAllowed: detail.repeatAllowed,
                  busy: vm.isExporting,
                  onReceipt: () => _receipt(context, vm),
                  onRepeat: detail.repeatAllowed
                      ? () => context.push(
                          AppRoutes.transfer,
                          extra: TransferDraftSeed(
                            beneficiaryId: detail.beneficiaryId,
                            sentAmount: detail.sentAmount,
                            sentCurrency: detail.sourceCurrencyCode,
                          ),
                        )
                      : null,
                ),
                TransferDetailField(
                  label: l10n.transferSent,
                  value: transferMoney(
                    context,
                    detail.sentAmount,
                    detail.sourceCurrencyCode,
                  ),
                ),
                TransferDetailField(
                  label: l10n.transferFee,
                  value: transferMoney(
                    context,
                    detail.fee,
                    detail.sourceCurrencyCode,
                  ),
                ),
                TransferDetailField(
                  label: l10n.transferRate,
                  value:
                      '1 ${detail.sourceCurrencyCode} = ${detail.appliedRate} ${detail.targetCurrencyCode}',
                ),
                TransferDetailField(
                  label: l10n.transferReceived,
                  value: transferMoney(
                    context,
                    detail.receivedAmount,
                    detail.targetCurrencyCode,
                  ),
                ),
                TransferDetailField(
                  label: l10n.transferTotalAmount,
                  value: transferMoney(
                    context,
                    detail.totalChargedAmount,
                    detail.sourceCurrencyCode,
                  ),
                ),
                TransferDetailField(
                  label: l10n.transferReference,
                  value: detail.reference,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
