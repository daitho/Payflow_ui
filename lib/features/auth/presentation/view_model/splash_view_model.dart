import 'package:flutter/foundation.dart';

import '../../../../core/service/biometric_service.dart';
import '../../../../core/service/session_service.dart';

import '../../domain/exception/session_expired_exception.dart';
import '../../domain/service/refresh_service.dart';

enum SplashDestination { login, home }

enum SplashBiometricState { none, authenticating, failed, unavailable }

class SplashViewModel extends ChangeNotifier {
  final SessionService _sessionService;
  final RefreshService _refreshService;
  final BiometricService _biometricService;
  static const int _maxBiometricAttempts = 3;

  int _biometricAttemptCount = 0;

  SplashViewModel({
    required SessionService sessionService,
    required RefreshService refreshService,
    required BiometricService biometricService,
  }) : _sessionService = sessionService,
       _refreshService = refreshService,
       _biometricService = biometricService;

  // =========================================================
  // STATE
  // =========================================================

  bool _isLoading = false;
  bool _hasTechnicalError = false;

  SplashBiometricState _biometricState = SplashBiometricState.none;

  // =========================================================
  // GETTERS
  // =========================================================

  bool get isLoading => _isLoading;

  bool get hasTechnicalError => _hasTechnicalError;

  SplashBiometricState get biometricState => _biometricState;

  bool get hasBiometricError =>
      _biometricState == SplashBiometricState.failed ||
      _biometricState == SplashBiometricState.unavailable;

  int get biometricAttemptCount => _biometricAttemptCount;

  int get biometricAttemptsRemaining =>
      _maxBiometricAttempts - _biometricAttemptCount;

  // =========================================================
  // INITIALIZE
  // =========================================================

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
      // -----------------------------------------------------
      // 1. Lecture du SecureStorage / état de session
      // -----------------------------------------------------

      await _sessionService.initialize();

      // -----------------------------------------------------
      // 2. Aucune session locale
      // -----------------------------------------------------

      if (_sessionService.status == SessionStatus.unauthenticated) {
        return SplashDestination.login;
      }

      // -----------------------------------------------------
      // 3. Session déjà active en mémoire
      //
      // Cas typique :
      // navigation interne / session déjà restaurée.
      // -----------------------------------------------------

      if (_sessionService.status == SessionStatus.authenticated) {
        return SplashDestination.home;
      }

      // -----------------------------------------------------
      // 4. Un refresh est nécessaire
      // -----------------------------------------------------

      if (_sessionService.status != SessionStatus.refreshRequired) {
        return SplashDestination.login;
      }

      // =====================================================
      // 5. BIOMETRIE
      //
      // IMPORTANT :
      // la biométrie passe AVANT la lecture/utilisation du
      // refresh token.
      // =====================================================

      final bool biometricsEnabled = await _biometricService
          .isBiometricsEnabled();
      debugPrint('[SPLASH] biometricsEnabled=$biometricsEnabled');
      // =====================================================
      // BIOMETRIE DESACTIVEE
      //
      // AUCUN appel à authenticate() ne doit être effectué.
      // =====================================================
      if (!biometricsEnabled) {
        debugPrint('[SPLASH] Biometrics disabled - authentication skipped');
        _biometricAttemptCount = 0;
      }
      // =====================================================
      // BIOMETRIE ACTIVEE
      // =====================================================
      else {
        debugPrint('[SPLASH] Biometrics enabled - authentication required');
        // ---------------------------------------------------
        // Vérifier si la biométrie est toujours disponible
        // ---------------------------------------------------
        final bool biometricsAvailable = await _biometricService
            .isBiometricsAvailable();
        if (!biometricsAvailable) {
          debugPrint('[SPLASH] Biometrics unavailable - redirecting to login');

          /*
     * On ne laisse surtout pas l'utilisateur
     * bloqué indéfiniment sur le Splash.
     *
     * On termine la session locale afin que
     * GuestGuard autorise réellement /login.
     */
          await _sessionService.clearSession();
          _biometricAttemptCount = 0;
          _biometricState = SplashBiometricState.none;
          return SplashDestination.login;
        }

        // ---------------------------------------------------
        // Lancement Face ID / Touch ID / empreinte
        // ---------------------------------------------------
        _biometricState = SplashBiometricState.authenticating;
        notifyListeners();
        final bool authenticated = await _biometricService.authenticate(
          localizedReason: biometricReason,
        );
        // ---------------------------------------------------
        // ECHEC / ANNULATION
        // ---------------------------------------------------
        if (!authenticated) {
          _biometricAttemptCount++;
          debugPrint(
            '[SPLASH] Biometric authentication failed '
            '$_biometricAttemptCount/'
            '$_maxBiometricAttempts',
          );
          // -------------------------------------------------
          // Nombre maximal de tentatives atteint
          // -------------------------------------------------
          if (_biometricAttemptCount >= _maxBiometricAttempts) {
            debugPrint(
              '[SPLASH] Maximum biometric attempts reached '
              '- redirecting to login',
            );
            /*
       * Le mot de passe redevient alors
       * le moyen d'authentification.
       *
       * clearSession() fait également passer
       * SessionService en unauthenticated,
       * ce qui évite une boucle :
       *
       * Login -> GuestGuard -> Splash -> Login...
       */
            await _sessionService.clearSession();
            _biometricAttemptCount = 0;
            _biometricState = SplashBiometricState.none;
            return SplashDestination.login;
          }

          // -------------------------------------------------
          // Il reste encore des tentatives
          // -------------------------------------------------
          _biometricState = SplashBiometricState.failed;

          return null;
        }
        // ---------------------------------------------------
        // SUCCES
        // ---------------------------------------------------
        debugPrint('[SPLASH] Biometric authentication successful');
        _biometricAttemptCount = 0;

        _biometricState = SplashBiometricState.none;
      }
      // =====================================================
      // 6. REFRESH TOKEN
      //
      // Cette partie n'est atteinte qu'après validation
      // biométrique lorsque la biométrie est activée.
      // =====================================================
      final String? refreshToken = await _sessionService.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _sessionService.clearSession();
        return SplashDestination.login;
      }

      // -----------------------------------------------------
      // 7. POST /api/v1/auth/refresh
      // -----------------------------------------------------
      final refreshedSession = await _refreshService.refresh(
        refreshToken: refreshToken,
      );

      // -----------------------------------------------------
      // 8. Rotation refresh token
      // -----------------------------------------------------
      await _sessionService.saveSession(refreshedSession);
      return SplashDestination.home;
    }
    // =======================================================
    // SESSION INVALID / EXPIRED / REVOKED / REUSED
    // =======================================================
    on SessionExpiredException {
      await _sessionService.clearSession();
      return SplashDestination.login;
    }
    // =======================================================
    // TECHNICAL / NETWORK ERROR
    // =======================================================
    catch (error, stackTrace) {
      /*
       * Le refresh token n'est PAS supprimé.
       *
       * Une absence de réseau ne signifie pas que
       * l'utilisateur doit être déconnecté.
       */

      debugPrint('[SPLASH] Technical initialization error: $error');

      debugPrintStack(stackTrace: stackTrace);

      _hasTechnicalError = true;

      return null;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
