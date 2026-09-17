class RegisterRequestDto {
  final String lastName;
  final String? firstName;
  final String email;
  final String password;
  final String? phoneE164;
  final String? deviceId;
  final String? deviceName;

  const RegisterRequestDto({
    required this.lastName,
    this.firstName,
    required this.email,
    required this.password,
    this.phoneE164,
    this.deviceId,
    this.deviceName,
  });

  Map<String, dynamic> toJson() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'password': password,
      'phoneE164': phoneE164,
      'deviceId': deviceId,
      'deviceName': deviceName,
    };
  }
}