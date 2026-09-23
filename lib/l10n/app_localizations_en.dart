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

  @override
  String get transferHistoryTitle => 'Transactions';

  @override
  String get transferDetailTitle => 'Transfer details';

  @override
  String get transferNotFound => 'This transfer could not be found.';

  @override
  String get transferStatusCreated => 'Created';

  @override
  String get transferStatusPending => 'Pending';

  @override
  String get transferStatusProcessing => 'Processing';

  @override
  String get transferStatusCompleted => 'Completed';

  @override
  String get transferStatusFailed => 'Failed';

  @override
  String get transferStatusCancelled => 'Cancelled';

  @override
  String get transferStatusRefunded => 'Refunded';

  @override
  String get transferStatusUnknown => 'Unknown status';

  @override
  String get transferBeneficiary => 'Recipient';

  @override
  String get transferAllBeneficiaries => 'All recipients';

  @override
  String get transferStatusLabel => 'Status';

  @override
  String get transferAllStatuses => 'All statuses';

  @override
  String get transferResetFilters => 'Reset filters';

  @override
  String get transferCountLabel => 'Total transactions';

  @override
  String get transferSentTotalLabel => 'Total sent by currency';

  @override
  String get transferHistoryEmpty => 'No transfers match your search.';

  @override
  String get transferLoadMore => 'Load more';

  @override
  String get transferRecipientName => 'Name';

  @override
  String get transferCountry => 'Country';

  @override
  String get transferOperator => 'Operator';

  @override
  String get transferDestination => 'Destination';

  @override
  String get transferAmounts => 'Amounts';

  @override
  String get transferSent => 'Amount sent';

  @override
  String transferSentTo(String amount, String beneficiary) {
    return 'You sent $amount to $beneficiary';
  }

  @override
  String get transferFee => 'Fees';

  @override
  String get transferTotalCharged => 'Total charged';

  @override
  String get transferRate => 'Applied rate';

  @override
  String get transferReceived => 'Amount to receive';

  @override
  String get transferTracking => 'Transfer tracking';

  @override
  String get transferReference => 'Reference';

  @override
  String get transferCreatedAt => 'Created on';

  @override
  String get transferExport => 'Export';

  @override
  String get transferReceiptAction => 'View / export receipt';

  @override
  String get transferRepeatAction => 'Repeat transfer';

  @override
  String get transferProviderReference => 'Operator confirmation';

  @override
  String get transferTotalAmount => 'Total amount';

  @override
  String get transferTimelineUnavailable =>
      'Detailed tracking is unavailable for this transfer.';

  @override
  String get transferTrackingCompleted =>
      'The funds have been delivered to the recipient.';

  @override
  String get transferTrackingFailed =>
      'The transfer failed. The available tracking does not specify the debit or refund situation.';

  @override
  String get transferTrackingCancelled =>
      'The transfer is cancelled. The available tracking does not specify the debit or refund situation.';

  @override
  String get transferTrackingRefunded => 'The transfer is marked as refunded.';

  @override
  String get transferTrackingPending =>
      'The transfer is being processed. Receipt has not yet been confirmed.';

  @override
  String get transferYearLabel => 'Year';

  @override
  String get transferAllYears => 'All years';

  @override
  String get contactTitle => 'Beneficiaries';

  @override
  String get contactSearch => 'Enter a name to search…';

  @override
  String get contactAdd => 'Add a beneficiary';

  @override
  String get contactSection => 'YOUR BENEFICIARIES';

  @override
  String get contactNew => 'New Beneficiary';

  @override
  String get contactEdit => 'Edit beneficiary';

  @override
  String get contactInformation => 'Contact information';

  @override
  String get contactFullName => 'Full name';

  @override
  String get contactPhone => 'Phone number';

  @override
  String get contactPhoneConfirmation => 'Confirm phone number';

  @override
  String get contactPhoneMismatch => 'The two phone numbers do not match.';

  @override
  String get contactChooseDialCode => 'Choose country and calling code';

  @override
  String get contactCountry => 'Country';

  @override
  String get contactOperator => 'Operator';

  @override
  String get contactGender => 'Gender';

  @override
  String get contactMale => 'Male';

  @override
  String get contactFemale => 'Female';

  @override
  String get contactUnspecified => 'Not specified';

  @override
  String get contactSave => 'Save changes';

  @override
  String get contactEmpty => 'No beneficiaries found.';

  @override
  String get contactNoPhone => 'No phone number';

  @override
  String get contactChoose => 'Choose';

  @override
  String get contactRequired => 'Required field';

  @override
  String get contactNameTooLong => 'Maximum 120 characters';

  @override
  String get contactPhoneInvalid =>
      'Enter the number with its country code, e.g. +237…';

  @override
  String get contactNoOperators => 'No Mobile Money operators available.';

  @override
  String get contactNetworkError =>
      'Connection unavailable. Check your network.';

  @override
  String get contactSessionError =>
      'Your session has expired. Please sign in again.';

  @override
  String get contactInvalidError =>
      'Check the phone, country and operator. A contact with multiple destinations cannot change country here.';

  @override
  String get contactNotFoundError =>
      'This beneficiary or operator is no longer available.';

  @override
  String get contactServerError =>
      'Unable to complete this action. Please try again.';

  @override
  String get contactUnavailable =>
      'This destination cannot be edited in the Mobile Money form.';

  @override
  String get transferSendTitle => 'Send money';

  @override
  String get transferChooseBeneficiary => 'Choose a beneficiary';

  @override
  String get transferYouSend => 'You send';

  @override
  String get transferAmountReceived => 'Amount received';

  @override
  String get transferFundingLabel => 'Payment method';

  @override
  String get transferSuggestedAmounts => 'Suggested amounts';

  @override
  String get transferFundingCard => 'Bank card';

  @override
  String get transferFundingApplePay => 'Apple Pay';

  @override
  String get transferFundingGooglePay => 'Google Pay';

  @override
  String get transferFundingPaypal => 'PayPal';

  @override
  String get transferPaypalReturnTitle => 'Complete your PayPal payment';

  @override
  String get transferPaypalReturnMessage => 'Authorize the payment in PayPal, then return to PayFlow and verify it. The transfer will only be created after server confirmation.';

  @override
  String get transferPaypalVerify => 'Verify payment';

  @override
  String get transferPaypalLaunchError => 'Unable to open PayPal securely.';

  @override
  String get transferCurrentRate => 'Exchange rate';

  @override
  String get transferChooseForQuote =>
      'Choose a beneficiary to calculate the rate and fees.';

  @override
  String get transferContinue => 'Continue';

  @override
  String get transferReviewTitle => 'Review your transfer';

  @override
  String get transferTrustWarning =>
      'Do you know this person? Make sure you are sending money to someone you trust and that their details are correct.';

  @override
  String get transferConfirm => 'Confirm transfer';

  @override
  String get transferInvalidError =>
      'Check the beneficiary and the amount entered.';

  @override
  String get transferBeneficiaryUnavailable =>
      'This beneficiary or destination is no longer available.';

  @override
  String get transferConflictError =>
      'This transfer has already been confirmed or can no longer be used.';

  @override
  String get transferQuoteExpired =>
      'The rate has expired. A new quote will be calculated.';

  @override
  String get transferAmountBelowMinimumError =>
      'The amount is below the minimum allowed for this destination.';

  @override
  String get transferAmountAboveMaximumError =>
      'The amount exceeds the maximum allowed for this destination.';

  @override
  String get transferUnavailableError =>
      'This transfer is not available for this beneficiary or amount.';

  @override
  String get systemLanguage => 'Device language';

  @override
  String get spanish => 'Spanish';

  @override
  String get mandarin => 'Mandarin Chinese';

  @override
  String get hindi => 'Hindi';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get currentPasswordRequired => 'Please enter your current password';

  @override
  String get currentPasswordIncorrect => 'The current password is incorrect.';

  @override
  String get newPasswordRequired => 'Please enter a new password';

  @override
  String get newPasswordUnchanged =>
      'The new password must be different from the current password.';

  @override
  String get confirmNewPasswordRequired => 'Please confirm your new password';

  @override
  String get passwordChangeSessionInfo =>
      'For your security, all other devices will be signed out. This device will remain signed in.';

  @override
  String get changePasswordAction => 'Change password';

  @override
  String get passwordChangedTitle => 'Password changed';

  @override
  String get passwordChangedMessage =>
      'Your password has been changed. Your other devices have been signed out.';

  @override
  String get continueAction => 'Continue';

  @override
  String get passwordLoginUnavailable =>
      'This account uses an external sign-in provider and does not have a PayFlow password.';

  @override
  String get changePasswordNetworkError =>
      'Unable to change the password. Check your connection.';

  @override
  String get changePasswordServerError =>
      'The password service is temporarily unavailable.';

  @override
  String get changePasswordUnexpectedError =>
      'Unable to change the password right now.';
}
