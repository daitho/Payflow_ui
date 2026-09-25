import '../model/password_reset_token_model.dart';
import '../model/verification_challenge_model.dart';
import '../model/verification_channel.dart';
import '../repository/password_reset_repository.dart';

class PasswordResetService {
  final PasswordResetRepository _repository;

  const PasswordResetService({
    required PasswordResetRepository repository,
  }) : _repository = repository;

  Future<VerificationChallengeModel> requestReset(
    String identifier,
  ) {
    return _repository.requestReset(
      _normalizeIdentifier(identifier),
    );
  }

  Future<VerificationChallengeModel> resendCode({
    required String challengeId,
    required VerificationChannel channel,
  }) {
    return _repository.resendCode(
      challengeId: challengeId,
      channel: channel,
    );
  }

  Future<PasswordResetTokenModel> verifyCode({
    required String challengeId,
    required String code,
  }) {
    return _repository.verifyCode(
      challengeId: challengeId,
      code: code,
    );
  }

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    return _repository.resetPassword(
      resetToken: resetToken,
      newPassword: newPassword,
      passwordConfirmation: passwordConfirmation,
    );
  }

  String _normalizeIdentifier(String identifier) {
    final value = identifier.trim();
    if (value.contains('@')) {
      return value.toLowerCase();
    }
    return value.replaceAll(RegExp(r'[\s()-]'), '');
  }
}
