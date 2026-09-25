import '../model/password_reset_token_model.dart';
import '../model/verification_challenge_model.dart';
import '../model/verification_channel.dart';

abstract interface class PasswordResetRepository {
  Future<VerificationChallengeModel> requestReset(String identifier);

  Future<VerificationChallengeModel> resendCode({
    required String challengeId,
    required VerificationChannel channel,
  });

  Future<PasswordResetTokenModel> verifyCode({
    required String challengeId,
    required String code,
  });

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String passwordConfirmation,
  });
}
