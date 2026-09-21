abstract final class ApiEndpoints {
  static const String authRegister = '/api/v1/auth/register';
  static const String authVerificationConfirm =
      '/api/v1/auth/verification/confirm';
  static const String authVerificationResend =
      '/api/v1/auth/verification/resend';
  static const String authLogin = '/api/v1/auth/login';
  static const String authRefresh = '/api/v1/auth/refresh';
  static const String authLogout = '/api/v1/auth/logout';
  static const String authLogoutAll = '/api/v1/auth/logout-all';
  static const String authSessions = '/api/v1/auth/sessions';
  static const String authLogoutOthers = '/api/v1/auth/logout-others';
  static const String accountPassword = '/api/v1/account/password';
  static const String accountIdentifiers =
      '/api/v1/account/identifiers';
  static const String accountIdentifierVerificationConfirm =
      '/api/v1/account/identifiers/verification/confirm';

  static String accountIdentifierVerification(
    String channel,
  ) => '/api/v1/account/identifiers/$channel/verification';
  static const String home = '/api/v1/home';
}
