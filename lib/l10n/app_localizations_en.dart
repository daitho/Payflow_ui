// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PayFlow';

  @override
  String get loginTagline => 'Fast, simple and secure\nmoney transfers';

  @override
  String get emailOrPhone => 'Email identified';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get or => 'or';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get emailOrPhoneRequired => 'Please enter your email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get frenchSelected => 'French selected';

  @override
  String get englishSelected => 'English selected';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get signingInError =>
      'Login error: please check your email or password...';

  @override
  String get forgotPasswordMessage => 'Password recovery';

  @override
  String socialLoginMessage(String provider) {
    return 'Signing in with $provider';
  }

  @override
  String get createAccount => 'Create my account';

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get firstNameRequired => 'Please enter your first name';

  @override
  String get lastNameRequired => 'Please enter your last name';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get phoneRequired => 'Please enter your phone number';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get acceptTermsPrefix => 'I accept the';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get and => 'and the';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsRequired => 'You must accept the terms to continue';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get creatingAccount => 'Creating your account...';

  @override
  String get passwordRequirementsTitle => 'Password must contain:';

  @override
  String get passwordMinLength => 'At least 12 characters';

  @override
  String get passwordUppercase => 'One uppercase letter';

  @override
  String get passwordLowercase => 'One lowercase letter';

  @override
  String get passwordDigit => 'One number';

  @override
  String get passwordSpecial => 'One special character';

  @override
  String get passwordInvalid =>
      'Password does not meet the security requirements';

  @override
  String get selectCountry => 'Select a country';

  @override
  String get startupConnectionError =>
      'Unable to connect to PayFlow. Check your connection and try again.';

  @override
  String get retry => 'Try again';

  @override
  String get invalidCredentials => 'Incorrect email or password.';

  @override
  String get loginNetworkError =>
      'Unable to connect to PayFlow. Check your internet connection.';

  @override
  String get loginTimeoutError =>
      'PayFlow is taking too long to respond. Please try again.';

  @override
  String get loginServerError =>
      'PayFlow is temporarily unavailable. Please try again shortly.';

  @override
  String get loginUnexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get profile => 'Profile';

  @override
  String get profileIdCopied => 'ID copied to clipboard';

  @override
  String get verified => 'Verified';

  @override
  String get notVerified => 'Not verified';

  @override
  String get myAccount => 'My account';

  @override
  String get accountInformation => 'Account information';

  @override
  String get accountInformationSubtitle => 'Manage your personal information';

  @override
  String get verificationAndLimits => 'Verification and limits';

  @override
  String get verificationAndLimitsSubtitle =>
      'View your verification level and limits';

  @override
  String get security => 'Security';

  @override
  String get securityAndPrivacy => 'Security and privacy';

  @override
  String get securityAndPrivacySubtitle => 'Password, biometrics and sessions';

  @override
  String get preferences => 'Preferences';

  @override
  String get notificationPreferences => 'Notification preferences';

  @override
  String get notificationPreferencesSubtitle =>
      'Manage your alerts and messages';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose the app language';

  @override
  String get help => 'Help';

  @override
  String get helpAndSupport => 'Help and support';

  @override
  String get helpAndSupportSubtitle => 'Get help with PayFlow';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'Terms, privacy and PayFlow information';

  @override
  String get signOut => 'Sign out';

  @override
  String get authentication => 'Authentication';

  @override
  String get biometrics => 'Biometrics';

  @override
  String get biometricsSubtitle => 'Face ID, Touch ID or fingerprint';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordSubtitle => 'Change your account password';

  @override
  String get sessionsAndDevices => 'Sessions and devices';

  @override
  String get thisDeviceSubtitle => 'The PayFlow session currently in use';

  @override
  String get activeSessions => 'Active sessions';

  @override
  String get activeSessionsSubtitle => 'View devices connected to your account';

  @override
  String get disconnectOtherDevices => 'Sign out other devices';

  @override
  String get disconnectOtherDevicesSubtitle => 'Revoke all other sessions';

  @override
  String get biometricPrivacyInfo =>
      'Your biometric data stays on your device. PayFlow never receives your face or fingerprint.';

  @override
  String get checkingBiometrics => 'Checking biometric authentication...';

  @override
  String get biometricsUnavailable =>
      'No biometric authentication is configured on this device.';

  @override
  String get enableBiometricsReason =>
      'Authenticate to enable PayFlow biometrics.';

  @override
  String get disableBiometricsReason =>
      'Authenticate to disable PayFlow biometrics.';

  @override
  String get biometricAuthenticationFailed =>
      'Biometric authentication was not completed.';

  @override
  String get biometricTechnicalError =>
      'Biometric settings cannot be changed right now.';

  @override
  String get unlockPayFlowBiometricReason => 'Authenticate to access PayFlow.';

  @override
  String get biometricUnlockFailed =>
      'Biometric authentication was not completed.';

  @override
  String get biometricUnlockUnavailable =>
      'Biometrics enabled for PayFlow are no longer available on this device.';

  @override
  String get retryBiometric => 'Try again';

  @override
  String get activeSessionsTitle => 'Active sessions';

  @override
  String get noActiveSessions => 'No active sessions.';

  @override
  String get thisDevice => 'This device';

  @override
  String get currentSession => 'CURRENT';

  @override
  String get lastActivity => 'Last activity';

  @override
  String get sessionCreated => 'Signed in';

  @override
  String get sessionExpires => 'Expires';

  @override
  String get ipAddress => 'IP address';

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get cancel => 'Cancel';

  @override
  String get revokeSessionTitle => 'Disconnect this device?';

  @override
  String revokeSessionMessage(String deviceName) {
    return 'The session on $deviceName will be revoked and this device will need to sign in again.';
  }

  @override
  String get sessionRevokedSuccess => 'The device has been disconnected.';

  @override
  String get activeSessionsNetworkError =>
      'Unable to load sessions. Check your connection.';

  @override
  String get activeSessionsUnauthorized =>
      'Your session is no longer valid. Please sign in again.';

  @override
  String get activeSessionsServerError =>
      'The service is temporarily unavailable.';

  @override
  String get activeSessionsUnexpectedError =>
      'Unable to manage sessions right now.';

  @override
  String get disconnectOtherDevicesConfirmTitle => 'Disconnect other devices?';

  @override
  String get disconnectOtherDevicesConfirmMessage =>
      'All your other PayFlow sessions will be disconnected. This device will stay signed in.';

  @override
  String get disconnectOtherDevicesSuccess =>
      'Other devices have been disconnected.';

  @override
  String get currentDeviceTitle => 'This device';

  @override
  String get currentDeviceLoadError =>
      'Unable to load information for this device.';

  @override
  String get deviceStatus => 'Status';

  @override
  String get deviceActive => 'Active';

  @override
  String get deviceIdentifier => 'Device identifier';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutCurrentDevice => 'Sign out of this device';

  @override
  String get logoutCurrentDeviceSubtitle =>
      'Your PayFlow session will be closed on this device.';

  @override
  String get logoutCurrentDeviceConfirmTitle => 'Sign out?';

  @override
  String get logoutCurrentDeviceConfirmMessage =>
      'You will need to sign in again to access PayFlow on this device.';

  @override
  String get logoutCurrentDeviceNetworkError =>
      'Unable to sign out. Check your connection and try again.';

  @override
  String get logoutCurrentDeviceServerError =>
      'The sign-out service is temporarily unavailable.';

  @override
  String get logoutCurrentDeviceUnexpectedError =>
      'Unable to sign out right now.';

  @override
  String get homeWelcome => 'Welcome,';

  @override
  String get homeLastRateUsed => 'Last rate used';

  @override
  String get homeAvailableRate => 'Available rate';

  @override
  String get homeExchangeRate => 'Exchange rate';

  @override
  String get homeNoRateAvailable => 'No exchange rate currently available';

  @override
  String get homeMainCurrency => 'Main currency';

  @override
  String get homeRecentBeneficiaries => 'Send money again to';

  @override
  String get homeSeeMore => 'More';

  @override
  String get homeRecentTransactions => 'Transaction history';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeNewTransfer => 'New transfer';

  @override
  String get homeNoRecentBeneficiaries => 'No recent beneficiaries.';

  @override
  String get homeNoRecentTransactions => 'No recent transactions.';

  @override
  String get homeLoadErrorTitle => 'Unable to load home';

  @override
  String get homeRetry => 'Retry';

  @override
  String get homeNetworkError =>
      'Check your Internet connection and try again.';

  @override
  String get homeTimeoutError =>
      'The server is taking too long to respond. Try again.';

  @override
  String get homeServerError =>
      'A server error occurred. Try again in a few moments.';

  @override
  String get homeSessionExpiredError => 'Your session has expired.';

  @override
  String get homeInvalidResponseError => 'The received data is invalid.';

  @override
  String get homeUnexpectedError => 'An unexpected error occurred.';

  @override
  String get homeStatusCreated => 'Created';

  @override
  String get homeStatusPending => 'Pending';

  @override
  String get homeStatusProcessing => 'Processing';

  @override
  String get homeStatusCompleted => 'Completed';

  @override
  String get homeStatusFailed => 'Failed';

  @override
  String get homeStatusCancelled => 'Cancelled';

  @override
  String get homeStatusRefunded => 'Refunded';

  @override
  String get homeTab => 'Home';

  @override
  String get transfersTab => 'Transfers';

  @override
  String get contactsTab => 'Contacts';

  @override
  String get profileTab => 'Profile';

  @override
  String get referralTab => 'Refer';

  @override
  String get transferAction => 'Transfer';

  @override
  String get homeSelectBeneficiaryHint =>
      'Select a beneficiary below or start a transfer.';

  @override
  String get homeSelectedBeneficiary => 'Selected beneficiary';

  @override
  String get homeViewMoreTransactions => 'See more';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get homeExchangeRateSubtitle => 'Exchange Rate';

  @override
  String get homeBeneficiaryLabel => 'BENEFICIARY';

  @override
  String get exchangeRatesTitle => 'Exchange rates';

  @override
  String get exchangeRatesSearchHint => 'Search by country or currency';

  @override
  String get exchangeRatesEmpty => 'No exchange rates are currently available.';

  @override
  String get exchangeRatesNoSearchResult =>
      'No exchange rate matches your search.';

  @override
  String get exchangeRatesLoadError => 'Unable to load exchange rates.';

  @override
  String get exchangeRatesRefreshError => 'Unable to refresh exchange rates.';

  @override
  String get exchangeRatesRetry => 'Try again';

  @override
  String exchangeRateCorridor(String sourceCountry, String destinationCountry) {
    return '$sourceCountry → $destinationCountry';
  }

  @override
  String exchangeRateEquation(
    String sourceCurrency,
    String rate,
    String targetCurrency,
  ) {
    return '1 $sourceCurrency = $rate $targetCurrency';
  }
}
