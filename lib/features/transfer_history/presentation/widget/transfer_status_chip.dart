import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'transfer_format.dart';

class TransferStatusChip extends StatelessWidget {
  final String status;
  const TransferStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'COMPLETED' => const Color(0xFF008B80),
      'REFUNDED' => const Color(0xFF7657A8),
      'FAILED' || 'CANCELLED' => const Color(0xFFB3261E),
      _ => const Color(0xFF946000),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        transferStatus(AppLocalizations.of(context), status),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
