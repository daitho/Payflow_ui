enum VerificationErrorType {
  invalidCode,
  expired,
  tooManyAttempts,
  resendTooSoon,
  channelUnavailable,
  network,
  unexpected,
}

class VerificationException implements Exception {
  final VerificationErrorType type;

  const VerificationException(this.type);
}
