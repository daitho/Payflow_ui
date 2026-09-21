abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyRegistration = '/register/verify';
  static const String home = '/home';
  static const beneficiaryCreate = '/beneficiaries/new';
  static const beneficiaryEdit = '/beneficiaries/:beneficiaryId/edit';
  static String beneficiaryEditPath(String id) =>
      '/beneficiaries/${Uri.encodeComponent(id)}/edit';

  static const String exchangeRates = '/exchange-rates';

  static const String transfer = '/transfer';
  static const String transferBeneficiaryPicker = '/transfer/beneficiary';

  // =========================================================
  // TRANSACTIONS
  // =========================================================
  static const String transactionHistory = '/transactions/history';
  static const String transactionDetail = '/transactions/:transactionId';

  static String transactionDetailPath(String transactionId) {
    return '/transactions/${Uri.encodeComponent(transactionId)}';
  }

  // =========================================================
  // PROFILE
  // =========================================================
  static const String profileSecurity = '/profile/security';
  static const String changePassword = '/profile/security/password';
  static const String authenticationMethods =
      '/profile/security/authentication-methods';
  static const String verifyIdentifier =
      '/profile/security/authentication-methods/verify';
  static const String activeSessions = '/profile/security/sessions';
  static const String currentDevice = '/profile/security/device';
}
