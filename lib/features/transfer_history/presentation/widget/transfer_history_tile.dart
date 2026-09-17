import 'package:flutter/material.dart';
import '../../domain/model/transfer_history_item_model.dart';
import 'transfer_format.dart';
import 'transfer_status_chip.dart';

class TransferHistoryTile extends StatelessWidget {
  final TransferHistoryItemModel item;
  final VoidCallback onTap;
  const TransferHistoryTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.beneficiaryName,
            style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(transferMoney(context, item.sentAmount, item.sourceCurrencyCode),
            style: Theme.of(context).textTheme.titleLarge),
          Text('→ ${transferMoney(context, item.receivedAmount, item.targetCurrencyCode)}'),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TransferStatusChip(status: item.status),
              Text(transferDate(context, item.createdAt)),
            ]),
          const SizedBox(height: 8),
          Text(item.reference, style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    ),
  );
}
