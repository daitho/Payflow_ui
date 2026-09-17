import '../../../core/service/session_service.dart';
import '../app_routes.dart';

class GuestGuard {
  final SessionService _sessionService;

  const GuestGuard({
    required SessionService sessionService,
  }) : _sessionService = sessionService;

  String? redirect() {
    switch (_sessionService.status) {
    // =====================================================
    // UTILISATEUR DÉJÀ CONNECTÉ
    // =====================================================
      case SessionStatus.authenticated:
        return AppRoutes.home;

    // =====================================================
    // PAS CONNECTÉ
    // =====================================================
      case SessionStatus.unauthenticated:
        return null;

    // =====================================================
    // ÉTAT PAS ENCORE RÉSOLU
    // =====================================================
      case SessionStatus.unknown:
      case SessionStatus.refreshRequired:
        return AppRoutes.splash;
    }
  }
}