import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/transfer_history_page_model.dart';
import 'transfer_format.dart';

/// Server totals cover the entire filter, independently of the loaded pages.
class TransferHistorySummary extends StatelessWidget {
  final TransferHistoryPageModel? page;
  final bool busy, exporting;
  final VoidCallback? onExport;
  const TransferHistorySummary({
    super.key,
    required this.page,
    required this.busy,
    required this.exporting,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * .24,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.transferCountLabel,
                          style: const TextStyle(
                            color: Color(0xFF948C88),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (page != null) ...[
                          Text(
                            '${page!.transactionCount}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            l10n.transferSentTotalLabel,
                            style: const TextStyle(
                              color: Color(0xFF948C88),
                              fontSize: 11,
                            ),
                          ),
                          ...page!.sentTotals.map(
                            (total) => Text(
                              transferMoney(
                                context,
                                total.amount,
                                total.currencyCode,
                              ),
                              style: const TextStyle(
                                color: Color(0xFF008B80),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ] else
                          const Text('—'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: busy || exporting || page == null ? null : onExport,
                icon: exporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(l10n.transferExport),
                style: FilledButton.styleFrom(
                  foregroundColor: const Color(0xFFE96C15),
                  backgroundColor: const Color(0xFFFFF3DF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
