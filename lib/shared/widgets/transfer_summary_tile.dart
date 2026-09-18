import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

class TransferSummaryTile extends StatelessWidget {
  final String beneficiaryName;
  final String reference;
  final String status;
  final num sentAmount, receivedAmount;
  final String sourceCurrencyCode, targetCurrencyCode;
  final DateTime createdAt;

  final VoidCallback? onTap;

  const TransferSummaryTile({
    super.key,
    required this.beneficiaryName, required this.reference, required this.status,
    required this.sentAmount, required this.receivedAmount,
    required this.sourceCurrencyCode, required this.targetCurrencyCode,
    required this.createdAt,
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
    createdAt.toLocal();

    final String formattedDate =
        '${DateFormat.MMMd(locale).format(localDate)}'
        ' • '
        '${DateFormat.Hm(locale).format(localDate)}';

    final _StatusPresentation statusPresentation =
    _statusPresentation(
      this.status,
      l10n,
    );

    final String displayName =
    this.beneficiaryName.trim().isNotEmpty
        ? this.beneficiaryName.trim()
        : reference;

    // =========================================================
    // AMOUNT SENT
    // =========================================================

    final String formattedSentAmount =
        '-${amountFormat.format(this.sentAmount)} '
        '${sourceCurrencyCode}';

    // =========================================================
    // AMOUNT RECEIVED
    // =========================================================

    final String formattedReceivedAmount =
        '${amountFormat.format(this.receivedAmount)} '
        '${targetCurrencyCode}';

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
                    displayName,
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
                      color: statusPresentation.backgroundColor,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusPresentation.label,
                      style: TextStyle(
                        color: statusPresentation.foregroundColor,
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
                  formattedSentAmount,
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
                  formattedReceivedAmount,
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
      String status,
      AppLocalizations l10n,
      ) {
    switch (status) {
      case 'CREATED':
        return _StatusPresentation(
          label: l10n.homeStatusCreated,
          foregroundColor:
          const Color(0xFF5C6670),
          backgroundColor:
          const Color(0xFFF0F2F4),
        );

      case 'PENDING':
        return _StatusPresentation(
          label: l10n.homeStatusPending,
          foregroundColor:
          const Color(0xFF9B6A00),
          backgroundColor:
          const Color(0xFFFFF5D8),
        );

      case 'PROCESSING':
        return _StatusPresentation(
          label: l10n.homeStatusProcessing,
          foregroundColor:
          const Color(0xFF336E9A),
          backgroundColor:
          const Color(0xFFE7F3FB),
        );

      case 'COMPLETED':
        return _StatusPresentation(
          label: l10n.homeStatusCompleted,
          foregroundColor:
          const Color(0xFF28764B),
          backgroundColor:
          const Color(0xFFE8F7EE),
        );

      case 'FAILED':
        return _StatusPresentation(
          label: l10n.homeStatusFailed,
          foregroundColor:
          const Color(0xFFB53D3D),
          backgroundColor:
          const Color(0xFFFFECEC),
        );

      case 'CANCELLED':
        return _StatusPresentation(
          label: l10n.homeStatusCancelled,
          foregroundColor:
          const Color(0xFF7D5D4E),
          backgroundColor:
          const Color(0xFFF5EEE9),
        );

      case 'REFUNDED':
        return _StatusPresentation(
          label: l10n.homeStatusRefunded,
          foregroundColor:
          const Color(0xFF7657A8),
          backgroundColor:
          const Color(0xFFF1ECFA),
        );

      default:
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
