import 'package:flutter/foundation.dart';
import '../../../../core/service/session_service.dart';
import '../../domain/exception/active_sessions_exception.dart';
import '../../domain/model/active_session_model.dart';
import '../../domain/service/active_sessions_service.dart';

class CurrentDeviceViewModel extends ChangeNotifier {
  final ActiveSessionsService _service;
  final SessionService _sessionService;

  CurrentDeviceViewModel({
    required ActiveSessionsService service,
    required SessionService sessionService,
  }) : _service = service,
       _sessionService = sessionService;

  // =========================================================
  // STATE
  // =========================================================
  ActiveSessionModel? _currentSession;
  bool _isLoading = false;
  bool _isLoggingOut = false;
  ActiveSessionsErrorType? _errorType;

  // =========================================================
  // GETTERS
  // =========================================================
  ActiveSessionModel? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  bool get isLoggingOut => _isLoggingOut;
  ActiveSessionsErrorType? get errorType => _errorType;
  bool get hasError => _errorType != null;

  // =========================================================
  // LOAD CURRENT DEVICE
  // =========================================================
  Future<void> load() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _errorType = null;
    notifyListeners();

    try {
      final String? currentSessionId = _sessionService.sessionId;
      if (currentSessionId == null || currentSessionId.isEmpty) {
        _currentSession = null;
        _errorType = ActiveSessionsErrorType.unexpected;
        return;
      }

      final List<ActiveSessionModel> sessions = await _service.getSessions();
      ActiveSessionModel? current;

      for (final ActiveSessionModel session in sessions) {
        if (session.sessionId == currentSessionId) {
          current = session;
          break;
        }
      }
      _currentSession = current;
      if (_currentSession == null) {
        _errorType = ActiveSessionsErrorType.unexpected;
      }
    } on ActiveSessionsException catch (error) {
      _errorType = error.type;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // LOGOUT CURRENT DEVICE
  // =========================================================
  Future<bool> logoutCurrentDevice() async {
    if (_isLoggingOut) {
      return false;
    }
    _isLoggingOut = true;
    _errorType = null;
    notifyListeners();

    try {
      // =====================================================
      // 1. READ LOCAL REFRESH TOKEN
      // =====================================================
      final String? refreshToken = await _sessionService.readRefreshToken();

      /*
     * Cas anormal :
     *
     * aucun refresh token n'est présent localement.
     *
     * Il n'y a plus de session persistante exploitable
     * côté application.
     *
     * On termine donc simplement la session locale.
     */
      if (refreshToken == null || refreshToken.isEmpty) {
        _isLoggingOut = false;
        notifyListeners();
        await _sessionService.clearSession();
        return true;
      }

      // =====================================================
      // 2. REVOKE SERVER SESSION
      // =====================================================
      await _service.logoutCurrent(refreshToken: refreshToken);

      // =====================================================
      // 3. API SUCCESS
      //
      // Le serveur a maintenant révoqué la session.
      // On peut supprimer les secrets locaux.
      // =====================================================
      _isLoggingOut = false;
      notifyListeners();
      await _sessionService.clearSession();

      /*
     * SessionService devient unauthenticated.
     *
     * GoRouter écoute SessionService grâce à :
     *
     * refreshListenable: _sessionService
     *
     * Il redirigera donc automatiquement vers Login.
     */
      return true;
    } on ActiveSessionsException catch (error) {
      /*
     * IMPORTANT :
     *
     * En cas d'erreur réseau ou serveur,
     * nous NE supprimons PAS le refresh token.
     *
     * L'utilisateur reste connecté et peut
     * retenter le logout.
     */
      _errorType = error.type;
      _isLoggingOut = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorType = ActiveSessionsErrorType.unexpected;
      _isLoggingOut = false;
      notifyListeners();
      return false;
    }
  }
}
