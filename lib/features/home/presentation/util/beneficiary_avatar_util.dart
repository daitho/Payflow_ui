import 'package:flutter/material.dart';

class BeneficiaryAvatarUtil {
  BeneficiaryAvatarUtil._();

  static const List<Color> _colors = [
    Color(0xFFE91E63),
    Color(0xFFFF9800),
    Color(0xFF00ACC1),
    Color(0xFF43A047),
    Color(0xFF7E57C2),
    Color(0xFFEF5350),
    Color(0xFF26A69A),
    Color(0xFF5C6BC0),
    Color(0xFFD81B60),
    Color(0xFFF9A825),
    Color(0xFF039BE5),
    Color(0xFF8E24AA),
  ];

  static Color colorForName(String displayName) {
    final String normalized = displayName.trim().toUpperCase();
    if (normalized.isEmpty) {
      return _colors.first;
    }
    final int code = normalized.codeUnitAt(0);
    /*
     * Même première lettre =>
     * même couleur.
     */
    return _colors[code % _colors.length];
  }
  static Color backgroundForName(String displayName) {
    return colorForName(displayName).withValues(alpha: 0.16);
  }
}
