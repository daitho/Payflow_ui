abstract final class ApiErrorCodes {
  static const String invalidCredentials = 'AUTH_002';
  static const String accountVerificationRequired = 'AUTH_011';
  static const String identifierNotVerified = 'AUTH_012';

  static const String verificationNotFound = 'VERIFY_001';
  static const String invalidVerificationCode = 'VERIFY_002';
  static const String verificationExpired = 'VERIFY_003';
  static const String verificationAttemptsExceeded = 'VERIFY_004';
  static const String verificationResendTooSoon = 'VERIFY_005';
  static const String verificationChannelUnavailable = 'VERIFY_006';
}
