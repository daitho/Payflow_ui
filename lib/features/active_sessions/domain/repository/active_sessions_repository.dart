import '../model/active_session_model.dart';

abstract interface class ActiveSessionsRepository {
  Future<List<ActiveSessionModel>> getSessions();

  Future<void> revokeSession({required String sessionId});

  Future<void> logoutOthers();

  Future<void> logoutCurrent({required String refreshToken});
}
