import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('fr'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PayFlow'**
  String get appName;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Fast, simple and secure\nmoney transfers'**
  String get loginTagline;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email identified'**
  String get emailOrPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @emailOrPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailOrPhoneRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @frenchSelected.
  ///
  /// In en, this message translates to:
  /// **'French selected'**
  String get frenchSelected;

  /// No description provided for @englishSelected.
  ///
  /// In en, this message translates to:
  /// **'English selected'**
  String get englishSelected;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @signingInError.
  ///
  /// In en, this message translates to:
  /// **'Login error: please check your email or password...'**
  String get signingInError;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Password recovery'**
  String get forgotPasswordMessage;

  /// Message displayed when a user chooses social authentication
  ///
  /// In en, this message translates to:
  /// **'Signing in with {provider}'**
  String socialLoginMessage(String provider);

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get createAccount;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get lastNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @acceptTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I accept the'**
  String get acceptTermsPrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and the'**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms to continue'**
  String get termsRequired;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating your account...'**
  String get creatingAccount;

  /// No description provided for @passwordRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Password must contain:'**
  String get passwordRequirementsTitle;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 12 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordLowercase.
  ///
  /// In en, this message translates to:
  /// **'One lowercase letter'**
  String get passwordLowercase;

  /// No description provided for @passwordDigit.
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get passwordDigit;

  /// No description provided for @passwordSpecial.
  ///
  /// In en, this message translates to:
  /// **'One special character'**
  String get passwordSpecial;

  /// No description provided for @passwordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet the security requirements'**
  String get passwordInvalid;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select a country'**
  String get selectCountry;

  /// No description provided for @startupConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to PayFlow. Check your connection and try again.'**
  String get startupConnectionError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @loginNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to PayFlow. Check your internet connection.'**
  String get loginNetworkError;

  /// No description provided for @loginTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'PayFlow is taking too long to respond. Please try again.'**
  String get loginTimeoutError;

  /// No description provided for @loginServerError.
  ///
  /// In en, this message translates to:
  /// **'PayFlow is temporarily unavailable. Please try again shortly.'**
  String get loginServerError;

  /// No description provided for @loginUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get loginUnexpectedError;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileIdCopied.
  ///
  /// In en, this message translates to:
  /// **'ID copied to clipboard'**
  String get profileIdCopied;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccount;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get accountInformation;

  /// No description provided for @accountInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your personal information'**
  String get accountInformationSubtitle;

  /// No description provided for @verificationAndLimits.
  ///
  /// In en, this message translates to:
  /// **'Verification and limits'**
  String get verificationAndLimits;

  /// No description provided for @verificationAndLimitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your verification level and limits'**
  String get verificationAndLimitsSubtitle;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securityAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security and privacy'**
  String get securityAndPrivacy;

  /// No description provided for @securityAndPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password, biometrics and sessions'**
  String get securityAndPrivacySubtitle;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationPreferences;

  /// No description provided for @notificationPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your alerts and messages'**
  String get notificationPreferencesSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language'**
  String get languageSubtitle;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get helpAndSupport;

  /// No description provided for @helpAndSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help with PayFlow'**
  String get helpAndSupportSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms, privacy and PayFlow information'**
  String get aboutSubtitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @biometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometrics;

  /// No description provided for @biometricsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Face ID, Touch ID or fingerprint'**
  String get biometricsSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change your account password'**
  String get changePasswordSubtitle;

  /// No description provided for @sessionsAndDevices.
  ///
  /// In en, this message translates to:
  /// **'Sessions and devices'**
  String get sessionsAndDevices;

  /// No description provided for @thisDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The PayFlow session currently in use'**
  String get thisDeviceSubtitle;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get activeSessions;

  /// No description provided for @activeSessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View devices connected to your account'**
  String get activeSessionsSubtitle;

  /// No description provided for @disconnectOtherDevices.
  ///
  /// In en, this message translates to:
  /// **'Sign out other devices'**
  String get disconnectOtherDevices;

  /// No description provided for @disconnectOtherDevicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke all other sessions'**
  String get disconnectOtherDevicesSubtitle;

  /// No description provided for @biometricPrivacyInfo.
  ///
  /// In en, this message translates to:
  /// **'Your biometric data stays on your device. PayFlow never receives your face or fingerprint.'**
  String get biometricPrivacyInfo;

  /// No description provided for @checkingBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Checking biometric authentication...'**
  String get checkingBiometrics;

  /// No description provided for @biometricsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No biometric authentication is configured on this device.'**
  String get biometricsUnavailable;

  /// No description provided for @enableBiometricsReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to enable PayFlow biometrics.'**
  String get enableBiometricsReason;

  /// No description provided for @disableBiometricsReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to disable PayFlow biometrics.'**
  String get disableBiometricsReason;

  /// No description provided for @biometricAuthenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication was not completed.'**
  String get biometricAuthenticationFailed;

  /// No description provided for @biometricTechnicalError.
  ///
  /// In en, this message translates to:
  /// **'Biometric settings cannot be changed right now.'**
  String get biometricTechnicalError;

  /// No description provided for @unlockPayFlowBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to access PayFlow.'**
  String get unlockPayFlowBiometricReason;

  /// No description provided for @biometricUnlockFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication was not completed.'**
  String get biometricUnlockFailed;

  /// No description provided for @biometricUnlockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics enabled for PayFlow are no longer available on this device.'**
  String get biometricUnlockUnavailable;

  /// No description provided for @retryBiometric.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryBiometric;

  /// No description provided for @activeSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get activeSessionsTitle;

  /// No description provided for @noActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions.'**
  String get noActiveSessions;

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get thisDevice;

  /// No description provided for @currentSession.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get currentSession;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get lastActivity;

  /// No description provided for @sessionCreated.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get sessionCreated;

  /// No description provided for @sessionExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get sessionExpires;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP address'**
  String get ipAddress;

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @revokeSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect this device?'**
  String get revokeSessionTitle;

  /// No description provided for @revokeSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'The session on {deviceName} will be revoked and this device will need to sign in again.'**
  String revokeSessionMessage(String deviceName);

  /// No description provided for @sessionRevokedSuccess.
  ///
  /// In en, this message translates to:
  /// **'The device has been disconnected.'**
  String get sessionRevokedSuccess;

  /// No description provided for @activeSessionsNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load sessions. Check your connection.'**
  String get activeSessionsNetworkError;

  /// No description provided for @activeSessionsUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session is no longer valid. Please sign in again.'**
  String get activeSessionsUnauthorized;

  /// No description provided for @activeSessionsServerError.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable.'**
  String get activeSessionsServerError;

  /// No description provided for @activeSessionsUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unable to manage sessions right now.'**
  String get activeSessionsUnexpectedError;

  /// No description provided for @disconnectOtherDevicesConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect other devices?'**
  String get disconnectOtherDevicesConfirmTitle;

  /// No description provided for @disconnectOtherDevicesConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'All your other PayFlow sessions will be disconnected. This device will stay signed in.'**
  String get disconnectOtherDevicesConfirmMessage;

  /// No description provided for @disconnectOtherDevicesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Other devices have been disconnected.'**
  String get disconnectOtherDevicesSuccess;

  /// No description provided for @currentDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get currentDeviceTitle;

  /// No description provided for @currentDeviceLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load information for this device.'**
  String get currentDeviceLoadError;

  /// No description provided for @deviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get deviceStatus;

  /// No description provided for @deviceActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get deviceActive;

  /// No description provided for @deviceIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Device identifier'**
  String get deviceIdentifier;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @logoutCurrentDevice.
  ///
  /// In en, this message translates to:
  /// **'Sign out of this device'**
  String get logoutCurrentDevice;

  /// No description provided for @logoutCurrentDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your PayFlow session will be closed on this device.'**
  String get logoutCurrentDeviceSubtitle;

  /// No description provided for @logoutCurrentDeviceConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get logoutCurrentDeviceConfirmTitle;

  /// No description provided for @logoutCurrentDeviceConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access PayFlow on this device.'**
  String get logoutCurrentDeviceConfirmMessage;

  /// No description provided for @logoutCurrentDeviceNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign out. Check your connection and try again.'**
  String get logoutCurrentDeviceNetworkError;

  /// No description provided for @logoutCurrentDeviceServerError.
  ///
  /// In en, this message translates to:
  /// **'The sign-out service is temporarily unavailable.'**
  String get logoutCurrentDeviceServerError;

  /// No description provided for @logoutCurrentDeviceUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign out right now.'**
  String get logoutCurrentDeviceUnexpectedError;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get homeWelcome;

  /// No description provided for @homeLastRateUsed.
  ///
  /// In en, this message translates to:
  /// **'Last rate used'**
  String get homeLastRateUsed;

  /// No description provided for @homeAvailableRate.
  ///
  /// In en, this message translates to:
  /// **'Available rate'**
  String get homeAvailableRate;

  /// No description provided for @homeExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate'**
  String get homeExchangeRate;

  /// No description provided for @homeNoRateAvailable.
  ///
  /// In en, this message translates to:
  /// **'No exchange rate currently available'**
  String get homeNoRateAvailable;

  /// No description provided for @homeMainCurrency.
  ///
  /// In en, this message translates to:
  /// **'Main currency'**
  String get homeMainCurrency;

  /// No description provided for @homeRecentBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'Send money again to'**
  String get homeRecentBeneficiaries;

  /// No description provided for @homeSeeMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get homeSeeMore;

  /// No description provided for @homeRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get homeRecentTransactions;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @homeNewTransfer.
  ///
  /// In en, this message translates to:
  /// **'New transfer'**
  String get homeNewTransfer;

  /// No description provided for @homeNoRecentBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'No recent beneficiaries.'**
  String get homeNoRecentBeneficiaries;

  /// No description provided for @homeNoRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions.'**
  String get homeNoRecentTransactions;

  /// No description provided for @homeLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load home'**
  String get homeLoadErrorTitle;

  /// No description provided for @homeRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get homeRetry;

  /// No description provided for @homeNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Check your Internet connection and try again.'**
  String get homeNetworkError;

  /// No description provided for @homeTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long to respond. Try again.'**
  String get homeTimeoutError;

  /// No description provided for @homeServerError.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Try again in a few moments.'**
  String get homeServerError;

  /// No description provided for @homeSessionExpiredError.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired.'**
  String get homeSessionExpiredError;

  /// No description provided for @homeInvalidResponseError.
  ///
  /// In en, this message translates to:
  /// **'The received data is invalid.'**
  String get homeInvalidResponseError;

  /// No description provided for @homeUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get homeUnexpectedError;

  /// No description provided for @homeStatusCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get homeStatusCreated;

  /// No description provided for @homeStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get homeStatusPending;

  /// No description provided for @homeStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get homeStatusProcessing;

  /// No description provided for @homeStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeStatusCompleted;

  /// No description provided for @homeStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get homeStatusFailed;

  /// No description provided for @homeStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get homeStatusCancelled;

  /// No description provided for @homeStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get homeStatusRefunded;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @transfersTab.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfersTab;

  /// No description provided for @contactsTab.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @referralTab.
  ///
  /// In en, this message translates to:
  /// **'Refer'**
  String get referralTab;

  /// No description provided for @transferAction.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferAction;

  /// No description provided for @homeSelectBeneficiaryHint.
  ///
  /// In en, this message translates to:
  /// **'Select a beneficiary below or start a transfer.'**
  String get homeSelectBeneficiaryHint;

  /// No description provided for @homeSelectedBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Selected beneficiary'**
  String get homeSelectedBeneficiary;

  /// No description provided for @homeViewMoreTransactions.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get homeViewMoreTransactions;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @homeExchangeRateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get homeExchangeRateSubtitle;

  /// No description provided for @homeBeneficiaryLabel.
  ///
  /// In en, this message translates to:
  /// **'BENEFICIARY'**
  String get homeBeneficiaryLabel;

  /// No description provided for @exchangeRatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get exchangeRatesTitle;

  /// No description provided for @exchangeRatesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by country or currency'**
  String get exchangeRatesSearchHint;

  /// No description provided for @exchangeRatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exchange rates are currently available.'**
  String get exchangeRatesEmpty;

  /// No description provided for @exchangeRatesNoSearchResult.
  ///
  /// In en, this message translates to:
  /// **'No exchange rate matches your search.'**
  String get exchangeRatesNoSearchResult;

  /// No description provided for @exchangeRatesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load exchange rates.'**
  String get exchangeRatesLoadError;

  /// No description provided for @exchangeRatesRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh exchange rates.'**
  String get exchangeRatesRefreshError;

  /// No description provided for @exchangeRatesRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get exchangeRatesRetry;

  /// No description provided for @exchangeRateCorridor.
  ///
  /// In en, this message translates to:
  /// **'{sourceCountry} → {destinationCountry}'**
  String exchangeRateCorridor(String sourceCountry, String destinationCountry);

  /// No description provided for @exchangeRateEquation.
  ///
  /// In en, this message translates to:
  /// **'1 {sourceCurrency} = {rate} {targetCurrency}'**
  String exchangeRateEquation(
    String sourceCurrency,
    String rate,
    String targetCurrency,
  );

  /// No description provided for @transferHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transferHistoryTitle;

  /// No description provided for @transferDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer details'**
  String get transferDetailTitle;

  /// No description provided for @transferNotFound.
  ///
  /// In en, this message translates to:
  /// **'This transfer could not be found.'**
  String get transferNotFound;

  /// No description provided for @transferStatusCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get transferStatusCreated;

  /// No description provided for @transferStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get transferStatusPending;

  /// No description provided for @transferStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get transferStatusProcessing;

  /// No description provided for @transferStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get transferStatusCompleted;

  /// No description provided for @transferStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get transferStatusFailed;

  /// No description provided for @transferStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get transferStatusCancelled;

  /// No description provided for @transferStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get transferStatusRefunded;

  /// No description provided for @transferStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get transferStatusUnknown;

  /// No description provided for @transferBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get transferBeneficiary;

  /// No description provided for @transferAllBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'All recipients'**
  String get transferAllBeneficiaries;

  /// No description provided for @transferStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get transferStatusLabel;

  /// No description provided for @transferAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get transferAllStatuses;

  /// No description provided for @transferResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get transferResetFilters;

  /// No description provided for @transferCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total transactions'**
  String get transferCountLabel;

  /// No description provided for @transferSentTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total sent by currency'**
  String get transferSentTotalLabel;

  /// No description provided for @transferHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transfers match your search.'**
  String get transferHistoryEmpty;

  /// No description provided for @transferLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get transferLoadMore;

  /// No description provided for @transferRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get transferRecipientName;

  /// No description provided for @transferCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get transferCountry;

  /// No description provided for @transferOperator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get transferOperator;

  /// No description provided for @transferDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get transferDestination;

  /// No description provided for @transferAmounts.
  ///
  /// In en, this message translates to:
  /// **'Amounts'**
  String get transferAmounts;

  /// No description provided for @transferSent.
  ///
  /// In en, this message translates to:
  /// **'Amount sent'**
  String get transferSent;

  /// No description provided for @transferSentTo.
  ///
  /// In en, this message translates to:
  /// **'You sent {amount} to {beneficiary}'**
  String transferSentTo(String amount, String beneficiary);

  /// No description provided for @transferFee.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get transferFee;

  /// No description provided for @transferTotalCharged.
  ///
  /// In en, this message translates to:
  /// **'Total charged'**
  String get transferTotalCharged;

  /// No description provided for @transferRate.
  ///
  /// In en, this message translates to:
  /// **'Applied rate'**
  String get transferRate;

  /// No description provided for @transferReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount to receive'**
  String get transferReceived;

  /// No description provided for @transferTracking.
  ///
  /// In en, this message translates to:
  /// **'Transfer tracking'**
  String get transferTracking;

  /// No description provided for @transferReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get transferReference;

  /// No description provided for @transferCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get transferCreatedAt;

  /// No description provided for @transferExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get transferExport;

  /// No description provided for @transferReceiptAction.
  ///
  /// In en, this message translates to:
  /// **'View / export receipt'**
  String get transferReceiptAction;

  /// No description provided for @transferRepeatAction.
  ///
  /// In en, this message translates to:
  /// **'Repeat transfer'**
  String get transferRepeatAction;

  /// No description provided for @transferProviderReference.
  ///
  /// In en, this message translates to:
  /// **'Operator confirmation'**
  String get transferProviderReference;

  /// No description provided for @transferTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get transferTotalAmount;

  /// No description provided for @transferTimelineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Detailed tracking is unavailable for this transfer.'**
  String get transferTimelineUnavailable;

  /// No description provided for @transferTrackingCompleted.
  ///
  /// In en, this message translates to:
  /// **'The funds have been delivered to the recipient.'**
  String get transferTrackingCompleted;

  /// No description provided for @transferTrackingFailed.
  ///
  /// In en, this message translates to:
  /// **'The transfer failed. The available tracking does not specify the debit or refund situation.'**
  String get transferTrackingFailed;

  /// No description provided for @transferTrackingCancelled.
  ///
  /// In en, this message translates to:
  /// **'The transfer is cancelled. The available tracking does not specify the debit or refund situation.'**
  String get transferTrackingCancelled;

  /// No description provided for @transferTrackingRefunded.
  ///
  /// In en, this message translates to:
  /// **'The transfer is marked as refunded.'**
  String get transferTrackingRefunded;

  /// No description provided for @transferTrackingPending.
  ///
  /// In en, this message translates to:
  /// **'The transfer is being processed. Receipt has not yet been confirmed.'**
  String get transferTrackingPending;

  /// No description provided for @transferYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get transferYearLabel;

  /// No description provided for @transferAllYears.
  ///
  /// In en, this message translates to:
  /// **'All years'**
  String get transferAllYears;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Beneficiaries'**
  String get contactTitle;

  /// No description provided for @contactSearch.
  ///
  /// In en, this message translates to:
  /// **'Enter a name to search…'**
  String get contactSearch;

  /// No description provided for @contactAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a beneficiary'**
  String get contactAdd;

  /// No description provided for @contactSection.
  ///
  /// In en, this message translates to:
  /// **'YOUR BENEFICIARIES'**
  String get contactSection;

  /// No description provided for @contactNew.
  ///
  /// In en, this message translates to:
  /// **'New Beneficiary'**
  String get contactNew;

  /// No description provided for @contactEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit beneficiary'**
  String get contactEdit;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get contactInformation;

  /// No description provided for @contactFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get contactFullName;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get contactPhone;

  /// No description provided for @contactCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get contactCountry;

  /// No description provided for @contactOperator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get contactOperator;

  /// No description provided for @contactGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get contactGender;

  /// No description provided for @contactMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get contactMale;

  /// No description provided for @contactFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get contactFemale;

  /// No description provided for @contactUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get contactUnspecified;

  /// No description provided for @contactSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get contactSave;

  /// No description provided for @contactEmpty.
  ///
  /// In en, this message translates to:
  /// **'No beneficiaries found.'**
  String get contactEmpty;

  /// No description provided for @contactNoPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get contactNoPhone;

  /// No description provided for @contactChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get contactChoose;

  /// No description provided for @contactRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get contactRequired;

  /// No description provided for @contactNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Maximum 120 characters'**
  String get contactNameTooLong;

  /// No description provided for @contactPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the number with its country code, e.g. +237…'**
  String get contactPhoneInvalid;

  /// No description provided for @contactNoOperators.
  ///
  /// In en, this message translates to:
  /// **'No Mobile Money operators available.'**
  String get contactNoOperators;

  /// No description provided for @contactNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Connection unavailable. Check your network.'**
  String get contactNetworkError;

  /// No description provided for @contactSessionError.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get contactSessionError;

  /// No description provided for @contactInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Check the phone, country and operator. A contact with multiple destinations cannot change country here.'**
  String get contactInvalidError;

  /// No description provided for @contactNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'This beneficiary or operator is no longer available.'**
  String get contactNotFoundError;

  /// No description provided for @contactServerError.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete this action. Please try again.'**
  String get contactServerError;

  /// No description provided for @contactUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This destination cannot be edited in the Mobile Money form.'**
  String get contactUnavailable;

  /// No description provided for @transferSendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send money'**
  String get transferSendTitle;

  /// No description provided for @transferChooseBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Choose a beneficiary'**
  String get transferChooseBeneficiary;

  /// No description provided for @transferYouSend.
  ///
  /// In en, this message translates to:
  /// **'You send'**
  String get transferYouSend;

  /// No description provided for @transferAmountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get transferAmountReceived;

  /// No description provided for @transferFundingLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get transferFundingLabel;

  /// No description provided for @transferFundingCard.
  ///
  /// In en, this message translates to:
  /// **'Bank card'**
  String get transferFundingCard;

  /// No description provided for @transferCurrentRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate'**
  String get transferCurrentRate;

  /// No description provided for @transferChooseForQuote.
  ///
  /// In en, this message translates to:
  /// **'Choose a beneficiary to calculate the rate and fees.'**
  String get transferChooseForQuote;

  /// No description provided for @transferContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get transferContinue;

  /// No description provided for @transferReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review your transfer'**
  String get transferReviewTitle;

  /// No description provided for @transferTrustWarning.
  ///
  /// In en, this message translates to:
  /// **'Do you know this person? Make sure you are sending money to someone you trust and that their details are correct.'**
  String get transferTrustWarning;

  /// No description provided for @transferConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm transfer'**
  String get transferConfirm;

  /// No description provided for @transferInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Check the beneficiary and the amount entered.'**
  String get transferInvalidError;

  /// No description provided for @transferBeneficiaryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This beneficiary or destination is no longer available.'**
  String get transferBeneficiaryUnavailable;

  /// No description provided for @transferConflictError.
  ///
  /// In en, this message translates to:
  /// **'This transfer has already been confirmed or can no longer be used.'**
  String get transferConflictError;

  /// No description provided for @transferQuoteExpired.
  ///
  /// In en, this message translates to:
  /// **'The rate has expired. A new quote will be calculated.'**
  String get transferQuoteExpired;

  /// No description provided for @transferUnavailableError.
  ///
  /// In en, this message translates to:
  /// **'This transfer is not available for this beneficiary or amount.'**
  String get transferUnavailableError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
