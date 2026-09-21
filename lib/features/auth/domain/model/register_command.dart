import 'verification_channel.dart';

class RegisterCommand {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneE164;
  final String password;
  final VerificationChannel verificationChannel;

  const RegisterCommand({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneE164,
    required this.password,
    required this.verificationChannel,
  });
}
