import '../model/auth_session_model.dart';
import '../repository/auth_repository.dart';

class RefreshService {
  final AuthRepository _authRepository;

  const RefreshService({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<AuthSessionModel> refresh({required String refreshToken}) {
    return _authRepository.refresh(refreshToken);
  }
}
