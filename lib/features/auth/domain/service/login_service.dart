import '../model/auth_session_model.dart';
import '../model/login_credentials.dart';
import '../repository/auth_repository.dart';

class LoginService {
  final AuthRepository _authRepository;

  const LoginService({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) {
    final credentials = LoginCredentials(
      email: email.trim().toLowerCase(),

      password: password,
    );

    return _authRepository.login(credentials);
  }
}
