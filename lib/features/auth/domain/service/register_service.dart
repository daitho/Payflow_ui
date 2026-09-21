import '../model/register_command.dart';
import '../model/verification_challenge_model.dart';
import '../model/verification_channel.dart';
import '../repository/auth_repository.dart';

class RegisterService {
  final AuthRepository _authRepository;

  const RegisterService({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<VerificationChallengeModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneE164,
    required String password,
  }) {
    return _authRepository.register(
      RegisterCommand(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim().toLowerCase(),
        phoneE164: phoneE164.trim(),
        password: password,
        verificationChannel: VerificationChannel.email,
      ),
    );
  }
}
