import 'package:flutter/material.dart';
import '../../domain/model/beneficiary_contact.dart';

/// One distinct, stable PayFlow accent for each Latin letter A–Z.
abstract final class BeneficiaryPalette {
  static const colors = <Color>[
    Color(0xFFE91E63), Color(0xFF00897B), Color(0xFF00ACC1), Color(0xFFFF9800),
    Color(0xFF5C6BC0), Color(0xFF9C27B0), Color(0xFFEF5350), Color(0xFF00838F),
    Color(0xFF7CB342), Color(0xFF43A047), Color(0xFFFF7043), Color(0xFF7E57C2),
    Color(0xFF2196F3), Color(0xFFD81B60), Color(0xFFF9A825), Color(0xFF26A69A),
    Color(0xFF3949AB), Color(0xFFF4511E), Color(0xFF039BE5), Color(0xFF8E24AA),
    Color(0xFF689F38), Color(0xFF00BFA5), Color(0xFF546E7A), Color(0xFFC2185B),
    Color(0xFF6D4C41), Color(0xFF00695C),
  ];
  static Color forName(String name) {
    final normalized = beneficiarySearchKey(name);
    if (normalized.isEmpty) return const Color(0xFF78909C);
    final index = normalized.codeUnitAt(0) - 65;
    return index >= 0 && index < 26 ? colors[index] : const Color(0xFF78909C);
  }
}

String beneficiaryFlag(String countryCode) {
  final code = countryCode.toUpperCase();
  if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) return '';
  return String.fromCharCodes(code.codeUnits.map((c) => 0x1F1E6 + c - 65));
}

class BeneficiaryAvatar extends StatelessWidget {
  final BeneficiaryContact contact;
  const BeneficiaryAvatar({super.key, required this.contact});
  @override
  Widget build(BuildContext context) {
    final color = BeneficiaryPalette.forName(contact.fullName);
    return SizedBox(width: 46, height: 46, child: Stack(children: [
      CircleAvatar(radius: 22, backgroundColor: color.withValues(alpha: .18),
        child: Icon(switch (contact.gender) {
          BeneficiaryGender.female => Icons.woman_rounded,
          BeneficiaryGender.male => Icons.man_rounded,
          null => Icons.person_rounded,
        }, size: 30, color: color)),
      Positioned(right: 0, bottom: 0, child: Container(
        width: 18, height: 18, alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Text(beneficiaryFlag(contact.countryCode), style: const TextStyle(fontSize: 10)),
      )),
    ]));
  }
}
