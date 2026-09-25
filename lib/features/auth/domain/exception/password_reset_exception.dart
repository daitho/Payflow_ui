enum PasswordResetErrorType {
  invalidCode,
  expiredCode,
  tooManyAttempts,
  resendTooSoon,
  channelUnavailable,
  invalidToken,
  expiredToken,
  weakPassword,
  passwordMismatch,
  passwordUnchanged,
  network,
  unexpected,
}

class PasswordResetException implements Exception {
  final PasswordResetErrorType type;

  const PasswordResetException(this.type);
}
