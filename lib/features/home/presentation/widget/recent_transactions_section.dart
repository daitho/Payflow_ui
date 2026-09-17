import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/model/home_transfer_model.dart';
import '../../domain/model/home_transfer_status.dart';

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
    final AppLocalizations l10n =
    AppLocalizations.of(context);

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
          _EmptyTransactions(
            message: l10n.homeNoRecentTransactions,
          )

        // =====================================================
        // TRANSACTIONS
        // =====================================================

        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFEAE5E2),
              ),
            ),
            child: Column(
              children: [
                for (
                int index = 0;
                index < transactions.length;
                index++
                ) ...[
                  _TransactionTile(
                    transaction: transactions[index],
                    onTap: onTransactionTap == null
                        ? null
                        : () {
                      onTransactionTap!(
                        transactions[index],
                      );
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

class _TransactionTile extends StatelessWidget {
  final HomeTransferModel transaction;

  final VoidCallback? onTap;

  const _TransactionTile({
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
    AppLocalizations.of(context);

    final String locale =
    Localizations.localeOf(context).toLanguageTag();

    final NumberFormat amountFormat =
    NumberFormat(
      '#,##0.00',
      locale,
    );

    final DateTime localDate =
    transaction.createdAt.toLocal();

    final String formattedDate =
        '${DateFormat.MMMd(locale).format(localDate)}'
        ' • '
        '${DateFormat.Hm(locale).format(localDate)}';

    final _StatusPresentation status =
    _statusPresentation(
      transaction.status,
      l10n,
    );

    final String beneficiaryName =
    transaction.beneficiaryName != null &&
        transaction.beneficiaryName!
            .trim()
            .isNotEmpty
        ? transaction.beneficiaryName!.trim()
        : transaction.reference;

    // =========================================================
    // AMOUNT SENT
    // =========================================================

    final String sentAmount =
        '-${amountFormat.format(transaction.sentAmount)} '
        '${transaction.sourceCurrencyCode}';

    // =========================================================
    // AMOUNT RECEIVED
    // =========================================================

    final String receivedAmount =
        '${amountFormat.format(transaction.receivedAmount)} '
        '${transaction.targetCurrencyCode}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // ICON
            // =================================================

            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF7EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.north_east_rounded,
                size: 20,
                color: Color(0xFF32915E),
              ),
            ),

            const SizedBox(width: 11),

            // =================================================
            // LEFT SIDE
            // NAME + DATE + STATUS
            // =================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    beneficiaryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF302B28),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xFF948C88),
                      fontSize: 11.5,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: status.backgroundColor,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.label,
                      style: TextStyle(
                        color: status.foregroundColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // =================================================
            // RIGHT SIDE
            //
            // 1. MONTANT ENVOYÉ + DEVISE
            // 2. MONTANT REÇU + DEVISE
            // =================================================

            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                // =============================================
                // SENT
                // =============================================

                Text(
                  sentAmount,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF302B28),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                // =============================================
                // RECEIVED
                // =============================================

                Text(
                  receivedAmount,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF77706C),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // STATUS
  // =========================================================

  _StatusPresentation _statusPresentation(
      HomeTransferStatus status,
      AppLocalizations l10n,
      ) {
    switch (status) {
      case HomeTransferStatus.created:
        return _StatusPresentation(
          label: l10n.homeStatusCreated,
          foregroundColor:
          const Color(0xFF5C6670),
          backgroundColor:
          const Color(0xFFF0F2F4),
        );

      case HomeTransferStatus.pending:
        return _StatusPresentation(
          label: l10n.homeStatusPending,
          foregroundColor:
          const Color(0xFF9B6A00),
          backgroundColor:
          const Color(0xFFFFF5D8),
        );

      case HomeTransferStatus.processing:
        return _StatusPresentation(
          label: l10n.homeStatusProcessing,
          foregroundColor:
          const Color(0xFF336E9A),
          backgroundColor:
          const Color(0xFFE7F3FB),
        );

      case HomeTransferStatus.completed:
        return _StatusPresentation(
          label: l10n.homeStatusCompleted,
          foregroundColor:
          const Color(0xFF28764B),
          backgroundColor:
          const Color(0xFFE8F7EE),
        );

      case HomeTransferStatus.failed:
        return _StatusPresentation(
          label: l10n.homeStatusFailed,
          foregroundColor:
          const Color(0xFFB53D3D),
          backgroundColor:
          const Color(0xFFFFECEC),
        );

      case HomeTransferStatus.cancelled:
        return _StatusPresentation(
          label: l10n.homeStatusCancelled,
          foregroundColor:
          const Color(0xFF7D5D4E),
          backgroundColor:
          const Color(0xFFF5EEE9),
        );

      case HomeTransferStatus.refunded:
        return _StatusPresentation(
          label: l10n.homeStatusRefunded,
          foregroundColor:
          const Color(0xFF7657A8),
          backgroundColor:
          const Color(0xFFF1ECFA),
        );

      case HomeTransferStatus.unknown:
        return const _StatusPresentation(
          label: '-',
          foregroundColor:
          Color(0xFF77706C),
          backgroundColor:
          Color(0xFFF1EFEE),
        );
    }
  }
}

// ===========================================================
// STATUS PRESENTATION
// ===========================================================

class _StatusPresentation {
  final String label;

  final Color foregroundColor;

  final Color backgroundColor;

  const _StatusPresentation({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });
}

// ===========================================================
// EMPTY
// ===========================================================

class _EmptyTransactions extends StatelessWidget {
  final String message;

  const _EmptyTransactions({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEAE5E2),
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF847C78),
          fontSize: 13,
        ),
      ),
    );
  }
}