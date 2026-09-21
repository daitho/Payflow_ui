class ResendVerificationRequestDto {
  final String challengeId;
  final String channel;

  const ResendVerificationRequestDto({
    required this.challengeId,
    required this.channel,
  });

  Map<String, dynamic> toJson() => {
    'challengeId': challengeId,
    'channel': channel,
  };
}
