import '../model/auth_session_model.dart';
import '../model/login_credentials.dart';
import '../model/register_command.dart';
import '../model/verification_challenge_model.dart';
import '../model/verification_channel.dart';
import '../model/identifier_verification_status_model.dart';

abstract interface class AuthRepository {
  Future<AuthSessionModel> login(LoginCredentials credentials);
  Future<VerificationChallengeModel> register(RegisterCommand command);

  Future<VerificationChallengeModel> recoverVerification({
    required String identifier,
    required String password,
    required VerificationChannel channel,
  });

  Future<AuthSessionModel> confirmVerification({
    required String challengeId,
    required String code,
  });

  Future<VerificationChallengeModel> resendVerification({
    required String challengeId,
    required VerificationChannel channel,
  });

  Future<IdentifierVerificationStatusModel> identifierVerificationStatus();

  Future<VerificationChallengeModel> startIdentifierVerification(
    VerificationChannel channel,
  );

  Future<IdentifierVerificationStatusModel> confirmIdentifierVerification({
    required String challengeId,
    required String code,
  });

  Future<AuthSessionModel> refresh(String refreshToken);
}
