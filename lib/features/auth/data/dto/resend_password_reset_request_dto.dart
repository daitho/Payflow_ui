class ResendPasswordResetRequestDto {
  final String challengeId;
  final String channel;

  const ResendPasswordResetRequestDto({
    required this.challengeId,
    required this.channel,
  });

  Map<String, dynamic> toJson() => {
    'challengeId': challengeId,
    'channel': channel,
  };
}
