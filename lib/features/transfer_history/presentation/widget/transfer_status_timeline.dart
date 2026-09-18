import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/model/transfer_detail_model.dart';
import 'transfer_format.dart';

class TransferStatusTimeline extends StatelessWidget {
  final TransferDetailModel detail;
  const TransferStatusTimeline({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Only dated events supplied by the server are represented as reached.
    final events = [...detail.timeline]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final message = switch (detail.status) {
      'COMPLETED' => l10n.transferTrackingCompleted,
      'FAILED' => l10n.transferTrackingFailed,
      'CANCELLED' => l10n.transferTrackingCancelled,
      'REFUNDED' => l10n.transferTrackingRefunded,
      _ => l10n.transferTrackingPending,
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAE5E2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(transferStatus(l10n, detail.status),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(message, style: const TextStyle(color: Color(0xFF77706C))),
        if (detail.status == 'COMPLETED' && detail.receivedAt != null)
          Text(transferDate(context, detail.receivedAt!)),
        const SizedBox(height: 20),
        if (events.isEmpty) Text(l10n.transferTimelineUnavailable)
        else SingleChildScrollView(scrollDirection: Axis.horizontal,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var i = 0; i < events.length; i++) SizedBox(width: 112,
              child: Column(children: [
                Row(children: [
                  Expanded(child: Container(height: 2,
                    color: i == 0 ? Colors.transparent : const Color(0xFF1E3A5F))),
                  CircleAvatar(radius: 17,
                    backgroundColor: _eventColor(events[i].status),
                    child: Icon(_icon(events[i].status), color: Colors.white, size: 19)),
                  Expanded(child: Container(height: 2,
                    color: i == events.length - 1 ? Colors.transparent : const Color(0xFF1E3A5F))),
                ]),
                const SizedBox(height: 8),
                Text(transferStatus(l10n, events[i].status), textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(transferDate(context, events[i].occurredAt), textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF948C88))),
              ])),
          ])),
      ]),
    );
  }

  IconData _icon(String status) => switch (status) {
    'CREATED' => Icons.flag_outlined,
    'PENDING' => Icons.schedule,
    'PROCESSING' => Icons.sync,
    'COMPLETED' => Icons.person_pin_circle_outlined,
    'FAILED' => Icons.priority_high,
    'CANCELLED' => Icons.close,
    'REFUNDED' => Icons.assignment_return_outlined,
    _ => Icons.help_outline,
  };

  Color _eventColor(String status) => switch (status) {
    'FAILED' || 'CANCELLED' => const Color(0xFFB3261E),
    'REFUNDED' => const Color(0xFF7657A8),
    _ => const Color(0xFF1E3A5F),
  };
}
