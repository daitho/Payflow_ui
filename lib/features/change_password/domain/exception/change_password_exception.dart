enum ChangePasswordErrorType {
  invalidCurrentPassword,
  weakPassword,
  unchangedPassword,
  passwordLoginUnavailable,
  sessionExpired,
  network,
  server,
  unexpected,
}

class ChangePasswordException implements Exception {
  final ChangePasswordErrorType type;

  const ChangePasswordException(this.type);
}
