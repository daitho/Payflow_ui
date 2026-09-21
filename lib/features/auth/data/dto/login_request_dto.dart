class LoginRequestDto {
  final String email;
  final String password;
  final String? deviceId;
  final String? deviceName;

  const LoginRequestDto({
    required this.email,
    required this.password,
    this.deviceId,
    this.deviceName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
      'deviceName': deviceName,
    };
  }
}
