import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/transfer_detail_model.dart';
import 'transfer_format.dart';
import 'transfer_status_chip.dart';

class TransferDetailHeader extends StatelessWidget {
  final TransferDetailModel detail;
  const TransferDetailHeader({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = detail.countryCode.toUpperCase();
    final flag = RegExp(r'^[A-Z]{2}$').hasMatch(code)
        ? String.fromCharCodes(code.codeUnits.map((unit) => unit + 127397))
        : code;
    final amount = transferMoney(
      context,
      detail.sentAmount,
      detail.sourceCurrencyCode,
    );
    final recipientDetails = [
      if (detail.destination != null && detail.destination!.trim().isNotEmpty)
        detail.destination!.trim(),
      if (detail.operatorName.trim().isNotEmpty) detail.operatorName.trim(),
    ].join(' · ');
    return Column(
      children: [
        Text(
          transferDate(context, detail.createdAt),
          style: const TextStyle(color: Color(0xFF948C88), fontSize: 12),
        ),
        const SizedBox(height: 8),
        TransferStatusChip(status: detail.status),
        const SizedBox(height: 24),
        Text(flag, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 12),
        Text(
          l10n.transferSentTo(amount, detail.beneficiaryName),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (recipientDetails.isNotEmpty)
          Text(
            recipientDetails,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        if (detail.providerReference != null)
          Text(
            '${l10n.transferProviderReference} : ${detail.providerReference}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF948C88)),
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
