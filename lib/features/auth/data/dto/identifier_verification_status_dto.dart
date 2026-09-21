import '../../domain/model/identifier_verification_status_model.dart';

class IdentifierVerificationStatusDto {
  final bool emailVerified;
  final bool phoneVerified;

  const IdentifierVerificationStatusDto({
    required this.emailVerified,
    required this.phoneVerified,
  });

  factory IdentifierVerificationStatusDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return IdentifierVerificationStatusDto(
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
    );
  }

  IdentifierVerificationStatusModel toModel() {
    return IdentifierVerificationStatusModel(
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
    );
  }
}
