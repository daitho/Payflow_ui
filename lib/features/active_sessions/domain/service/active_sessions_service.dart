import '../model/active_session_model.dart';
import '../repository/active_sessions_repository.dart';

class ActiveSessionsService {
  final ActiveSessionsRepository _repository;

  ActiveSessionsService({required ActiveSessionsRepository repository})
    : _repository = repository;

  Future<List<ActiveSessionModel>> getSessions() {
    return _repository.getSessions();
  }

  Future<void> logoutOthers() {
    return _repository.logoutOthers();
  }

  Future<void> revokeSession({required String sessionId}) {
    return _repository.revokeSession(sessionId: sessionId);
  }

  Future<void> logoutCurrent({required String refreshToken}) {
    return _repository.logoutCurrent(refreshToken: refreshToken);
  }
}
