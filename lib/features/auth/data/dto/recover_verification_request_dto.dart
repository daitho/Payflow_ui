import '../../domain/model/verification_channel.dart';

class RecoverVerificationRequestDto {
  final String identifier;
  final String password;
  final VerificationChannel channel;

  const RecoverVerificationRequestDto({
    required this.identifier,
    required this.password,
    required this.channel,
  });

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
    'channel': channel.apiValue,
  };
}
