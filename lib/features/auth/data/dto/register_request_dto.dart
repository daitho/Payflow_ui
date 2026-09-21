class RegisterRequestDto {
  final String lastName;
  final String? firstName;
  final String email;
  final String password;
  final String phoneE164;
  final String verificationChannel;
  final String? deviceId;
  final String? deviceName;

  const RegisterRequestDto({
    required this.lastName,
    this.firstName,
    required this.email,
    required this.password,
    required this.phoneE164,
    required this.verificationChannel,
    this.deviceId,
    this.deviceName,
  });

  Map<String, dynamic> toJson() => {
    'lastName': lastName,
    'firstName': firstName,
    'email': email,
    'password': password,
    'phoneE164': phoneE164,
    'verificationChannel': verificationChannel,
    'deviceId': deviceId,
    'deviceName': deviceName,
  };
}
