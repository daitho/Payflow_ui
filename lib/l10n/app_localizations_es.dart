// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'PayFlow';

  @override
  String get loginTagline =>
      'Transferencias de dinero\nrápidas, sencillas y seguras';

  @override
  String get emailOrPhone => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get or => 'o';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get emailOrPhoneRequired => 'Introduce tu correo electrónico';

  @override
  String get passwordRequired => 'Introduce tu contraseña';

  @override
  String get changeLanguage => 'Cambiar idioma';

  @override
  String get french => 'Francés';

  @override
  String get english => 'Inglés';

  @override
  String get frenchSelected => 'Francés seleccionado';

  @override
  String get englishSelected => 'Inglés seleccionado';

  @override
  String get signingIn => 'Iniciando sesión...';

  @override
  String get signingInError =>
      'Error de inicio de sesión: comprueba tu correo electrónico o contraseña...';

  @override
  String get forgotPasswordMessage => 'Recuperación de contraseña';

  @override
  String socialLoginMessage(String provider) {
    return 'Iniciando sesión con $provider';
  }

  @override
  String get createAccount => 'Crear mi cuenta';

  @override
  String get createYourAccount => 'Crea tu cuenta';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellidos';

  @override
  String get email => 'Correo electrónico';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get firstNameRequired => 'Introduce tu nombre';

  @override
  String get lastNameRequired => 'Introduce tus apellidos';

  @override
  String get emailRequired => 'Introduce tu correo electrónico';

  @override
  String get phoneRequired => 'Introduce tu número de teléfono';

  @override
  String get confirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get acceptTermsPrefix => 'Acepto los';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get and => 'y la';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsRequired => 'Debes aceptar las condiciones para continuar';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get creatingAccount => 'Creando tu cuenta...';

  @override
  String get passwordRequirementsTitle => 'La contraseña debe contener:';

  @override
  String get passwordMinLength => 'Al menos 12 caracteres';

  @override
  String get passwordUppercase => 'Una letra mayúscula';

  @override
  String get passwordLowercase => 'Una letra minúscula';

  @override
  String get passwordDigit => 'Un número';

  @override
  String get passwordSpecial => 'Un carácter especial';

  @override
  String get passwordInvalid =>
      'La contraseña no cumple los requisitos de seguridad';

  @override
  String get selectCountry => 'Seleccionar un país';

  @override
  String get startupConnectionError =>
      'No se puede conectar con PayFlow. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get retry => 'Intentar de nuevo';

  @override
  String get invalidCredentials =>
      'Correo electrónico o contraseña incorrectos.';

  @override
  String get loginNetworkError =>
      'No se puede conectar con PayFlow. Comprueba tu conexión a Internet.';

  @override
  String get loginTimeoutError =>
      'PayFlow tarda demasiado en responder. Inténtalo de nuevo.';

  @override
  String get loginServerError =>
      'PayFlow no está disponible temporalmente. Inténtalo de nuevo en breve.';

  @override
  String get loginUnexpectedError =>
      'Se produjo un error inesperado. Inténtalo de nuevo.';

  @override
  String get profile => 'Perfil';

  @override
  String get profileIdCopied => 'ID copiado al portapapeles';

  @override
  String get verified => 'Verificado';

  @override
  String get notVerified => 'No verificado';

  @override
  String get myAccount => 'Mi cuenta';

  @override
  String get accountInformation => 'Información de la cuenta';

  @override
  String get accountInformationSubtitle => 'Gestiona tu información personal';

  @override
  String get verificationAndLimits => 'Verificación y límites';

  @override
  String get verificationAndLimitsSubtitle =>
      'Consulta tu nivel de verificación y tus límites';

  @override
  String get security => 'Seguridad';

  @override
  String get securityAndPrivacy => 'Seguridad y privacidad';

  @override
  String get securityAndPrivacySubtitle => 'Contraseña, biometría y sesiones';

  @override
  String get preferences => 'Preferencias';

  @override
  String get notificationPreferences => 'Preferencias de notificaciones';

  @override
  String get notificationPreferencesSubtitle =>
      'Gestiona tus alertas y mensajes';

  @override
  String get language => 'Idioma';

  @override
  String get languageSubtitle => 'Elige el idioma de la aplicación';

  @override
  String get help => 'Ayuda';

  @override
  String get helpAndSupport => 'Ayuda y soporte';

  @override
  String get helpAndSupportSubtitle => 'Obtén ayuda con PayFlow';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutSubtitle =>
      'Condiciones, privacidad e información de PayFlow';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get authentication => 'Autenticación';

  @override
  String get biometrics => 'Biometría';

  @override
  String get biometricsSubtitle => 'Face ID, Touch ID o huella digital';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get changePasswordSubtitle => 'Cambia la contraseña de tu cuenta';

  @override
  String get sessionsAndDevices => 'Sesiones y dispositivos';

  @override
  String get thisDeviceSubtitle => 'La sesión de PayFlow actualmente en uso';

  @override
  String get activeSessions => 'Sesiones activas';

  @override
  String get activeSessionsSubtitle =>
      'Consulta los dispositivos conectados a tu cuenta';

  @override
  String get disconnectOtherDevices => 'Desconectar otros dispositivos';

  @override
  String get disconnectOtherDevicesSubtitle =>
      'Revocar todas las demás sesiones';

  @override
  String get biometricPrivacyInfo =>
      'Tus datos biométricos permanecen en tu dispositivo. PayFlow nunca recibe tu rostro ni tu huella digital.';

  @override
  String get checkingBiometrics => 'Comprobando la autenticación biométrica...';

  @override
  String get biometricsUnavailable =>
      'No hay autenticación biométrica configurada en este dispositivo.';

  @override
  String get enableBiometricsReason =>
      'Autentícate para activar la biometría de PayFlow.';

  @override
  String get disableBiometricsReason =>
      'Autentícate para desactivar la biometría de PayFlow.';

  @override
  String get biometricAuthenticationFailed =>
      'La autenticación biométrica no se completó.';

  @override
  String get biometricTechnicalError =>
      'La configuración biométrica no se puede cambiar ahora.';

  @override
  String get unlockPayFlowBiometricReason =>
      'Autentícate para acceder a PayFlow.';

  @override
  String get biometricUnlockFailed =>
      'La autenticación biométrica no se completó.';

  @override
  String get biometricUnlockUnavailable =>
      'La biometría activada para PayFlow ya no está disponible en este dispositivo.';

  @override
  String get retryBiometric => 'Intentar de nuevo';

  @override
  String get activeSessionsTitle => 'Sesiones activas';

  @override
  String get noActiveSessions => 'No hay sesiones activas.';

  @override
  String get thisDevice => 'Este dispositivo';

  @override
  String get currentSession => 'ACTUAL';

  @override
  String get lastActivity => 'Última actividad';

  @override
  String get sessionCreated => 'Sesión iniciada';

  @override
  String get sessionExpires => 'Caduca';

  @override
  String get ipAddress => 'Dirección IP';

  @override
  String get unknownDevice => 'Dispositivo desconocido';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get revokeSessionTitle => '¿Desconectar este dispositivo?';

  @override
  String revokeSessionMessage(String deviceName) {
    return 'La sesión en $deviceName será revocada y este dispositivo deberá iniciar sesión de nuevo.';
  }

  @override
  String get sessionRevokedSuccess => 'El dispositivo se ha desconectado.';

  @override
  String get activeSessionsNetworkError =>
      'No se pueden cargar las sesiones. Comprueba tu conexión.';

  @override
  String get activeSessionsUnauthorized =>
      'Tu sesión ya no es válida. Inicia sesión de nuevo.';

  @override
  String get activeSessionsServerError =>
      'El servicio no está disponible temporalmente.';

  @override
  String get activeSessionsUnexpectedError =>
      'No se pueden gestionar las sesiones ahora.';

  @override
  String get disconnectOtherDevicesConfirmTitle =>
      '¿Desconectar los demás dispositivos?';

  @override
  String get disconnectOtherDevicesConfirmMessage =>
      'Todas tus demás sesiones de PayFlow se cerrarán. Este dispositivo seguirá conectado.';

  @override
  String get disconnectOtherDevicesSuccess =>
      'Los demás dispositivos se han desconectado.';

  @override
  String get currentDeviceTitle => 'Este dispositivo';

  @override
  String get currentDeviceLoadError =>
      'No se puede cargar la información de este dispositivo.';

  @override
  String get deviceStatus => 'Estado';

  @override
  String get deviceActive => 'Activo';

  @override
  String get deviceIdentifier => 'Identificador del dispositivo';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutCurrentDevice => 'Cerrar sesión en este dispositivo';

  @override
  String get logoutCurrentDeviceSubtitle =>
      'Tu sesión de PayFlow se cerrará en este dispositivo.';

  @override
  String get logoutCurrentDeviceConfirmTitle => '¿Cerrar sesión?';

  @override
  String get logoutCurrentDeviceConfirmMessage =>
      'Tendrás que iniciar sesión de nuevo para acceder a PayFlow en este dispositivo.';

  @override
  String get logoutCurrentDeviceNetworkError =>
      'No se puede cerrar la sesión. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get logoutCurrentDeviceServerError =>
      'El servicio de cierre de sesión no está disponible temporalmente.';

  @override
  String get logoutCurrentDeviceUnexpectedError =>
      'No se puede cerrar la sesión ahora.';

  @override
  String get homeWelcome => 'Bienvenido/a,';

  @override
  String get homeLastRateUsed => 'Último tipo utilizado';

  @override
  String get homeAvailableRate => 'Tipo disponible';

  @override
  String get homeExchangeRate => 'Tipo de cambio';

  @override
  String get homeNoRateAvailable =>
      'No hay ningún tipo de cambio disponible actualmente';

  @override
  String get homeMainCurrency => 'Moneda principal';

  @override
  String get homeRecentBeneficiaries => 'Volver a enviar dinero a';

  @override
  String get homeSeeMore => 'Más';

  @override
  String get homeRecentTransactions => 'Historial de transacciones';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get homeNewTransfer => 'Nueva transferencia';

  @override
  String get homeNoRecentBeneficiaries => 'No hay beneficiarios recientes.';

  @override
  String get homeNoRecentTransactions => 'No hay transacciones recientes.';

  @override
  String get homeLoadErrorTitle => 'No se puede cargar el inicio';

  @override
  String get homeRetry => 'Reintentar';

  @override
  String get homeNetworkError =>
      'Comprueba tu conexión a Internet e inténtalo de nuevo.';

  @override
  String get homeTimeoutError =>
      'El servidor tarda demasiado en responder. Inténtalo de nuevo.';

  @override
  String get homeServerError =>
      'Se produjo un error del servidor. Inténtalo de nuevo en unos instantes.';

  @override
  String get homeSessionExpiredError => 'Tu sesión ha caducado.';

  @override
  String get homeInvalidResponseError => 'Los datos recibidos no son válidos.';

  @override
  String get homeUnexpectedError => 'Se produjo un error inesperado.';

  @override
  String get homeStatusCreated => 'Creada';

  @override
  String get homeStatusPending => 'Pendiente';

  @override
  String get homeStatusProcessing => 'En proceso';

  @override
  String get homeStatusCompleted => 'Completada';

  @override
  String get homeStatusFailed => 'Fallida';

  @override
  String get homeStatusCancelled => 'Cancelada';

  @override
  String get homeStatusRefunded => 'Reembolsada';

  @override
  String get homeTab => 'Inicio';

  @override
  String get transfersTab => 'Transferencias';

  @override
  String get contactsTab => 'Contactos';

  @override
  String get profileTab => 'Perfil';

  @override
  String get referralTab => 'Recomendar';

  @override
  String get transferAction => 'Transferir';

  @override
  String get homeSelectBeneficiaryHint =>
      'Selecciona un beneficiario a continuación o inicia una transferencia.';

  @override
  String get homeSelectedBeneficiary => 'Beneficiario seleccionado';

  @override
  String get homeViewMoreTransactions => 'Ver más';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get homeExchangeRateSubtitle => 'Tipo de cambio';

  @override
  String get homeBeneficiaryLabel => 'BENEFICIARIO';

  @override
  String get exchangeRatesTitle => 'Tipos de cambio';

  @override
  String get exchangeRatesSearchHint => 'Buscar por país o moneda';

  @override
  String get exchangeRatesEmpty =>
      'Actualmente no hay tipos de cambio disponibles.';

  @override
  String get exchangeRatesNoSearchResult =>
      'Ningún tipo de cambio coincide con tu búsqueda.';

  @override
  String get exchangeRatesLoadError =>
      'No se pueden cargar los tipos de cambio.';

  @override
  String get exchangeRatesRefreshError =>
      'No se pueden actualizar los tipos de cambio.';

  @override
  String get exchangeRatesRetry => 'Intentar de nuevo';

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
  String get transferHistoryTitle => 'Transacciones';

  @override
  String get transferDetailTitle => 'Detalles de la transferencia';

  @override
  String get transferNotFound => 'No se ha encontrado esta transferencia.';

  @override
  String get transferStatusCreated => 'Creada';

  @override
  String get transferStatusPending => 'Pendiente';

  @override
  String get transferStatusProcessing => 'En proceso';

  @override
  String get transferStatusCompleted => 'Completada';

  @override
  String get transferStatusFailed => 'Fallida';

  @override
  String get transferStatusCancelled => 'Cancelada';

  @override
  String get transferStatusRefunded => 'Reembolsada';

  @override
  String get transferStatusUnknown => 'Estado desconocido';

  @override
  String get transferBeneficiary => 'Beneficiario';

  @override
  String get transferAllBeneficiaries => 'Todos los beneficiarios';

  @override
  String get transferStatusLabel => 'Estado';

  @override
  String get transferAllStatuses => 'Todos los estados';

  @override
  String get transferResetFilters => 'Restablecer filtros';

  @override
  String get transferCountLabel => 'Total de transacciones';

  @override
  String get transferSentTotalLabel => 'Total enviado por moneda';

  @override
  String get transferHistoryEmpty =>
      'Ninguna transferencia coincide con tu búsqueda.';

  @override
  String get transferLoadMore => 'Cargar más';

  @override
  String get transferRecipientName => 'Nombre';

  @override
  String get transferCountry => 'País';

  @override
  String get transferOperator => 'Operador';

  @override
  String get transferDestination => 'Destino';

  @override
  String get transferAmounts => 'Importes';

  @override
  String get transferSent => 'Importe enviado';

  @override
  String transferSentTo(String amount, String beneficiary) {
    return 'Has enviado $amount a $beneficiary';
  }

  @override
  String get transferFee => 'Comisiones';

  @override
  String get transferTotalCharged => 'Total cobrado';

  @override
  String get transferRate => 'Tipo aplicado';

  @override
  String get transferReceived => 'Importe a recibir';

  @override
  String get transferTracking => 'Seguimiento de la transferencia';

  @override
  String get transferReference => 'Referencia';

  @override
  String get transferCreatedAt => 'Creada el';

  @override
  String get transferExport => 'Exportar';

  @override
  String get transferReceiptAction => 'Ver/exportar recibo';

  @override
  String get transferRepeatAction => 'Repetir transferencia';

  @override
  String get transferProviderReference => 'Confirmación del operador';

  @override
  String get transferTotalAmount => 'Importe total';

  @override
  String get transferTimelineUnavailable =>
      'El seguimiento detallado no está disponible para esta transferencia.';

  @override
  String get transferTrackingCompleted =>
      'Los fondos se han entregado al beneficiario.';

  @override
  String get transferTrackingFailed =>
      'La transferencia ha fallado. El seguimiento disponible no especifica la situación del débito o del reembolso.';

  @override
  String get transferTrackingCancelled =>
      'La transferencia está cancelada. El seguimiento disponible no especifica la situación del débito o del reembolso.';

  @override
  String get transferTrackingRefunded =>
      'La transferencia aparece como reembolsada.';

  @override
  String get transferTrackingPending =>
      'La transferencia se está procesando. La recepción aún no se ha confirmado.';

  @override
  String get transferYearLabel => 'Año';

  @override
  String get transferAllYears => 'Todos los años';

  @override
  String get contactTitle => 'Beneficiarios';

  @override
  String get contactSearch => 'Introduce un nombre para buscar…';

  @override
  String get contactAdd => 'Añadir un beneficiario';

  @override
  String get contactSection => 'TUS BENEFICIARIOS';

  @override
  String get contactNew => 'Nuevo beneficiario';

  @override
  String get contactEdit => 'Editar beneficiario';

  @override
  String get contactInformation => 'Información del contacto';

  @override
  String get contactFullName => 'Nombre completo';

  @override
  String get contactPhone => 'Número de teléfono';

  @override
  String get contactPhoneConfirmation => 'Confirmar número de teléfono';

  @override
  String get contactPhoneMismatch => 'Los dos números no coinciden.';

  @override
  String get contactChooseDialCode => 'Elegir país y prefijo';

  @override
  String get contactCountry => 'País';

  @override
  String get contactOperator => 'Operador';

  @override
  String get contactGender => 'Género';

  @override
  String get contactMale => 'Hombre';

  @override
  String get contactFemale => 'Mujer';

  @override
  String get contactUnspecified => 'No especificado';

  @override
  String get contactSave => 'Guardar cambios';

  @override
  String get contactEmpty => 'No se encontraron beneficiarios.';

  @override
  String get contactNoPhone => 'Sin número de teléfono';

  @override
  String get contactChoose => 'Elegir';

  @override
  String get contactRequired => 'Campo obligatorio';

  @override
  String get contactNameTooLong => 'Máximo 120 caracteres';

  @override
  String get contactPhoneInvalid =>
      'Introduce el número con su prefijo internacional, p. ej., +237…';

  @override
  String get contactNoOperators =>
      'No hay operadores de dinero móvil disponibles.';

  @override
  String get contactNetworkError => 'Conexión no disponible. Comprueba tu red.';

  @override
  String get contactSessionError =>
      'Tu sesión ha caducado. Inicia sesión de nuevo.';

  @override
  String get contactInvalidError =>
      'Comprueba el teléfono, el país y el operador. Un contacto con varios destinos no puede cambiar de país aquí.';

  @override
  String get contactNotFoundError =>
      'Este beneficiario u operador ya no está disponible.';

  @override
  String get contactServerError =>
      'No se puede completar esta acción. Inténtalo de nuevo.';

  @override
  String get contactUnavailable =>
      'Este destino no se puede editar en el formulario de dinero móvil.';

  @override
  String get transferSendTitle => 'Enviar dinero';

  @override
  String get transferChooseBeneficiary => 'Elegir un beneficiario';

  @override
  String get transferYouSend => 'Tú envías';

  @override
  String get transferAmountReceived => 'Importe recibido';

  @override
  String get transferFundingLabel => 'Método de pago';

  @override
  String get transferFundingCard => 'Tarjeta bancaria';

  @override
  String get transferCurrentRate => 'Tipo de cambio';

  @override
  String get transferChooseForQuote =>
      'Elige un beneficiario para calcular el tipo y las comisiones.';

  @override
  String get transferContinue => 'Continuar';

  @override
  String get transferReviewTitle => 'Revisa tu transferencia';

  @override
  String get transferTrustWarning =>
      '¿Conoces a esta persona? Asegúrate de enviar dinero a alguien de confianza y de que sus datos sean correctos.';

  @override
  String get transferConfirm => 'Confirmar transferencia';

  @override
  String get transferInvalidError =>
      'Comprueba el beneficiario y el importe introducido.';

  @override
  String get transferBeneficiaryUnavailable =>
      'Este beneficiario o destino ya no está disponible.';

  @override
  String get transferConflictError =>
      'Esta transferencia ya se ha confirmado o ya no puede utilizarse.';

  @override
  String get transferQuoteExpired =>
      'El tipo ha caducado. Se calculará una nueva cotización.';

  @override
  String get transferUnavailableError =>
      'Esta transferencia no está disponible para este beneficiario o importe.';

  @override
  String get systemLanguage => 'Idioma del dispositivo';

  @override
  String get spanish => 'Español';

  @override
  String get mandarin => 'Chino mandarín';

  @override
  String get hindi => 'Hindi';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get currentPasswordRequired => 'Introduce tu contraseña actual';

  @override
  String get currentPasswordIncorrect => 'La contraseña actual es incorrecta.';

  @override
  String get newPasswordRequired => 'Introduce una nueva contraseña';

  @override
  String get newPasswordUnchanged =>
      'La nueva contraseña debe ser diferente de la contraseña actual.';

  @override
  String get confirmNewPasswordRequired => 'Confirma tu nueva contraseña';

  @override
  String get passwordChangeSessionInfo =>
      'Por tu seguridad, se cerrará la sesión en todos los demás dispositivos. Este dispositivo seguirá conectado.';

  @override
  String get changePasswordAction => 'Cambiar contraseña';

  @override
  String get passwordChangedTitle => 'Contraseña cambiada';

  @override
  String get passwordChangedMessage =>
      'Tu contraseña ha sido cambiada. Se ha cerrado la sesión en tus otros dispositivos.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get passwordLoginUnavailable =>
      'Esta cuenta utiliza un proveedor de acceso externo y no tiene una contraseña de PayFlow.';

  @override
  String get changePasswordNetworkError =>
      'No se puede cambiar la contraseña. Comprueba tu conexión.';

  @override
  String get changePasswordServerError =>
      'El servicio de cambio de contraseña no está disponible temporalmente.';

  @override
  String get changePasswordUnexpectedError =>
      'No se puede cambiar la contraseña en este momento.';
}
