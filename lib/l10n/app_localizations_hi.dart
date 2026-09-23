// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'PayFlow';

  @override
  String get loginTagline => 'तेज़, आसान और सुरक्षित\nधन हस्तांतरण';

  @override
  String get emailOrPhone => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get or => 'या';

  @override
  String get noAccount => 'खाता नहीं है?';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get emailOrPhoneRequired => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get passwordRequired => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get french => 'फ़्रेंच';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get frenchSelected => 'फ़्रेंच चयनित';

  @override
  String get englishSelected => 'अंग्रेज़ी चयनित';

  @override
  String get signingIn => 'साइन इन हो रहा है…';

  @override
  String get signingInError =>
      'लॉगिन त्रुटि: कृपया अपना ईमेल या पासवर्ड जाँचें…';

  @override
  String get forgotPasswordMessage => 'पासवर्ड पुनर्प्राप्ति';

  @override
  String socialLoginMessage(String provider) {
    return '$provider से साइन इन हो रहा है';
  }

  @override
  String get createAccount => 'मेरा खाता बनाएँ';

  @override
  String get createYourAccount => 'अपना खाता बनाएँ';

  @override
  String get firstName => 'पहला नाम';

  @override
  String get lastName => 'अंतिम नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get firstNameRequired => 'कृपया अपना पहला नाम दर्ज करें';

  @override
  String get lastNameRequired => 'कृपया अपना अंतिम नाम दर्ज करें';

  @override
  String get emailRequired => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get phoneRequired => 'कृपया अपना फ़ोन नंबर दर्ज करें';

  @override
  String get confirmPasswordRequired => 'कृपया अपने पासवर्ड की पुष्टि करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get acceptTermsPrefix => 'मैं स्वीकार करता/करती हूँ';

  @override
  String get termsAndConditions => 'नियम और शर्तें';

  @override
  String get and => 'और';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsRequired => 'जारी रखने के लिए आपको शर्तें स्वीकार करनी होंगी';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get creatingAccount => 'आपका खाता बनाया जा रहा है…';

  @override
  String get passwordRequirementsTitle => 'पासवर्ड में यह होना चाहिए:';

  @override
  String get passwordMinLength => 'कम से कम 12 अक्षर';

  @override
  String get passwordUppercase => 'एक बड़ा अक्षर';

  @override
  String get passwordLowercase => 'एक छोटा अक्षर';

  @override
  String get passwordDigit => 'एक अंक';

  @override
  String get passwordSpecial => 'एक विशेष चिह्न';

  @override
  String get passwordInvalid => 'पासवर्ड सुरक्षा आवश्यकताओं को पूरा नहीं करता';

  @override
  String get selectCountry => 'देश चुनें';

  @override
  String get startupConnectionError =>
      'PayFlow से कनेक्ट नहीं हो सका। अपना कनेक्शन जाँचें और फिर प्रयास करें।';

  @override
  String get retry => 'फिर प्रयास करें';

  @override
  String get invalidCredentials => 'ईमेल या पासवर्ड गलत है।';

  @override
  String get loginNetworkError =>
      'PayFlow से कनेक्ट नहीं हो सका। अपना इंटरनेट कनेक्शन जाँचें।';

  @override
  String get loginTimeoutError =>
      'PayFlow को उत्तर देने में बहुत समय लग रहा है। फिर प्रयास करें।';

  @override
  String get loginServerError =>
      'PayFlow अस्थायी रूप से उपलब्ध नहीं है। थोड़ी देर बाद फिर प्रयास करें।';

  @override
  String get loginUnexpectedError =>
      'एक अनपेक्षित त्रुटि हुई। फिर प्रयास करें।';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get profileIdCopied => 'ID क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get verified => 'सत्यापित';

  @override
  String get notVerified => 'सत्यापित नहीं';

  @override
  String get myAccount => 'मेरा खाता';

  @override
  String get accountInformation => 'खाता जानकारी';

  @override
  String get accountInformationSubtitle =>
      'अपनी व्यक्तिगत जानकारी प्रबंधित करें';

  @override
  String get verificationAndLimits => 'सत्यापन और सीमाएँ';

  @override
  String get verificationAndLimitsSubtitle =>
      'अपना सत्यापन स्तर और सीमाएँ देखें';

  @override
  String get security => 'सुरक्षा';

  @override
  String get securityAndPrivacy => 'सुरक्षा और गोपनीयता';

  @override
  String get securityAndPrivacySubtitle => 'पासवर्ड, बायोमेट्रिक्स और सत्र';

  @override
  String get preferences => 'प्राथमिकताएँ';

  @override
  String get notificationPreferences => 'सूचना प्राथमिकताएँ';

  @override
  String get notificationPreferencesSubtitle =>
      'अपने अलर्ट और संदेश प्रबंधित करें';

  @override
  String get language => 'भाषा';

  @override
  String get languageSubtitle => 'ऐप की भाषा चुनें';

  @override
  String get help => 'सहायता';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String get helpAndSupportSubtitle => 'PayFlow से जुड़ी सहायता पाएँ';

  @override
  String get about => 'परिचय';

  @override
  String get aboutSubtitle => 'नियम, गोपनीयता और PayFlow की जानकारी';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get authentication => 'प्रमाणीकरण';

  @override
  String get biometrics => 'बायोमेट्रिक्स';

  @override
  String get biometricsSubtitle => 'Face ID, Touch ID या फ़िंगरप्रिंट';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get changePasswordSubtitle => 'अपने खाते का पासवर्ड बदलें';

  @override
  String get sessionsAndDevices => 'सत्र और डिवाइस';

  @override
  String get thisDeviceSubtitle => 'वर्तमान में उपयोग हो रहा PayFlow सत्र';

  @override
  String get activeSessions => 'सक्रिय सत्र';

  @override
  String get activeSessionsSubtitle => 'अपने खाते से जुड़े डिवाइस देखें';

  @override
  String get disconnectOtherDevices => 'अन्य डिवाइस से साइन आउट करें';

  @override
  String get disconnectOtherDevicesSubtitle => 'अन्य सभी सत्र निरस्त करें';

  @override
  String get biometricPrivacyInfo =>
      'आपका बायोमेट्रिक डेटा आपके डिवाइस पर ही रहता है। PayFlow को आपका चेहरा या फ़िंगरप्रिंट कभी प्राप्त नहीं होता।';

  @override
  String get checkingBiometrics => 'बायोमेट्रिक प्रमाणीकरण जाँचा जा रहा है…';

  @override
  String get biometricsUnavailable =>
      'इस डिवाइस पर कोई बायोमेट्रिक प्रमाणीकरण कॉन्फ़िगर नहीं है।';

  @override
  String get enableBiometricsReason =>
      'PayFlow बायोमेट्रिक्स चालू करने के लिए प्रमाणित करें।';

  @override
  String get disableBiometricsReason =>
      'PayFlow बायोमेट्रिक्स बंद करने के लिए प्रमाणित करें।';

  @override
  String get biometricAuthenticationFailed =>
      'बायोमेट्रिक प्रमाणीकरण पूरा नहीं हुआ।';

  @override
  String get biometricTechnicalError =>
      'अभी बायोमेट्रिक सेटिंग बदली नहीं जा सकती।';

  @override
  String get unlockPayFlowBiometricReason =>
      'PayFlow खोलने के लिए प्रमाणित करें।';

  @override
  String get biometricUnlockFailed => 'बायोमेट्रिक प्रमाणीकरण पूरा नहीं हुआ।';

  @override
  String get biometricUnlockUnavailable =>
      'PayFlow के लिए चालू बायोमेट्रिक्स अब इस डिवाइस पर उपलब्ध नहीं है।';

  @override
  String get retryBiometric => 'फिर प्रयास करें';

  @override
  String get activeSessionsTitle => 'सक्रिय सत्र';

  @override
  String get noActiveSessions => 'कोई सक्रिय सत्र नहीं है।';

  @override
  String get thisDevice => 'यह डिवाइस';

  @override
  String get currentSession => 'वर्तमान';

  @override
  String get lastActivity => 'अंतिम गतिविधि';

  @override
  String get sessionCreated => 'साइन इन का समय';

  @override
  String get sessionExpires => 'समाप्ति';

  @override
  String get ipAddress => 'IP पता';

  @override
  String get unknownDevice => 'अज्ञात डिवाइस';

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get revokeSessionTitle => 'इस डिवाइस को डिस्कनेक्ट करें?';

  @override
  String revokeSessionMessage(String deviceName) {
    return '$deviceName का सत्र निरस्त कर दिया जाएगा और इस डिवाइस पर फिर से साइन इन करना होगा।';
  }

  @override
  String get sessionRevokedSuccess => 'डिवाइस डिस्कनेक्ट कर दिया गया है।';

  @override
  String get activeSessionsNetworkError =>
      'सत्र लोड नहीं हो सके। अपना कनेक्शन जाँचें।';

  @override
  String get activeSessionsUnauthorized =>
      'आपका सत्र अब मान्य नहीं है। कृपया फिर से साइन इन करें।';

  @override
  String get activeSessionsServerError => 'सेवा अस्थायी रूप से उपलब्ध नहीं है।';

  @override
  String get activeSessionsUnexpectedError =>
      'अभी सत्र प्रबंधित नहीं किए जा सकते।';

  @override
  String get disconnectOtherDevicesConfirmTitle =>
      'अन्य डिवाइस डिस्कनेक्ट करें?';

  @override
  String get disconnectOtherDevicesConfirmMessage =>
      'आपके अन्य सभी PayFlow सत्र बंद हो जाएँगे। यह डिवाइस साइन इन रहेगा।';

  @override
  String get disconnectOtherDevicesSuccess =>
      'अन्य डिवाइस डिस्कनेक्ट कर दिए गए हैं।';

  @override
  String get currentDeviceTitle => 'यह डिवाइस';

  @override
  String get currentDeviceLoadError => 'इस डिवाइस की जानकारी लोड नहीं हो सकी।';

  @override
  String get deviceStatus => 'स्थिति';

  @override
  String get deviceActive => 'सक्रिय';

  @override
  String get deviceIdentifier => 'डिवाइस पहचानकर्ता';

  @override
  String get logout => 'साइन आउट करें';

  @override
  String get logoutCurrentDevice => 'इस डिवाइस से साइन आउट करें';

  @override
  String get logoutCurrentDeviceSubtitle =>
      'इस डिवाइस पर आपका PayFlow सत्र बंद हो जाएगा।';

  @override
  String get logoutCurrentDeviceConfirmTitle => 'साइन आउट करें?';

  @override
  String get logoutCurrentDeviceConfirmMessage =>
      'इस डिवाइस पर PayFlow खोलने के लिए आपको फिर से साइन इन करना होगा।';

  @override
  String get logoutCurrentDeviceNetworkError =>
      'साइन आउट नहीं हो सका। अपना कनेक्शन जाँचें और फिर प्रयास करें।';

  @override
  String get logoutCurrentDeviceServerError =>
      'साइन-आउट सेवा अस्थायी रूप से उपलब्ध नहीं है।';

  @override
  String get logoutCurrentDeviceUnexpectedError => 'अभी साइन आउट नहीं हो सकता।';

  @override
  String get homeWelcome => 'स्वागत है,';

  @override
  String get homeLastRateUsed => 'पिछली उपयोग की गई दर';

  @override
  String get homeAvailableRate => 'उपलब्ध दर';

  @override
  String get homeExchangeRate => 'विनिमय दर';

  @override
  String get homeNoRateAvailable => 'अभी कोई विनिमय दर उपलब्ध नहीं है';

  @override
  String get homeMainCurrency => 'मुख्य मुद्रा';

  @override
  String get homeRecentBeneficiaries => 'फिर से पैसे भेजें';

  @override
  String get homeSeeMore => 'और देखें';

  @override
  String get homeRecentTransactions => 'लेन-देन इतिहास';

  @override
  String get homeViewAll => 'सभी देखें';

  @override
  String get homeNewTransfer => 'नया हस्तांतरण';

  @override
  String get homeNoRecentBeneficiaries => 'कोई हाल का लाभार्थी नहीं है।';

  @override
  String get homeNoRecentTransactions => 'कोई हाल का लेन-देन नहीं है।';

  @override
  String get homeLoadErrorTitle => 'होम लोड नहीं हो सका';

  @override
  String get homeRetry => 'फिर प्रयास करें';

  @override
  String get homeNetworkError =>
      'अपना इंटरनेट कनेक्शन जाँचें और फिर प्रयास करें।';

  @override
  String get homeTimeoutError =>
      'सर्वर को उत्तर देने में बहुत समय लग रहा है। फिर प्रयास करें।';

  @override
  String get homeServerError =>
      'सर्वर में त्रुटि हुई। कुछ देर बाद फिर प्रयास करें।';

  @override
  String get homeSessionExpiredError => 'आपका सत्र समाप्त हो गया है।';

  @override
  String get homeInvalidResponseError => 'प्राप्त डेटा अमान्य है।';

  @override
  String get homeUnexpectedError => 'एक अनपेक्षित त्रुटि हुई।';

  @override
  String get homeStatusCreated => 'बनाया गया';

  @override
  String get homeStatusPending => 'लंबित';

  @override
  String get homeStatusProcessing => 'प्रक्रिया में';

  @override
  String get homeStatusCompleted => 'पूर्ण';

  @override
  String get homeStatusFailed => 'विफल';

  @override
  String get homeStatusCancelled => 'रद्द';

  @override
  String get homeStatusRefunded => 'धनवापसी हुई';

  @override
  String get homeTab => 'होम';

  @override
  String get transfersTab => 'हस्तांतरण';

  @override
  String get contactsTab => 'संपर्क';

  @override
  String get profileTab => 'प्रोफ़ाइल';

  @override
  String get referralTab => 'रेफ़र करें';

  @override
  String get transferAction => 'हस्तांतरण';

  @override
  String get homeSelectBeneficiaryHint =>
      'नीचे किसी लाभार्थी को चुनें या नया हस्तांतरण शुरू करें।';

  @override
  String get homeSelectedBeneficiary => 'चयनित लाभार्थी';

  @override
  String get homeViewMoreTransactions => 'और देखें';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get homeExchangeRateSubtitle => 'विनिमय दर';

  @override
  String get homeBeneficiaryLabel => 'लाभार्थी';

  @override
  String get exchangeRatesTitle => 'विनिमय दरें';

  @override
  String get exchangeRatesSearchHint => 'देश या मुद्रा से खोजें';

  @override
  String get exchangeRatesEmpty => 'अभी कोई विनिमय दर उपलब्ध नहीं है।';

  @override
  String get exchangeRatesNoSearchResult =>
      'आपकी खोज से कोई विनिमय दर मेल नहीं खाती।';

  @override
  String get exchangeRatesLoadError => 'विनिमय दरें लोड नहीं हो सकीं।';

  @override
  String get exchangeRatesRefreshError => 'विनिमय दरें रीफ़्रेश नहीं हो सकीं।';

  @override
  String get exchangeRatesRetry => 'फिर प्रयास करें';

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
  String get transferHistoryTitle => 'लेन-देन';

  @override
  String get transferDetailTitle => 'हस्तांतरण विवरण';

  @override
  String get transferNotFound => 'यह हस्तांतरण नहीं मिला।';

  @override
  String get transferStatusCreated => 'बनाया गया';

  @override
  String get transferStatusPending => 'लंबित';

  @override
  String get transferStatusProcessing => 'प्रक्रिया में';

  @override
  String get transferStatusCompleted => 'पूर्ण';

  @override
  String get transferStatusFailed => 'विफल';

  @override
  String get transferStatusCancelled => 'रद्द';

  @override
  String get transferStatusRefunded => 'धनवापसी हुई';

  @override
  String get transferStatusUnknown => 'अज्ञात स्थिति';

  @override
  String get transferBeneficiary => 'लाभार्थी';

  @override
  String get transferAllBeneficiaries => 'सभी लाभार्थी';

  @override
  String get transferStatusLabel => 'स्थिति';

  @override
  String get transferAllStatuses => 'सभी स्थितियाँ';

  @override
  String get transferResetFilters => 'फ़िल्टर रीसेट करें';

  @override
  String get transferCountLabel => 'कुल लेन-देन';

  @override
  String get transferSentTotalLabel => 'मुद्रा के अनुसार भेजी गई कुल राशि';

  @override
  String get transferHistoryEmpty => 'आपकी खोज से कोई हस्तांतरण मेल नहीं खाता।';

  @override
  String get transferLoadMore => 'और लोड करें';

  @override
  String get transferRecipientName => 'नाम';

  @override
  String get transferCountry => 'देश';

  @override
  String get transferOperator => 'ऑपरेटर';

  @override
  String get transferDestination => 'गंतव्य';

  @override
  String get transferAmounts => 'राशियाँ';

  @override
  String get transferSent => 'भेजी गई राशि';

  @override
  String transferSentTo(String amount, String beneficiary) {
    return 'आपने $beneficiary को $amount भेजा';
  }

  @override
  String get transferFee => 'शुल्क';

  @override
  String get transferTotalCharged => 'कुल काटी गई राशि';

  @override
  String get transferRate => 'लागू दर';

  @override
  String get transferReceived => 'प्राप्त होने वाली राशि';

  @override
  String get transferTracking => 'हस्तांतरण ट्रैकिंग';

  @override
  String get transferReference => 'संदर्भ';

  @override
  String get transferCreatedAt => 'बनाने की तारीख';

  @override
  String get transferExport => 'निर्यात करें';

  @override
  String get transferReceiptAction => 'रसीद देखें/निर्यात करें';

  @override
  String get transferRepeatAction => 'हस्तांतरण दोहराएँ';

  @override
  String get transferProviderReference => 'ऑपरेटर पुष्टि';

  @override
  String get transferTotalAmount => 'कुल राशि';

  @override
  String get transferTimelineUnavailable =>
      'इस हस्तांतरण के लिए विस्तृत ट्रैकिंग उपलब्ध नहीं है।';

  @override
  String get transferTrackingCompleted => 'राशि लाभार्थी को पहुँचा दी गई है।';

  @override
  String get transferTrackingFailed =>
      'हस्तांतरण विफल रहा। उपलब्ध ट्रैकिंग डेबिट या धनवापसी की स्थिति नहीं बताती।';

  @override
  String get transferTrackingCancelled =>
      'हस्तांतरण रद्द है। उपलब्ध ट्रैकिंग डेबिट या धनवापसी की स्थिति नहीं बताती।';

  @override
  String get transferTrackingRefunded =>
      'हस्तांतरण को धनवापसी किया हुआ चिह्नित किया गया है।';

  @override
  String get transferTrackingPending =>
      'हस्तांतरण प्रक्रिया में है। राशि की प्राप्ति की अभी पुष्टि नहीं हुई है।';

  @override
  String get transferYearLabel => 'वर्ष';

  @override
  String get transferAllYears => 'सभी वर्ष';

  @override
  String get contactTitle => 'लाभार्थी';

  @override
  String get contactSearch => 'खोजने के लिए नाम दर्ज करें…';

  @override
  String get contactAdd => 'लाभार्थी जोड़ें';

  @override
  String get contactSection => 'आपके लाभार्थी';

  @override
  String get contactNew => 'नया लाभार्थी';

  @override
  String get contactEdit => 'लाभार्थी संपादित करें';

  @override
  String get contactInformation => 'संपर्क जानकारी';

  @override
  String get contactFullName => 'पूरा नाम';

  @override
  String get contactPhone => 'फ़ोन नंबर';

  @override
  String get contactPhoneConfirmation => 'फ़ोन नंबर की पुष्टि करें';

  @override
  String get contactPhoneMismatch => 'दोनों फ़ोन नंबर मेल नहीं खाते।';

  @override
  String get contactChooseDialCode => 'देश और कॉलिंग कोड चुनें';

  @override
  String get contactCountry => 'देश';

  @override
  String get contactOperator => 'ऑपरेटर';

  @override
  String get contactGender => 'लिंग';

  @override
  String get contactMale => 'पुरुष';

  @override
  String get contactFemale => 'महिला';

  @override
  String get contactUnspecified => 'निर्दिष्ट नहीं';

  @override
  String get contactSave => 'बदलाव सहेजें';

  @override
  String get contactEmpty => 'कोई लाभार्थी नहीं मिला।';

  @override
  String get contactNoPhone => 'फ़ोन नंबर नहीं';

  @override
  String get contactChoose => 'चुनें';

  @override
  String get contactRequired => 'आवश्यक फ़ील्ड';

  @override
  String get contactNameTooLong => 'अधिकतम 120 अक्षर';

  @override
  String get contactPhoneInvalid => 'देश कोड सहित नंबर दर्ज करें, जैसे +237…';

  @override
  String get contactNoOperators => 'कोई मोबाइल मनी ऑपरेटर उपलब्ध नहीं है।';

  @override
  String get contactNetworkError =>
      'कनेक्शन उपलब्ध नहीं है। अपना नेटवर्क जाँचें।';

  @override
  String get contactSessionError =>
      'आपका सत्र समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get contactInvalidError =>
      'फ़ोन, देश और ऑपरेटर जाँचें। कई गंतव्यों वाला संपर्क यहाँ देश नहीं बदल सकता।';

  @override
  String get contactNotFoundError => 'यह लाभार्थी या ऑपरेटर अब उपलब्ध नहीं है।';

  @override
  String get contactServerError =>
      'यह कार्रवाई पूरी नहीं हो सकी। फिर प्रयास करें।';

  @override
  String get contactUnavailable =>
      'इस गंतव्य को मोबाइल मनी फ़ॉर्म में संपादित नहीं किया जा सकता।';

  @override
  String get transferSendTitle => 'पैसे भेजें';

  @override
  String get transferChooseBeneficiary => 'लाभार्थी चुनें';

  @override
  String get transferYouSend => 'आप भेजेंगे';

  @override
  String get transferAmountReceived => 'प्राप्त राशि';

  @override
  String get transferFundingLabel => 'भुगतान का तरीका';

  @override
  String get transferSuggestedAmounts => 'सुझाई गई राशियाँ';

  @override
  String get transferFundingCard => 'बैंक कार्ड';

  @override
  String get transferFundingApplePay => 'Apple Pay';

  @override
  String get transferFundingGooglePay => 'Google Pay';

  @override
  String get transferFundingPaypal => 'PayPal';

  @override
  String get transferPaypalReturnTitle => 'PayPal भुगतान पूरा करें';

  @override
  String get transferPaypalReturnMessage => 'PayPal में भुगतान अधिकृत करें, फिर PayFlow पर लौटकर उसका सत्यापन करें। सर्वर की पुष्टि के बाद ही हस्तांतरण बनाया जाएगा।';

  @override
  String get transferPaypalVerify => 'भुगतान सत्यापित करें';

  @override
  String get transferPaypalLaunchError => 'PayPal को सुरक्षित रूप से खोला नहीं जा सका।';

  @override
  String get transferCurrentRate => 'विनिमय दर';

  @override
  String get transferChooseForQuote =>
      'दर और शुल्क की गणना के लिए लाभार्थी चुनें।';

  @override
  String get transferContinue => 'जारी रखें';

  @override
  String get transferReviewTitle => 'अपने हस्तांतरण की समीक्षा करें';

  @override
  String get transferTrustWarning =>
      'क्या आप इस व्यक्ति को जानते हैं? सुनिश्चित करें कि आप किसी विश्वसनीय व्यक्ति को पैसे भेज रहे हैं और उसकी जानकारी सही है।';

  @override
  String get transferConfirm => 'हस्तांतरण की पुष्टि करें';

  @override
  String get transferInvalidError => 'लाभार्थी और दर्ज की गई राशि जाँचें।';

  @override
  String get transferBeneficiaryUnavailable =>
      'यह लाभार्थी या गंतव्य अब उपलब्ध नहीं है।';

  @override
  String get transferConflictError =>
      'इस हस्तांतरण की पहले ही पुष्टि हो चुकी है या अब इसका उपयोग नहीं किया जा सकता।';

  @override
  String get transferQuoteExpired =>
      'दर समाप्त हो गई है। नई कोटेशन की गणना की जाएगी।';

  @override
  String get transferAmountBelowMinimumError =>
      'राशि इस गंतव्य के लिए अनुमत न्यूनतम सीमा से कम है।';

  @override
  String get transferAmountAboveMaximumError =>
      'राशि इस गंतव्य के लिए अनुमत अधिकतम सीमा से अधिक है।';

  @override
  String get transferUnavailableError =>
      'यह हस्तांतरण इस लाभार्थी या राशि के लिए उपलब्ध नहीं है।';

  @override
  String get systemLanguage => 'डिवाइस की भाषा';

  @override
  String get spanish => 'स्पेनिश';

  @override
  String get mandarin => 'मंदारिन चीनी';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get currentPasswordRequired => 'कृपया अपना वर्तमान पासवर्ड दर्ज करें';

  @override
  String get currentPasswordIncorrect => 'वर्तमान पासवर्ड गलत है।';

  @override
  String get newPasswordRequired => 'कृपया नया पासवर्ड दर्ज करें';

  @override
  String get newPasswordUnchanged =>
      'नया पासवर्ड वर्तमान पासवर्ड से अलग होना चाहिए।';

  @override
  String get confirmNewPasswordRequired =>
      'कृपया अपने नए पासवर्ड की पुष्टि करें';

  @override
  String get passwordChangeSessionInfo =>
      'आपकी सुरक्षा के लिए, अन्य सभी डिवाइस से साइन आउट कर दिया जाएगा। यह डिवाइस साइन इन रहेगा।';

  @override
  String get changePasswordAction => 'पासवर्ड बदलें';

  @override
  String get passwordChangedTitle => 'पासवर्ड बदल दिया गया';

  @override
  String get passwordChangedMessage =>
      'आपका पासवर्ड बदल दिया गया है। आपके अन्य डिवाइस से साइन आउट कर दिया गया है।';

  @override
  String get continueAction => 'जारी रखें';

  @override
  String get passwordLoginUnavailable =>
      'यह खाता बाहरी साइन-इन प्रदाता का उपयोग करता है और इसमें PayFlow पासवर्ड नहीं है।';

  @override
  String get changePasswordNetworkError =>
      'पासवर्ड नहीं बदला जा सका। अपना कनेक्शन जाँचें।';

  @override
  String get changePasswordServerError =>
      'पासवर्ड सेवा अस्थायी रूप से उपलब्ध नहीं है।';

  @override
  String get changePasswordUnexpectedError => 'अभी पासवर्ड नहीं बदला जा सकता।';
}
