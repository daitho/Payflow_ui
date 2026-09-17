import '../model/auth_session_model.dart';
import '../model/register_command.dart';
import '../repository/auth_repository.dart';

class RegisterService {
  final AuthRepository _authRepository;

  const RegisterService({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<AuthSessionModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneE164,
    required String password,
  }) {
    final command = RegisterCommand(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim().toLowerCase(),
      phoneE164: phoneE164.trim(),
      password: password,
    );

    return _authRepository.register(
      command,
    );
  }
}