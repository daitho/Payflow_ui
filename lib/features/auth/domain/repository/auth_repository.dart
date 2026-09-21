import '../model/auth_session_model.dart';
import '../model/login_credentials.dart';
import '../model/register_command.dart';
import '../model/verification_challenge_model.dart';
import '../model/verification_channel.dart';

abstract interface class AuthRepository {
  Future<AuthSessionModel> login(LoginCredentials credentials);
  Future<VerificationChallengeModel> register(RegisterCommand command);

  Future<AuthSessionModel> confirmVerification({
    required String challengeId,
    required String code,
  });

  Future<VerificationChallengeModel> resendVerification({
    required String challengeId,
    required VerificationChannel channel,
  });

  Future<AuthSessionModel> refresh(String refreshToken);
}
