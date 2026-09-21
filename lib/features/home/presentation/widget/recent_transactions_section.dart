import 'package:flutter/material.dart';
import '../../../../shared/widgets/transfer_summary_tile.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/home_transfer_model.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<HomeTransferModel> transactions;

  final VoidCallback? onViewAll;

  final ValueChanged<HomeTransferModel>? onTransactionTap;

  const RecentTransactionsSection({
    super.key,
    required this.transactions,
    this.onViewAll,
    this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // HEADER
        // =====================================================

        Row(
          children: [
            Expanded(
              child: Text(
                l10n.homeRecentTransactions,
                style: const TextStyle(
                  color: Color(0xFF272321),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            if (onViewAll != null)
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  l10n.homeViewAll,
                  style: const TextStyle(
                    color: Color(0xFFE96C15),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // =====================================================
        // EMPTY
        // =====================================================
        if (transactions.isEmpty)
          _EmptyTransactions(message: l10n.homeNoRecentTransactions)
        // =====================================================
        // TRANSACTIONS
        // =====================================================
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEAE5E2)),
            ),
            child: Column(
              children: [
                for (int index = 0; index < transactions.length; index++) ...[
                  TransferSummaryTile(
                    beneficiaryName: transactions[index].beneficiaryName ?? '',
                    reference: transactions[index].reference,
                    status: transactions[index].status.name.toUpperCase(),
                    sentAmount: transactions[index].sentAmount,
                    receivedAmount: transactions[index].receivedAmount,
                    sourceCurrencyCode: transactions[index].sourceCurrencyCode,
                    targetCurrencyCode: transactions[index].targetCurrencyCode,
                    createdAt: transactions[index].createdAt,
                    onTap: onTransactionTap == null
                        ? null
                        : () {
                            onTransactionTap!(transactions[index]);
                          },
                  ),

                  if (index < transactions.length - 1)
                    const Divider(
                      height: 1,
                      indent: 66,
                      endIndent: 14,
                      color: Color(0xFFF0ECE9),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

// ===========================================================
// TRANSACTION TILE
// ===========================================================

// ===========================================================
// EMPTY
// ===========================================================

class _EmptyTransactions extends StatelessWidget {
  final String message;

  const _EmptyTransactions({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAE5E2)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFF847C78), fontSize: 13),
      ),
    );
  }
}
