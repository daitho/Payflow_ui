import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricAuthResult {
  success,
  failed,
  canceled,
  unavailable,
  lockedOut,
  technicalError,
}
class BiometricService {
  // =========================================================
  // STORAGE KEY
  // =========================================================
  static const String _biometricsEnabledKey = 'payflow.biometrics.enabled.v2';

  // =========================================================
  // DEPENDENCIES
  // =========================================================
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuthentication;

  BiometricService({
    required FlutterSecureStorage secureStorage,
    LocalAuthentication? localAuthentication,
  }) : _secureStorage = secureStorage,
       _localAuthentication = localAuthentication ?? LocalAuthentication();

  Future<BiometricAuthResult>
  authenticateForAppUnlock({
    required String localizedReason,
  }) async {
    try {
      final bool available =
      await isBiometricsAvailable();

      if (!available) {
        return BiometricAuthResult.unavailable;
      }

      final bool authenticated =
      await _localAuthentication.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      return authenticated
          ? BiometricAuthResult.success
          : BiometricAuthResult.failed;
    } on LocalAuthException catch (error) {
      debugPrint(
        '[BIOMETRIC] LocalAuthException: ${error.code}',
      );

      if (error.code ==
          LocalAuthExceptionCode.userCanceled ||
          error.code ==
              LocalAuthExceptionCode.userRequestedFallback) {
        return BiometricAuthResult.canceled;
      }

      if (error.code ==
          LocalAuthExceptionCode.temporaryLockout ||
          error.code ==
              LocalAuthExceptionCode.biometricLockout) {
        return BiometricAuthResult.lockedOut;
      }

      if (error.code ==
          LocalAuthExceptionCode.noBiometricHardware ||
          error.code ==
              LocalAuthExceptionCode.noBiometricsEnrolled ||
          error.code ==
              LocalAuthExceptionCode.noCredentialsSet ||
          error.code ==
              LocalAuthExceptionCode
                  .biometricHardwareTemporarilyUnavailable) {
        return BiometricAuthResult.unavailable;
      }

      return BiometricAuthResult.technicalError;
    } catch (error) {
      debugPrint(
        '[BIOMETRIC] Unexpected error: $error',
      );

      return BiometricAuthResult.technicalError;
    }
  }

  // =========================================================
  // AVAILABILITY
  // =========================================================
  Future<bool> isBiometricsAvailable() async {
    try {
      final bool deviceSupported = await _localAuthentication
          .isDeviceSupported();
      if (!deviceSupported) {
        return false;
      }

      final bool canCheck = await _localAuthentication.canCheckBiometrics;

      if (!canCheck) {
        return false;
      }
      final List<BiometricType> availableBiometrics = await _localAuthentication
          .getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // =========================================================
  // ENABLED PREFERENCE
  // =========================================================

  Future<bool> isBiometricsEnabled() async {
    final String? value = await _secureStorage.read(key: _biometricsEnabledKey);
    return value == 'true';
  }
  // =========================================================
  // AUTHENTICATE
  // =========================================================
  Future<bool> authenticate({required String localizedReason}) async {
    final bool available = await isBiometricsAvailable();

    if (!available) {
      return false;
    }
    try {
      return await _localAuthentication.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  // =========================================================
  // ENABLE
  // =========================================================
  Future<bool> enable({required String localizedReason}) async {
    /*
     * On n'active jamais simplement un booléen.
     *
     * L'utilisateur doit d'abord réussir
     * une vraie authentification biométrique.
     */
    final bool authenticated = await authenticate(
      localizedReason: localizedReason,
    );
    if (!authenticated) {
      return false;
    }

    await _secureStorage.write(key: _biometricsEnabledKey, value: 'true');
    return true;
  }
  // =========================================================
  // DISABLE
  // =========================================================
  Future<bool> disable({required String localizedReason}) async {
    /*
     * Désactiver une protection de sécurité
     * est également une opération sensible.
     *
     * On demande donc une authentification.
     */
    final bool authenticated = await authenticate(
      localizedReason: localizedReason,
    );
    if (!authenticated) {
      return false;
    }
    await _secureStorage.write(key: _biometricsEnabledKey, value: 'false');
    return true;
  }
}
