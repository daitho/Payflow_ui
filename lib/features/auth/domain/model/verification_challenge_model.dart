import 'verification_channel.dart';

class VerificationChallengeModel {
  final String challengeId;
  final VerificationChannel channel;
  final String maskedDestination;
  final DateTime expiresAt;
  final DateTime resendAvailableAt;

  const VerificationChallengeModel({
    required this.challengeId,
    required this.channel,
    required this.maskedDestination,
    required this.expiresAt,
    required this.resendAvailableAt,
  });
}
