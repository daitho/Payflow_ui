class LoginRequestDto {
  final String identifier;
  final String password;
  final String? deviceId;
  final String? deviceName;

  const LoginRequestDto({
    required this.identifier,
    required this.password,
    this.deviceId,
    this.deviceName,
  });

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
    'deviceId': deviceId,
    'deviceName': deviceName,
  };
}
