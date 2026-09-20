import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Mandarin Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'PayFlow';

  @override
  String get loginTagline => '快速、简单、安全的\n汇款服务';

  @override
  String get emailOrPhone => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get signIn => '登录';

  @override
  String get or => '或';

  @override
  String get noAccount => '还没有账户？';

  @override
  String get signUp => '注册';

  @override
  String get emailOrPhoneRequired => '请输入电子邮箱';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get changeLanguage => '更改语言';

  @override
  String get french => '法语';

  @override
  String get english => '英语';

  @override
  String get frenchSelected => '已选择法语';

  @override
  String get englishSelected => '已选择英语';

  @override
  String get signingIn => '正在登录…';

  @override
  String get signingInError => '登录错误：请检查您的邮箱或密码…';

  @override
  String get forgotPasswordMessage => '找回密码';

  @override
  String socialLoginMessage(String provider) {
    return '正在使用 $provider 登录';
  }

  @override
  String get createAccount => '创建我的账户';

  @override
  String get createYourAccount => '创建您的账户';

  @override
  String get firstName => '名字';

  @override
  String get lastName => '姓氏';

  @override
  String get email => '电子邮箱';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get firstNameRequired => '请输入名字';

  @override
  String get lastNameRequired => '请输入姓氏';

  @override
  String get emailRequired => '请输入电子邮箱';

  @override
  String get phoneRequired => '请输入电话号码';

  @override
  String get confirmPasswordRequired => '请确认密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get acceptTermsPrefix => '我接受';

  @override
  String get termsAndConditions => '条款与条件';

  @override
  String get and => '以及';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsRequired => '您必须接受相关条款才能继续';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get creatingAccount => '正在创建您的账户…';

  @override
  String get passwordRequirementsTitle => '密码必须包含：';

  @override
  String get passwordMinLength => '至少 12 个字符';

  @override
  String get passwordUppercase => '一个大写字母';

  @override
  String get passwordLowercase => '一个小写字母';

  @override
  String get passwordDigit => '一个数字';

  @override
  String get passwordSpecial => '一个特殊字符';

  @override
  String get passwordInvalid => '密码不符合安全要求';

  @override
  String get selectCountry => '选择国家';

  @override
  String get startupConnectionError => '无法连接到 PayFlow。请检查网络连接后重试。';

  @override
  String get retry => '重试';

  @override
  String get invalidCredentials => '电子邮箱或密码不正确。';

  @override
  String get loginNetworkError => '无法连接到 PayFlow。请检查您的互联网连接。';

  @override
  String get loginTimeoutError => 'PayFlow 响应时间过长，请重试。';

  @override
  String get loginServerError => 'PayFlow 暂时不可用，请稍后重试。';

  @override
  String get loginUnexpectedError => '发生意外错误，请重试。';

  @override
  String get profile => '个人资料';

  @override
  String get profileIdCopied => 'ID 已复制到剪贴板';

  @override
  String get verified => '已验证';

  @override
  String get notVerified => '未验证';

  @override
  String get myAccount => '我的账户';

  @override
  String get accountInformation => '账户信息';

  @override
  String get accountInformationSubtitle => '管理您的个人信息';

  @override
  String get verificationAndLimits => '验证与限额';

  @override
  String get verificationAndLimitsSubtitle => '查看您的验证等级和限额';

  @override
  String get security => '安全';

  @override
  String get securityAndPrivacy => '安全与隐私';

  @override
  String get securityAndPrivacySubtitle => '密码、生物识别和会话';

  @override
  String get preferences => '偏好设置';

  @override
  String get notificationPreferences => '通知偏好';

  @override
  String get notificationPreferencesSubtitle => '管理您的提醒和消息';

  @override
  String get language => '语言';

  @override
  String get languageSubtitle => '选择应用语言';

  @override
  String get help => '帮助';

  @override
  String get helpAndSupport => '帮助与支持';

  @override
  String get helpAndSupportSubtitle => '获取 PayFlow 帮助';

  @override
  String get about => '关于';

  @override
  String get aboutSubtitle => '条款、隐私及 PayFlow 信息';

  @override
  String get signOut => '退出登录';

  @override
  String get authentication => '身份验证';

  @override
  String get biometrics => '生物识别';

  @override
  String get biometricsSubtitle => '面容 ID、触控 ID 或指纹';

  @override
  String get changePassword => '更改密码';

  @override
  String get changePasswordSubtitle => '更改您的账户密码';

  @override
  String get sessionsAndDevices => '会话与设备';

  @override
  String get thisDeviceSubtitle => '当前正在使用的 PayFlow 会话';

  @override
  String get activeSessions => '活跃会话';

  @override
  String get activeSessionsSubtitle => '查看已连接到您账户的设备';

  @override
  String get disconnectOtherDevices => '退出其他设备';

  @override
  String get disconnectOtherDevicesSubtitle => '撤销所有其他会话';

  @override
  String get biometricPrivacyInfo => '您的生物识别数据仅保留在设备上。PayFlow 永远不会接收您的面部或指纹数据。';

  @override
  String get checkingBiometrics => '正在检查生物识别身份验证…';

  @override
  String get biometricsUnavailable => '此设备尚未配置生物识别身份验证。';

  @override
  String get enableBiometricsReason => '请验证身份以启用 PayFlow 生物识别。';

  @override
  String get disableBiometricsReason => '请验证身份以停用 PayFlow 生物识别。';

  @override
  String get biometricAuthenticationFailed => '生物识别身份验证未完成。';

  @override
  String get biometricTechnicalError => '目前无法更改生物识别设置。';

  @override
  String get unlockPayFlowBiometricReason => '请验证身份以访问 PayFlow。';

  @override
  String get biometricUnlockFailed => '生物识别身份验证未完成。';

  @override
  String get biometricUnlockUnavailable => '此设备上为 PayFlow 启用的生物识别已不可用。';

  @override
  String get retryBiometric => '重试';

  @override
  String get activeSessionsTitle => '活跃会话';

  @override
  String get noActiveSessions => '没有活跃会话。';

  @override
  String get thisDevice => '此设备';

  @override
  String get currentSession => '当前';

  @override
  String get lastActivity => '最后活动时间';

  @override
  String get sessionCreated => '登录时间';

  @override
  String get sessionExpires => '到期时间';

  @override
  String get ipAddress => 'IP 地址';

  @override
  String get unknownDevice => '未知设备';

  @override
  String get disconnect => '断开连接';

  @override
  String get cancel => '取消';

  @override
  String get revokeSessionTitle => '要断开此设备吗？';

  @override
  String revokeSessionMessage(String deviceName) {
    return '$deviceName 上的会话将被撤销，该设备需要重新登录。';
  }

  @override
  String get sessionRevokedSuccess => '设备已断开连接。';

  @override
  String get activeSessionsNetworkError => '无法加载会话，请检查网络连接。';

  @override
  String get activeSessionsUnauthorized => '您的会话已失效，请重新登录。';

  @override
  String get activeSessionsServerError => '服务暂时不可用。';

  @override
  String get activeSessionsUnexpectedError => '目前无法管理会话。';

  @override
  String get disconnectOtherDevicesConfirmTitle => '要断开其他设备吗？';

  @override
  String get disconnectOtherDevicesConfirmMessage => '您的所有其他 PayFlow 会话都将退出，此设备将保持登录。';

  @override
  String get disconnectOtherDevicesSuccess => '其他设备已断开连接。';

  @override
  String get currentDeviceTitle => '此设备';

  @override
  String get currentDeviceLoadError => '无法加载此设备的信息。';

  @override
  String get deviceStatus => '状态';

  @override
  String get deviceActive => '活跃';

  @override
  String get deviceIdentifier => '设备标识符';

  @override
  String get logout => '退出登录';

  @override
  String get logoutCurrentDevice => '退出此设备';

  @override
  String get logoutCurrentDeviceSubtitle => '此设备上的 PayFlow 会话将关闭。';

  @override
  String get logoutCurrentDeviceConfirmTitle => '要退出登录吗？';

  @override
  String get logoutCurrentDeviceConfirmMessage => '您需要重新登录才能在此设备上访问 PayFlow。';

  @override
  String get logoutCurrentDeviceNetworkError => '无法退出登录，请检查网络连接后重试。';

  @override
  String get logoutCurrentDeviceServerError => '退出登录服务暂时不可用。';

  @override
  String get logoutCurrentDeviceUnexpectedError => '目前无法退出登录。';

  @override
  String get homeWelcome => '欢迎，';

  @override
  String get homeLastRateUsed => '上次使用的汇率';

  @override
  String get homeAvailableRate => '可用汇率';

  @override
  String get homeExchangeRate => '汇率';

  @override
  String get homeNoRateAvailable => '当前没有可用汇率';

  @override
  String get homeMainCurrency => '主要货币';

  @override
  String get homeRecentBeneficiaries => '再次汇款给';

  @override
  String get homeSeeMore => '更多';

  @override
  String get homeRecentTransactions => '交易记录';

  @override
  String get homeViewAll => '查看全部';

  @override
  String get homeNewTransfer => '新建汇款';

  @override
  String get homeNoRecentBeneficiaries => '没有最近的收款人。';

  @override
  String get homeNoRecentTransactions => '没有最近的交易。';

  @override
  String get homeLoadErrorTitle => '无法加载首页';

  @override
  String get homeRetry => '重试';

  @override
  String get homeNetworkError => '请检查互联网连接后重试。';

  @override
  String get homeTimeoutError => '服务器响应时间过长，请重试。';

  @override
  String get homeServerError => '服务器发生错误，请稍后重试。';

  @override
  String get homeSessionExpiredError => '您的会话已过期。';

  @override
  String get homeInvalidResponseError => '收到的数据无效。';

  @override
  String get homeUnexpectedError => '发生意外错误。';

  @override
  String get homeStatusCreated => '已创建';

  @override
  String get homeStatusPending => '待处理';

  @override
  String get homeStatusProcessing => '处理中';

  @override
  String get homeStatusCompleted => '已完成';

  @override
  String get homeStatusFailed => '失败';

  @override
  String get homeStatusCancelled => '已取消';

  @override
  String get homeStatusRefunded => '已退款';

  @override
  String get homeTab => '首页';

  @override
  String get transfersTab => '汇款';

  @override
  String get contactsTab => '联系人';

  @override
  String get profileTab => '我的';

  @override
  String get referralTab => '推荐';

  @override
  String get transferAction => '汇款';

  @override
  String get homeSelectBeneficiaryHint => '请在下方选择收款人或开始新的汇款。';

  @override
  String get homeSelectedBeneficiary => '已选收款人';

  @override
  String get homeViewMoreTransactions => '查看更多';

  @override
  String get comingSoon => '即将推出';

  @override
  String get homeExchangeRateSubtitle => '汇率';

  @override
  String get homeBeneficiaryLabel => '收款人';

  @override
  String get exchangeRatesTitle => '汇率';

  @override
  String get exchangeRatesSearchHint => '按国家或货币搜索';

  @override
  String get exchangeRatesEmpty => '当前没有可用汇率。';

  @override
  String get exchangeRatesNoSearchResult => '没有符合搜索条件的汇率。';

  @override
  String get exchangeRatesLoadError => '无法加载汇率。';

  @override
  String get exchangeRatesRefreshError => '无法刷新汇率。';

  @override
  String get exchangeRatesRetry => '重试';

  @override
  String exchangeRateCorridor(String sourceCountry, String destinationCountry) {
    return '$sourceCountry → $destinationCountry';
  }

  @override
  String exchangeRateEquation(String sourceCurrency, String rate, String targetCurrency) {
    return '1 $sourceCurrency = $rate $targetCurrency';
  }

  @override
  String get transferHistoryTitle => '交易';

  @override
  String get transferDetailTitle => '汇款详情';

  @override
  String get transferNotFound => '找不到此笔汇款。';

  @override
  String get transferStatusCreated => '已创建';

  @override
  String get transferStatusPending => '待处理';

  @override
  String get transferStatusProcessing => '处理中';

  @override
  String get transferStatusCompleted => '已完成';

  @override
  String get transferStatusFailed => '失败';

  @override
  String get transferStatusCancelled => '已取消';

  @override
  String get transferStatusRefunded => '已退款';

  @override
  String get transferStatusUnknown => '未知状态';

  @override
  String get transferBeneficiary => '收款人';

  @override
  String get transferAllBeneficiaries => '所有收款人';

  @override
  String get transferStatusLabel => '状态';

  @override
  String get transferAllStatuses => '所有状态';

  @override
  String get transferResetFilters => '重置筛选条件';

  @override
  String get transferCountLabel => '交易总数';

  @override
  String get transferSentTotalLabel => '按货币统计的汇出总额';

  @override
  String get transferHistoryEmpty => '没有符合搜索条件的汇款。';

  @override
  String get transferLoadMore => '加载更多';

  @override
  String get transferRecipientName => '姓名';

  @override
  String get transferCountry => '国家';

  @override
  String get transferOperator => '运营商';

  @override
  String get transferDestination => '收款方式';

  @override
  String get transferAmounts => '金额';

  @override
  String get transferSent => '汇出金额';

  @override
  String transferSentTo(String amount, String beneficiary) {
    return '您向 $beneficiary 汇出了 $amount';
  }

  @override
  String get transferFee => '手续费';

  @override
  String get transferTotalCharged => '扣款总额';

  @override
  String get transferRate => '适用汇率';

  @override
  String get transferReceived => '预计到账金额';

  @override
  String get transferTracking => '汇款进度';

  @override
  String get transferReference => '参考编号';

  @override
  String get transferCreatedAt => '创建时间';

  @override
  String get transferExport => '导出';

  @override
  String get transferReceiptAction => '查看/导出收据';

  @override
  String get transferRepeatAction => '再次汇款';

  @override
  String get transferProviderReference => '运营商确认编号';

  @override
  String get transferTotalAmount => '总金额';

  @override
  String get transferTimelineUnavailable => '此笔汇款暂无详细进度信息。';

  @override
  String get transferTrackingCompleted => '资金已送达收款人。';

  @override
  String get transferTrackingFailed => '汇款失败。现有进度信息未说明扣款或退款情况。';

  @override
  String get transferTrackingCancelled => '汇款已取消。现有进度信息未说明扣款或退款情况。';

  @override
  String get transferTrackingRefunded => '此笔汇款已标记为退款。';

  @override
  String get transferTrackingPending => '汇款正在处理中，尚未确认到账。';

  @override
  String get transferYearLabel => '年份';

  @override
  String get transferAllYears => '所有年份';

  @override
  String get contactTitle => '收款人';

  @override
  String get contactSearch => '输入姓名进行搜索…';

  @override
  String get contactAdd => '添加收款人';

  @override
  String get contactSection => '您的收款人';

  @override
  String get contactNew => '新建收款人';

  @override
  String get contactEdit => '编辑收款人';

  @override
  String get contactInformation => '联系人信息';

  @override
  String get contactFullName => '完整姓名';

  @override
  String get contactPhone => '电话号码';

  @override
  String get contactCountry => '国家';

  @override
  String get contactOperator => '运营商';

  @override
  String get contactGender => '性别';

  @override
  String get contactMale => '男';

  @override
  String get contactFemale => '女';

  @override
  String get contactUnspecified => '未指定';

  @override
  String get contactSave => '保存更改';

  @override
  String get contactEmpty => '未找到收款人。';

  @override
  String get contactNoPhone => '无电话号码';

  @override
  String get contactChoose => '选择';

  @override
  String get contactRequired => '必填字段';

  @override
  String get contactNameTooLong => '最多 120 个字符';

  @override
  String get contactPhoneInvalid => '请输入带国家/地区代码的号码，例如 +237…';

  @override
  String get contactNoOperators => '没有可用的移动钱包运营商。';

  @override
  String get contactNetworkError => '网络连接不可用，请检查网络。';

  @override
  String get contactSessionError => '您的会话已过期，请重新登录。';

  @override
  String get contactInvalidError => '请检查电话号码、国家和运营商。拥有多个收款方式的联系人不能在此更改国家。';

  @override
  String get contactNotFoundError => '此收款人或运营商已不可用。';

  @override
  String get contactServerError => '无法完成此操作，请重试。';

  @override
  String get contactUnavailable => '无法在移动钱包表单中编辑此收款方式。';

  @override
  String get transferSendTitle => '汇款';

  @override
  String get transferChooseBeneficiary => '选择收款人';

  @override
  String get transferYouSend => '您汇出';

  @override
  String get transferAmountReceived => '到账金额';

  @override
  String get transferFundingLabel => '付款方式';

  @override
  String get transferFundingCard => '银行卡';

  @override
  String get transferCurrentRate => '汇率';

  @override
  String get transferChooseForQuote => '选择收款人以计算汇率和手续费。';

  @override
  String get transferContinue => '继续';

  @override
  String get transferReviewTitle => '核对汇款信息';

  @override
  String get transferTrustWarning => '您认识此人吗？请确保您将资金汇给可信任的人，并确认其信息正确。';

  @override
  String get transferConfirm => '确认汇款';

  @override
  String get transferInvalidError => '请检查收款人和输入的金额。';

  @override
  String get transferBeneficiaryUnavailable => '此收款人或收款方式已不可用。';

  @override
  String get transferConflictError => '此笔汇款已确认或无法再使用。';

  @override
  String get transferQuoteExpired => '汇率已过期，将重新计算报价。';

  @override
  String get transferUnavailableError => '此收款人或该金额暂不支持汇款。';

  @override
  String get systemLanguage => '跟随设备语言';

  @override
  String get spanish => '西班牙语';

  @override
  String get mandarin => '中文（普通话）';

  @override
  String get hindi => '印地语';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get currentPasswordRequired => '请输入当前密码';

  @override
  String get currentPasswordIncorrect => '当前密码不正确。';

  @override
  String get newPasswordRequired => '请输入新密码';

  @override
  String get newPasswordUnchanged => '新密码必须与当前密码不同。';

  @override
  String get confirmNewPasswordRequired => '请确认新密码';

  @override
  String get passwordChangeSessionInfo => '为了您的安全，所有其他设备都将退出登录。此设备将保持登录状态。';

  @override
  String get changePasswordAction => '更改密码';

  @override
  String get passwordChangedTitle => '密码已更改';

  @override
  String get passwordChangedMessage => '您的密码已更改，其他设备均已退出登录。';

  @override
  String get continueAction => '继续';

  @override
  String get passwordLoginUnavailable => '此账户使用外部登录提供商，没有 PayFlow 密码。';

  @override
  String get changePasswordNetworkError => '无法更改密码，请检查网络连接。';

  @override
  String get changePasswordServerError => '密码服务暂时不可用。';

  @override
  String get changePasswordUnexpectedError => '目前无法更改密码。';

}
