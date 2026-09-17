import 'package:flutter/foundation.dart';

import '../../../../core/service/biometric_service.dart';

enum BiometricToggleResult {
  success,
  unavailable,
  authenticationFailed,
  technicalError,
}

class SecurityPrivacyViewModel extends ChangeNotifier {
  final BiometricService _biometricService;

  SecurityPrivacyViewModel({required BiometricService biometricService})
    : _biometricService = biometricService;

  // =========================================================
  // STATE
  // =========================================================

  bool _isInitializing = true;

  bool _isBiometricActionLoading = false;

  bool _biometricsAvailable = false;

  bool _biometricsEnabled = false;

  // =========================================================
  // GETTERS
  // =========================================================

  bool get isInitializing => _isInitializing;

  bool get isBiometricActionLoading => _isBiometricActionLoading;

  bool get biometricsAvailable => _biometricsAvailable;

  bool get biometricsEnabled => _biometricsEnabled;

  // =========================================================
  // INITIALIZE
  // =========================================================

  Future<void> initialize() async {
    _isInitializing = true;

    notifyListeners();

    try {
      _biometricsAvailable = await _biometricService.isBiometricsAvailable();

      _biometricsEnabled = await _biometricService.isBiometricsEnabled();

      debugPrint(
        '[BIOMETRIC] available=$_biometricsAvailable',
      );

      debugPrint(
          '[BIOMETRIC] enabled=$_biometricsEnabled',
      );

      /*
       * Cas :
       *
       * préférence enregistrée = true
       * mais l'utilisateur a supprimé
       * Face ID / empreinte du téléphone.
       *
       * L'UI ne doit pas prétendre que
       * la biométrie est utilisable.
       */

      if (!_biometricsAvailable && _biometricsEnabled) {
        _biometricsEnabled = false;
      }
    } finally {
      _isInitializing = false;

      notifyListeners();
    }
  }

  // =========================================================
  // TOGGLE
  // =========================================================

  Future<BiometricToggleResult> setBiometricsEnabled({
    required bool enabled,
    required String localizedReason,
  }) async {
    if (_isBiometricActionLoading) {
      return BiometricToggleResult.technicalError;
    }

    if (!_biometricsAvailable) {
      return BiometricToggleResult.unavailable;
    }

    _isBiometricActionLoading = true;

    notifyListeners();

    try {
      final bool success;

      if (enabled) {
        success = await _biometricService.enable(
          localizedReason: localizedReason,
        );
      } else {
        success = await _biometricService.disable(
          localizedReason: localizedReason,
        );
      }

      if (!success) {
        return BiometricToggleResult.authenticationFailed;
      }

      _biometricsEnabled = enabled;

      return BiometricToggleResult.success;
    } catch (_) {
      return BiometricToggleResult.technicalError;
    } finally {
      _isBiometricActionLoading = false;

      notifyListeners();
    }
  }
}
