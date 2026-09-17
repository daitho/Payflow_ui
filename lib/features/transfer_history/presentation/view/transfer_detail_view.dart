import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../view_model/transfer_detail_view_model.dart';
import '../widget/transfer_detail_section.dart';
import '../widget/transfer_format.dart';
import '../widget/transfer_status_chip.dart';

class TransferDetailView extends StatelessWidget {
  const TransferDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransferDetailViewModel>();
    final detail = vm.detail;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppBar(title: Text(l10n.transferDetailTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              if (vm.isLoading) const LinearProgressIndicator(),
              if (vm.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(children: [
                    Text(transferError(l10n, vm.error!), textAlign: TextAlign.center),
                    TextButton.icon(
                      onPressed: vm.isLoading ? null : vm.load,
                      icon: const Icon(Icons.refresh), label: Text(l10n.retry),
                    ),
                  ]),
                ),
              if (detail != null) ...[
                const SizedBox(height: 16),
                Text(transferMoney(context, detail.sentAmount, detail.sourceCurrencyCode),
                  style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerLeft,
                  child: TransferStatusChip(status: detail.status)),
                const SizedBox(height: 24),
                TransferDetailSection(title: l10n.transferBeneficiary, children: [
                  TransferDetailField(label: l10n.transferRecipientName,
                    value: detail.beneficiaryName),
                  TransferDetailField(label: l10n.transferCountry,
                    value: detail.countryCode),
                  TransferDetailField(label: l10n.transferOperator,
                    value: detail.operatorName),
                  if (detail.destination != null)
                    TransferDetailField(label: l10n.transferDestination,
                      value: detail.destination!),
                ]),
                TransferDetailSection(title: l10n.transferAmounts, children: [
                  TransferDetailField(label: l10n.transferSent,
                    value: transferMoney(context, detail.sentAmount, detail.sourceCurrencyCode)),
                  TransferDetailField(label: l10n.transferFee,
                    value: transferMoney(context, detail.fee, detail.sourceCurrencyCode)),
                  TransferDetailField(label: l10n.transferTotalCharged,
                    value: transferMoney(context, detail.totalChargedAmount, detail.sourceCurrencyCode)),
                  TransferDetailField(label: l10n.transferRate,
                    value: '1 ${detail.sourceCurrencyCode} = ${detail.appliedRate} ${detail.targetCurrencyCode}'),
                  TransferDetailField(label: l10n.transferReceived,
                    value: transferMoney(context, detail.receivedAmount, detail.targetCurrencyCode)),
                ]),
                TransferDetailSection(title: l10n.transferTracking, children: [
                  TransferDetailField(label: l10n.transferReference, value: detail.reference),
                  TransferDetailField(label: l10n.transferCreatedAt,
                    value: transferDate(context, detail.createdAt)),
                  ...detail.timeline.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      TransferStatusChip(status: entry.status),
                      const SizedBox(height: 6),
                      Text(transferDate(context, entry.occurredAt)),
                    ]),
                  )),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
