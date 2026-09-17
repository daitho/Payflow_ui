import 'package:flutter/foundation.dart';

import '../../../../core/service/session_service.dart';
import '../../domain/exception/active_sessions_exception.dart';
import '../../domain/model/active_session_model.dart';
import '../../domain/service/active_sessions_service.dart';

class ActiveSessionsViewModel extends ChangeNotifier {
  final ActiveSessionsService _service;
  final SessionService _sessionService;

  ActiveSessionsViewModel({
    required ActiveSessionsService service,
    required SessionService sessionService,
  }) : _service = service,
       _sessionService = sessionService;

  // =========================================================
  // STATE
  // =========================================================

  List<ActiveSessionModel> _sessions = [];
  bool _isLoading = false;
  String? _sessionBeingRevokedId;
  bool _isDisconnectingOthers = false;
  ActiveSessionsErrorType? _errorType;

  // =========================================================
  // GETTERS
  // =========================================================
  List<ActiveSessionModel> get sessions => List.unmodifiable(_sessions);

  bool get isLoading => _isLoading;

  String? get sessionBeingRevokedId => _sessionBeingRevokedId;

  ActiveSessionsErrorType? get errorType => _errorType;

  bool get hasError => _errorType != null;

  String? get currentSessionId => _sessionService.sessionId;

  bool get isDisconnectingOthers => _isDisconnectingOthers;

  // =========================================================
  // CURRENT SESSION
  // =========================================================
  bool isCurrentSession(ActiveSessionModel session) {
    final String? currentId = _sessionService.sessionId;

    if (currentId == null) {
      return false;
    }

    return session.sessionId == currentId;
  }

  // =========================================================
  // LOAD
  // =========================================================

  Future<void> load() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorType = null;

    notifyListeners();

    try {
      _sessions = await _service.getSessions();

      /*
       * La session courante est placée en premier.
       *
       * Les autres sont ensuite triées selon leur
       * dernière utilisation.
       */
      _sessions.sort((ActiveSessionModel a, ActiveSessionModel b) {
        final bool aCurrent = isCurrentSession(a);

        final bool bCurrent = isCurrentSession(b);

        if (aCurrent && !bCurrent) {
          return -1;
        }

        if (!aCurrent && bCurrent) {
          return 1;
        }

        final DateTime aDate = a.lastUsedAt ?? a.sessionCreatedAt;

        final DateTime bDate = b.lastUsedAt ?? b.sessionCreatedAt;

        return bDate.compareTo(aDate);
      });
    } on ActiveSessionsException catch (error) {
      _errorType = error.type;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // REVOKE SESSION
  // =========================================================

  Future<bool> revoke({required String sessionId}) async {
    if (_sessionBeingRevokedId != null) {
      return false;
    }

    /*
     * Sécurité frontend :
     *
     * la session courante ne doit pas être révoquée
     * depuis l'écran "Sessions actives".
     *
     * Pour quitter cet appareil, on utilisera
     * le vrai LogoutService.
     */
    if (sessionId == _sessionService.sessionId) {
      return false;
    }

    _sessionBeingRevokedId = sessionId;
    _errorType = null;

    notifyListeners();

    try {
      await _service.revokeSession(sessionId: sessionId);

      _sessions.removeWhere(
        (ActiveSessionModel session) => session.sessionId == sessionId,
      );

      return true;
    } on ActiveSessionsException catch (error) {
      _errorType = error.type;

      return false;
    } finally {
      _sessionBeingRevokedId = null;

      notifyListeners();
    }
  }

  // =========================================================
  // LOGOUT OTHER DEVICES
  // =========================================================

  Future<bool> logoutOthers() async {
    if (_isDisconnectingOthers) {
      return false;
    }
    _isDisconnectingOthers = true;
    _errorType = null;
    notifyListeners();
    try {
      await _service.logoutOthers();
      /*
     * IMPORTANT :
     *
     * La session courante reste active.
     *
     * Donc :
     * - aucun clearSession()
     * - aucun retour Login
     * - aucun changement de SessionStatus
     */
      return true;
    } on ActiveSessionsException catch (error) {
      _errorType = error.type;
      return false;
    } finally {
      _isDisconnectingOthers = false;
      notifyListeners();
    }
  }
}
