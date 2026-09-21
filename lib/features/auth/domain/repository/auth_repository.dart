import '../model/auth_session_model.dart';
import '../model/login_credentials.dart';
import '../model/register_command.dart';

abstract interface class AuthRepository {
  Future<AuthSessionModel> login(LoginCredentials credentials);

  Future<AuthSessionModel> register(RegisterCommand command);

  Future<AuthSessionModel> refresh(String refreshToken);
}
