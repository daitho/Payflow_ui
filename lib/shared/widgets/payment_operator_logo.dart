import 'package:flutter/material.dart';

/// The beneficiary catalog currently exposes an operator name, but no stable
/// logo identifier. Match known names locally so the picker works offline.
String? paymentOperatorLogoAsset(String? name) {
  final normalized = name?.trim().toUpperCase();
  if (normalized == null || normalized.isEmpty) return null;
  if (RegExp(r'(^|[^A-Z])MTN([^A-Z]|$)').hasMatch(normalized)) {
    return 'assets/images/transfer/mtn_mobile_money.jpg';
  }
  if (RegExp(r'(^|[^A-Z])ORANGE([^A-Z]|$)').hasMatch(normalized)) {
    return 'assets/images/transfer/orange_money.jpg';
  }
  if (RegExp(r'(^|[^A-Z])WAVE([^A-Z]|$)').hasMatch(normalized)) {
    return 'assets/images/transfer/wave.png';
  }
  if (RegExp(r'(^|[^A-Z])M[ -]?PESA([^A-Z]|$)').hasMatch(normalized)) {
    return 'assets/images/transfer/mpesa.png';
  }
  return null;
}

class PaymentOperatorLogo extends StatelessWidget {
  const PaymentOperatorLogo({
    super.key,
    required this.name,
    this.width = 64,
    this.height = 44,
  });

  final String? name;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final asset = paymentOperatorLogoAsset(name);
    final normalized = name?.toUpperCase() ?? '';
    final isOrange = normalized.contains('ORANGE');
    final isMtn = normalized.contains('MTN');
    final accent = isMtn
        ? const Color(0xFFE8B900)
        : isOrange
        ? const Color(0xFFFF7900)
        : normalized.contains('WAVE')
        ? const Color(0xFF13B9E8)
        : normalized.contains('PESA')
        ? const Color(0xFF008F47)
        : const Color(0xFF397F79);
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(isMtn || isOrange ? 2 : 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: .28)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: .09),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: asset == null
              ? Icon(Icons.account_balance_wallet_outlined, color: accent)
              : Transform.scale(
                  // Focus on the Orange Money mark and the MTN Mobile Money
                  // lockup; the source images include generous outer margins.
                  scale: isOrange
                      ? 1.75
                      : isMtn
                      ? 1.12
                      : 1,
                  alignment: isOrange
                      ? Alignment.centerRight
                      : Alignment.center,
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.account_balance_wallet_outlined, color: accent),
                  ),
                ),
        ),
      ),
    );
  }
}
