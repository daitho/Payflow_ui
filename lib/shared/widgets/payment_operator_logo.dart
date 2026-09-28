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
    this.width = 48,
    this.height = 36,
  });

  final String? name;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final asset = paymentOperatorLogoAsset(name);
    return ExcludeSemantics(
      child: SizedBox(
        width: width,
        height: height,
        child: asset == null
            ? const Icon(Icons.account_balance_wallet_outlined)
            : Image.asset(
                asset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.account_balance_wallet_outlined),
              ),
      ),
    );
  }
}
