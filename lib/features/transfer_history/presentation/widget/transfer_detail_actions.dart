import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class TransferDetailActions extends StatelessWidget {
  final bool receiptAvailable, repeatAllowed, busy;
  final VoidCallback? onReceipt, onRepeat;
  const TransferDetailActions({
    super.key,
    required this.receiptAvailable,
    required this.busy,
    this.repeatAllowed = false,
    this.onReceipt,
    this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];
    if (receiptAvailable && onReceipt != null) {
      actions.add(
        _action(
          icon: Icons.receipt_long,
          label: AppLocalizations.of(context).transferReceiptAction,
          onPressed: busy ? null : onReceipt,
          loading: busy,
        ),
      );
    }
    // The repeat action is intentionally rendered only when the route wires
    // a real repeat flow. `repeatAllowed` alone is an eligibility hint from
    // the backend, not a reason to navigate to a fabricated form.
    if (repeatAllowed && onRepeat != null) {
      actions.add(
        _action(
          icon: Icons.replay_rounded,
          label: AppLocalizations.of(context).transferRepeatAction,
          onPressed: busy ? null : onRepeat,
        ),
      );
    }
    if (actions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions,
      ),
    );
  }

  Widget _action({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool loading = false,
  }) => TextButton(
    onPressed: onPressed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFFFFE0A3),
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icon, color: const Color(0xFFE96C15)),
        ),
        const SizedBox(height: 10),
        Text(label, textAlign: TextAlign.center),
      ],
    ),
  );
}
