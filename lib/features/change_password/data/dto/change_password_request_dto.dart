class ChangePasswordRequestDto {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'currentPassword': currentPassword,
    'newPassword': newPassword,
  };
}
