import 'package:flutter/foundation.dart';

import '../../../../core/service/biometric_service.dart';
import '../../../../core/service/session_service.dart';
import '../../domain/exception/session_expired_exception.dart';
import '../../domain/service/refresh_service.dart';

enum SplashDestination { login, home }

enum SplashBiometricState {
  none,
  authenticating,
  failed,
  unavailable,
  technicalError,
}

class SplashViewModel extends ChangeNotifier {
  final SessionService _sessionService;
  final RefreshService _refreshService;
  final BiometricService _biometricService;
  static const int _maxBiometricAttempts = 3;

  SplashViewModel({
    required SessionService sessionService,
    required RefreshService refreshService,
    required BiometricService biometricService,
  }) : _sessionService = sessionService,
       _refreshService = refreshService,
       _biometricService = biometricService;

  int _biometricAttemptCount = 0;
  bool _isLoading = false;
  bool _hasTechnicalError = false;
  bool _biometricPassed = false;
  SplashBiometricState _biometricState = SplashBiometricState.none;

  bool get isLoading => _isLoading;
  bool get hasTechnicalError => _hasTechnicalError;
  SplashBiometricState get biometricState => _biometricState;
  bool get hasBiometricError =>
      _biometricState == SplashBiometricState.failed ||
      _biometricState == SplashBiometricState.unavailable ||
      _biometricState == SplashBiometricState.technicalError;
  int get biometricAttemptCount => _biometricAttemptCount;
  int get biometricAttemptsRemaining =>
      _maxBiometricAttempts - _biometricAttemptCount;

  Future<SplashDestination?> initialize({
    required String biometricReason,
  }) async {
    if (_isLoading) {
      return null;
    }
    _isLoading = true;
    _hasTechnicalError = false;
    _biometricState = SplashBiometricState.none;
    notifyListeners();

    try {
      await _sessionService.initialize();
      if (_sessionService.status == SessionStatus.unauthenticated) {
        return SplashDestination.login;
      }
      if (_sessionService.isAuthenticated) {
        return SplashDestination.home;
      }
      if (!_sessionService.refreshRequired) {
        return await _goToLogin();
      }

      // A network retry reuses the successful local check. It must not
      // re-prompt Face ID or count a network failure as a biometric failure.
      if (!_biometricPassed) {
        final enabled = await _biometricService.isBiometricsEnabled();
        if (enabled) {
          _biometricState = SplashBiometricState.authenticating;
          notifyListeners();
          final result = await _biometricService.authenticateForAppUnlock(
            localizedReason: biometricReason,
          );
          switch (result) {
            case BiometricAuthResult.success:
              break;
            case BiometricAuthResult.failed:
              _biometricAttemptCount++;
              if (_biometricAttemptCount >= _maxBiometricAttempts) {
                return await _goToLogin();
              }
              _biometricState = SplashBiometricState.failed;
              return null;
            case BiometricAuthResult.canceled:
            case BiometricAuthResult.unavailable:
            case BiometricAuthResult.lockedOut:
              return await _goToLogin();
            case BiometricAuthResult.technicalError:
              _biometricState = SplashBiometricState.technicalError;
              return null;
          }
        }
        _biometricPassed = true;
        _biometricAttemptCount = 0;
        _sessionService.authorizeSessionRestoration();
      }
      _biometricState = SplashBiometricState.none;

      final token = await _sessionService.readRefreshToken();
      if (token == null || token.isEmpty) {
        return await _goToLogin();
      }
      final session = await _refreshService.refresh(refreshToken: token);
      await _sessionService.saveSession(session);
      return SplashDestination.home;
    } on SessionExpiredException {
      return await _goToLogin();
    } catch (error, stackTrace) {
      // Preserve the refresh token for network/storage errors. A revoked
      // session is handled separately, by SessionExpiredException.
      debugPrint('[SPLASH] Initialization failed: ${error.runtimeType}');
      debugPrintStack(stackTrace: stackTrace);
      _hasTechnicalError = true;
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SplashDestination?> useLogin() async {
    if (_isLoading) {
      return null;
    }
    _isLoading = true;
    notifyListeners();
    try {
      return await _goToLogin();
    } catch (_) {
      _hasTechnicalError = true;
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SplashDestination> _goToLogin() async {
    await _sessionService.clearSession();
    _biometricPassed = false;
    _biometricAttemptCount = 0;
    _biometricState = SplashBiometricState.none;
    return SplashDestination.login;
  }
}
