import '../../domain/model/password_reset_token_model.dart';

class PasswordResetTokenDto {
  final String resetToken;
  final DateTime expiresAt;

  const PasswordResetTokenDto({
    required this.resetToken,
    required this.expiresAt,
  });

  factory PasswordResetTokenDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return PasswordResetTokenDto(
      resetToken: json['resetToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  PasswordResetTokenModel toModel() {
    return PasswordResetTokenModel(
      resetToken: resetToken,
      expiresAt: expiresAt,
    );
  }
}
