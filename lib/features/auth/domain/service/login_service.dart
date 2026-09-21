import '../model/auth_session_model.dart';
import '../model/login_credentials.dart';
import '../model/verification_challenge_model.dart';
import '../model/verification_channel.dart';
import '../repository/auth_repository.dart';

class LoginService {
  final AuthRepository _authRepository;

  const LoginService({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) {
    final rawIdentifier = email.trim();
    return _authRepository.login(
      LoginCredentials(
        identifier: rawIdentifier.contains('@')
            ? rawIdentifier.toLowerCase()
            : rawIdentifier.replaceAll(' ', ''),
        password: password,
      ),
    );
  }
  Future<VerificationChallengeModel> recoverVerification({
    required String identifier,
    required String password,
  }) {
    final String normalized = identifier.trim().contains('@')
        ? identifier.trim().toLowerCase()
        : identifier.replaceAll(' ', '');

    return _authRepository.recoverVerification(
      identifier: normalized,
      password: password,
      channel: normalized.contains('@')
          ? VerificationChannel.email
          : VerificationChannel.phone,
    );
  }
}
