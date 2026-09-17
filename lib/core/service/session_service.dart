import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/domain/model/auth_session_model.dart';
import '../../features/auth/domain/model/user_auth_model.dart';

enum SessionStatus { unknown, unauthenticated, refreshRequired, authenticated }
class SessionService extends ChangeNotifier {
  // =========================================================
  // STORAGE KEYS
  // =========================================================
  static const String _refreshTokenKey = 'payflow.auth.refresh_token';
  static const String _refreshExpiresAtKey = 'payflow.auth.refresh_expires_at';
  static const String _sessionIdKey = 'payflow.auth.session_id';

  // =========================================================
  // DEPENDENCIES
  // =========================================================
  final FlutterSecureStorage _secureStorage;
  SessionService({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  // =========================================================
  // STATE
  // =========================================================
  AuthSessionModel? _currentSession;
  UserAuthModel? _currentUser;
  SessionStatus _status = SessionStatus.unknown;

  // =========================================================
  // GETTERS
  // =========================================================
  SessionStatus get status => _status;
  AuthSessionModel? get currentSession => _currentSession;
  UserAuthModel? get currentUser => _currentSession?.user;
  String? get accessToken => _currentSession?.accessToken;
  String? get sessionId => _currentSession?.sessionId;
  bool get isAuthenticated =>
      _status == SessionStatus.authenticated && _currentSession != null;
  bool get refreshRequired => _status == SessionStatus.refreshRequired;
  bool get isAccessTokenExpired {
    final session = _currentSession;
    if (session == null) {
      return true;
    }
    return !session.accessExpiresAt.toUtc().isAfter(DateTime.now().toUtc());
  }

  // =========================================================
  // INITIALIZATION
  // =========================================================
  Future<void> initialize() async {
    final String? refreshToken = await readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      _currentSession = null;
      _status = SessionStatus.unauthenticated;
      notifyListeners();
      return;
    }

    final DateTime? refreshExpiresAt = await readRefreshExpiresAt();
    if (refreshExpiresAt != null &&
        !refreshExpiresAt.toUtc().isAfter(DateTime.now().toUtc())) {
      await clearSession();
      return;
    }

    /*
     * L'application vient probablement
     * d'être relancée.
     *
     * L'access token n'est plus en mémoire,
     * mais un refresh token existe.
     *
     * On devra donc appeler /auth/refresh.
     */

    _currentSession = null;
    _status = SessionStatus.refreshRequired;
    notifyListeners();
  }

  // =========================================================
  // SAVE SESSION
  // =========================================================

  Future<void> saveSession(AuthSessionModel session) async {
    await Future.wait([
      _secureStorage.write(key: _refreshTokenKey, value: session.refreshToken),
      _secureStorage.write(
        key: _refreshExpiresAtKey,
        value: session.refreshExpiresAt.toUtc().toIso8601String(),
      ),
      _secureStorage.write(key: _sessionIdKey, value: session.sessionId),
    ]);

    /*
     * Access token :
     * uniquement en mémoire.
     */
    _currentSession = session;
    _currentUser = session.user;
    _status = SessionStatus.authenticated;
    notifyListeners();
  }

  // =========================================================
  // REFRESH TOKEN
  // =========================================================
  Future<String?> readRefreshToken() {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  Future<DateTime?> readRefreshExpiresAt() async {
    final String? rawValue = await _secureStorage.read(
      key: _refreshExpiresAtKey,
    );
    if (rawValue == null) {
      return null;
    }
    return DateTime.tryParse(rawValue);
  }
  Future<String?> readStoredSessionId() {
    return _secureStorage.read(key: _sessionIdKey);
  }

  // =========================================================
  // CLEAR SESSION
  // =========================================================

  Future<void> clearSession() async {
    await Future.wait([
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _refreshExpiresAtKey),
      _secureStorage.delete(key: _sessionIdKey),
    ]);

    _currentSession = null;
    _currentUser = null;
    _status = SessionStatus.unauthenticated;
    notifyListeners();
  }
}
