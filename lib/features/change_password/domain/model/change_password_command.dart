class ChangePasswordCommand {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordCommand({
    required this.currentPassword,
    required this.newPassword,
  });
}
