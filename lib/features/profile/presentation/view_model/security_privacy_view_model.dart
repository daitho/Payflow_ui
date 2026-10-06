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
  bool _hasInitializationError = false;

  // =========================================================
  // GETTERS
  // =========================================================

  bool get isInitializing => _isInitializing;

  bool get isBiometricActionLoading => _isBiometricActionLoading;

  bool get biometricsAvailable => _biometricsAvailable;

  bool get biometricsEnabled => _biometricsEnabled;
  bool get hasInitializationError => _hasInitializationError;

  // =========================================================
  // INITIALIZE
  // =========================================================

  Future<void> initialize() async {
    _isInitializing = true;
    _hasInitializationError = false;

    notifyListeners();

    try {
      _biometricsAvailable = await _biometricService.isBiometricsAvailable();

      _biometricsEnabled = await _biometricService.isBiometricsEnabled();

      debugPrint('[BIOMETRIC] available=$_biometricsAvailable');

      debugPrint('[BIOMETRIC] enabled=$_biometricsEnabled');

      // Keep the stored choice visible even if biometrics became unavailable.
      // Startup will require a fresh login in that situation.
    } catch (_) {
      _hasInitializationError = true;
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
    if (_isInitializing || _hasInitializationError || _isBiometricActionLoading) {
      return BiometricToggleResult.technicalError;
    }

    if (!_biometricsAvailable) {
      return BiometricToggleResult.unavailable;
    }

    _isBiometricActionLoading = true;

    notifyListeners();

    try {
      final result = await _biometricService.setEnabled(
        enabled: enabled,
        localizedReason: localizedReason,
      );
      switch (result) {
        case BiometricAuthResult.success:
          break;
        case BiometricAuthResult.unavailable:
          return BiometricToggleResult.unavailable;
        case BiometricAuthResult.technicalError:
          return BiometricToggleResult.technicalError;
        case BiometricAuthResult.failed:
        case BiometricAuthResult.canceled:
        case BiometricAuthResult.lockedOut:
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
