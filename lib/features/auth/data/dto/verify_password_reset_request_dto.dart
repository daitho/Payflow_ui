class VerifyPasswordResetRequestDto {
  final String challengeId;
  final String code;

  const VerifyPasswordResetRequestDto({
    required this.challengeId,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    'challengeId': challengeId,
    'code': code,
  };
}
