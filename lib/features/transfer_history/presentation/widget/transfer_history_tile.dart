import 'package:flutter/material.dart';
import '../../../../shared/widgets/transfer_summary_tile.dart';
import '../../domain/model/transfer_history_item_model.dart';

class TransferHistoryTile extends StatelessWidget {
  final TransferHistoryItemModel item;
  final VoidCallback onTap;
  const TransferHistoryTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    child: TransferSummaryTile(
      beneficiaryName: item.beneficiaryName,
      reference: item.reference,
      status: item.status,
      sentAmount: item.sentAmount,
      receivedAmount: item.receivedAmount,
      sourceCurrencyCode: item.sourceCurrencyCode,
      targetCurrencyCode: item.targetCurrencyCode,
      createdAt: item.createdAt,
      onTap: onTap,
    ),
  );
}
