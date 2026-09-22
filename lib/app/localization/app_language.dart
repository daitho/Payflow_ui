import 'package:flutter/material.dart';

enum AppLanguage {
  system(null),
  french('fr'),
  english('en'),
  spanish('es'),
  mandarin('zh'),
  hindi('hi');

  final String? languageCode;
  const AppLanguage(this.languageCode);

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);

  static AppLanguage fromStoredCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.languageCode == code,
      orElse: () => AppLanguage.system,
    );
  }
}
