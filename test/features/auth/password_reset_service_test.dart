import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/auth/domain/model/password_reset_token_model.dart';
import 'package:pay_flow_ui/features/auth/domain/model/verification_challenge_model.dart';
import 'package:pay_flow_ui/features/auth/domain/model/verification_channel.dart';
import 'package:pay_flow_ui/features/auth/domain/repository/password_reset_repository.dart';
import 'package:pay_flow_ui/features/auth/domain/service/password_reset_service.dart';

void main() {
  test('normalizes an email before requesting a reset', () async {
    final repository = _PasswordResetRepositoryFake();
    final service = PasswordResetService(repository: repository);

    await service.requestReset('  USER@Example.COM  ');

    expect(repository.requestedIdentifier, 'user@example.com');
  });

  test('normalizes an international phone number', () async {
    final repository = _PasswordResetRepositoryFake();
    final service = PasswordResetService(repository: repository);

    await service.requestReset('+33 (6) 12-34-56-78');

    expect(repository.requestedIdentifier, '+33612345678');
  });
}

class _PasswordResetRepositoryFake
    implements PasswordResetRepository {
  String? requestedIdentifier;

  @override
  Future<VerificationChallengeModel> requestReset(
    String identifier,
  ) async {
    requestedIdentifier = identifier;
    return VerificationChallengeModel(
      challengeId: 'challenge-id',
      channel: identifier.contains('@')
          ? VerificationChannel.email
          : VerificationChannel.phone,
      maskedDestination: '••••••',
      expiresAt: DateTime.now().add(
        const Duration(minutes: 10),
      ),
      resendAvailableAt: DateTime.now().add(
        const Duration(minutes: 1),
      ),
    );
  }

  @override
  Future<VerificationChallengeModel> resendCode({
    required String challengeId,
    required VerificationChannel channel,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<PasswordResetTokenModel> verifyCode({
    required String challengeId,
    required String code,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    throw UnimplementedError();
  }
}
