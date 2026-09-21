import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_language.dart';

class LocaleController extends ChangeNotifier {
  static const String _languagePreferenceKey = 'payflow.language';

  final SharedPreferencesAsync _preferences;
  AppLanguage _language = AppLanguage.system;

  LocaleController({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  AppLanguage get language => _language;
  Locale? get locale => _language.locale;

  Future<void> load() async {
    try {
      final code = await _preferences.getString(_languagePreferenceKey);
      _language = AppLanguage.fromStoredCode(code);
    } catch (_) {
      _language = AppLanguage.system;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) {
      return;
    }

    _language = language;
    notifyListeners();

    try {
      final code = language.languageCode;
      if (code == null) {
        await _preferences.remove(_languagePreferenceKey);
      } else {
        await _preferences.setString(_languagePreferenceKey, code);
      }
    } catch (_) {
      // The language remains usable for the current session even if the
      // non-critical local preference cannot be persisted.
    }
  }

  Future<void> setLocale(Locale locale) {
    return setLanguage(AppLanguage.fromStoredCode(locale.languageCode));
  }

  Future<void> useSystemLocale() {
    return setLanguage(AppLanguage.system);
  }
}
