class PasswordResetTokenModel {
  final String resetToken;
  final DateTime expiresAt;

  const PasswordResetTokenModel({
    required this.resetToken,
    required this.expiresAt,
  });
}
