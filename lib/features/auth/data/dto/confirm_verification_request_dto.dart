class ConfirmVerificationRequestDto {
  final String challengeId;
  final String code;
  final String? deviceId;
  final String? deviceName;

  const ConfirmVerificationRequestDto({
    required this.challengeId,
    required this.code,
    this.deviceId,
    this.deviceName,
  });

  Map<String, dynamic> toJson() => {
    'challengeId': challengeId,
    'code': code,
    'deviceId': deviceId,
    'deviceName': deviceName,
  };
}
