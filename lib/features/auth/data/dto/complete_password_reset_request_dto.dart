class CompletePasswordResetRequestDto {
  final String resetToken;
  final String newPassword;
  final String passwordConfirmation;

  const CompletePasswordResetRequestDto({
    required this.resetToken,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'resetToken': resetToken,
    'newPassword': newPassword,
    'passwordConfirmation': passwordConfirmation,
  };
}
