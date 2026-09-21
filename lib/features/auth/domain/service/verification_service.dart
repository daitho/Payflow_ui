import '../model/auth_session_model.dart';
import '../model/verification_challenge_model.dart';
import '../model/verification_channel.dart';
import '../repository/auth_repository.dart';

class VerificationService {
  final AuthRepository _authRepository;

  const VerificationService({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Future<AuthSessionModel> confirm({
    required String challengeId,
    required String code,
  }) {
    return _authRepository.confirmVerification(
      challengeId: challengeId,
      code: code,
    );
  }

  Future<VerificationChallengeModel> resend({
    required String challengeId,
    required VerificationChannel channel,
  }) {
    return _authRepository.resendVerification(
      challengeId: challengeId,
      channel: channel,
    );
  }
}
