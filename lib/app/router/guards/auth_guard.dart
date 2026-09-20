import '../../../core/service/session_service.dart';
import '../app_routes.dart';

class AuthGuard {
  final SessionService _sessionService;

  const AuthGuard({required SessionService sessionService})
    : _sessionService = sessionService;

  String? redirect() {
    switch (_sessionService.status) {
      // =====================================================
      // SESSION VALIDE
      // =====================================================
      case SessionStatus.authenticated:
        return null;

      // =====================================================
      // AUCUNE SESSION
      // =====================================================
      case SessionStatus.unauthenticated:
        return AppRoutes.login;

      // =====================================================
      // APPLICATION PAS ENCORE INITIALISÉE
      // OU REFRESH NÉCESSAIRE
      // =====================================================
      case SessionStatus.unknown:
      case SessionStatus.refreshRequired:
        return AppRoutes.splash;
    }
  }
}
