import '../../domain/model/verification_challenge_model.dart';
import '../../domain/model/verification_channel.dart';

class VerificationChallengeDto {
  final String challengeId;
  final String channel;
  final String maskedDestination;
  final DateTime expiresAt;
  final DateTime resendAvailableAt;

  const VerificationChallengeDto({
    required this.challengeId,
    required this.channel,
    required this.maskedDestination,
    required this.expiresAt,
    required this.resendAvailableAt,
  });

  factory VerificationChallengeDto.fromJson(Map<String, dynamic> json) {
    return VerificationChallengeDto(
      challengeId: json['challengeId'] as String,
      channel: json['channel'] as String,
      maskedDestination: json['maskedDestination'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      resendAvailableAt: DateTime.parse(json['resendAvailableAt'] as String),
    );
  }

  VerificationChallengeModel toModel() {
    return VerificationChallengeModel(
      challengeId: challengeId,
      channel: channel == 'EMAIL'
          ? VerificationChannel.email
          : VerificationChannel.phone,
      maskedDestination: maskedDestination,
      expiresAt: expiresAt,
      resendAvailableAt: resendAvailableAt,
    );
  }
}
