abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static const String exchangeRates = '/exchange-rates';

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
  static const String activeSessions = '/profile/security/sessions';
  static const String currentDevice = '/profile/security/device';
}
