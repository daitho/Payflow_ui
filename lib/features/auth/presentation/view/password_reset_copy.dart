import 'package:flutter/widgets.dart';

class PasswordResetCopy {
  final String requestTitle;
  final String requestSubtitle;
  final String identifierHint;
  final String continueLabel;
  final String codeTitle;
  final String codeSent;
  final String verify;
  final String resend;
  final String resendIn;
  final String securityNote;
  final String newPasswordTitle;
  final String newPasswordSubtitle;
  final String newPasswordHint;
  final String confirmationHint;
  final String passwordRules;
  final String savePassword;
  final String success;
  final String identifierRequired;
  final String invalidCode;
  final String expiredCode;
  final String tooManyAttempts;
  final String channelUnavailable;
  final String invalidToken;
  final String weakPassword;
  final String passwordMismatch;
  final String passwordUnchanged;
  final String networkError;
  final String unexpectedError;

  const PasswordResetCopy({
    required this.requestTitle,
    required this.requestSubtitle,
    required this.identifierHint,
    required this.continueLabel,
    required this.codeTitle,
    required this.codeSent,
    required this.verify,
    required this.resend,
    required this.resendIn,
    required this.securityNote,
    required this.newPasswordTitle,
    required this.newPasswordSubtitle,
    required this.newPasswordHint,
    required this.confirmationHint,
    required this.passwordRules,
    required this.savePassword,
    required this.success,
    required this.identifierRequired,
    required this.invalidCode,
    required this.expiredCode,
    required this.tooManyAttempts,
    required this.channelUnavailable,
    required this.invalidToken,
    required this.weakPassword,
    required this.passwordMismatch,
    required this.passwordUnchanged,
    required this.networkError,
    required this.unexpectedError,
  });

  static PasswordResetCopy of(BuildContext context) {
    return _values[Localizations.localeOf(context).languageCode] ??
        _values['fr']!;
  }

  static const _values = <String, PasswordResetCopy>{
    'fr': PasswordResetCopy(
      requestTitle: 'Mot de passe oublié',
      requestSubtitle:
          "Saisissez l'e-mail ou le numéro vérifié associé à votre compte.",
      identifierHint: 'E-mail ou numéro de téléphone',
      continueLabel: 'Continuer',
      codeTitle: 'Saisissez votre code',
      codeSent:
          'Si cet identifiant correspond à un compte vérifié, un code a été envoyé à',
      verify: 'Vérifier le code',
      resend: 'Renvoyer le code',
      resendIn: 'Renvoyer dans',
      securityNote:
          'Ne communiquez jamais ce code, même à un conseiller PayFlow.',
      newPasswordTitle: 'Nouveau mot de passe',
      newPasswordSubtitle:
          'Choisissez un mot de passe différent de celui utilisé actuellement.',
      newPasswordHint: 'Nouveau mot de passe',
      confirmationHint: 'Confirmer le mot de passe',
      passwordRules:
          '12 caractères minimum, avec majuscule, minuscule, chiffre et caractère spécial.',
      savePassword: 'Enregistrer le mot de passe',
      success:
          'Votre mot de passe a été modifié. Vous pouvez vous connecter.',
      identifierRequired: 'Saisissez votre e-mail ou votre numéro.',
      invalidCode: 'Le code saisi est incorrect.',
      expiredCode: 'Ce code a expiré. Demandez-en un nouveau.',
      tooManyAttempts: 'Trop de tentatives. Demandez un nouveau code.',
      channelUnavailable: 'Ce mode de réception est indisponible.',
      invalidToken: 'Cette demande n’est plus valide. Recommencez.',
      weakPassword: 'Le mot de passe ne respecte pas les règles de sécurité.',
      passwordMismatch: 'Les deux mots de passe ne correspondent pas.',
      passwordUnchanged: 'Choisissez un mot de passe différent de l’ancien.',
      networkError: 'Vérifiez votre connexion internet.',
      unexpectedError: 'Une erreur est survenue. Réessayez.',
    ),
    'en': PasswordResetCopy(
      requestTitle: 'Forgot password',
      requestSubtitle:
          'Enter the verified email or phone number linked to your account.',
      identifierHint: 'Email or phone number',
      continueLabel: 'Continue',
      codeTitle: 'Enter your code',
      codeSent:
          'If this identifier matches a verified account, a code was sent to',
      verify: 'Verify code',
      resend: 'Resend code',
      resendIn: 'Resend in',
      securityNote: 'Never share this code, even with a PayFlow adviser.',
      newPasswordTitle: 'New password',
      newPasswordSubtitle:
          'Choose a password different from the one you currently use.',
      newPasswordHint: 'New password',
      confirmationHint: 'Confirm password',
      passwordRules:
          'At least 12 characters with uppercase, lowercase, a number and a special character.',
      savePassword: 'Save password',
      success: 'Your password was changed. You can now sign in.',
      identifierRequired: 'Enter your email or phone number.',
      invalidCode: 'The code is incorrect.',
      expiredCode: 'This code has expired. Request a new one.',
      tooManyAttempts: 'Too many attempts. Request a new code.',
      channelUnavailable: 'This delivery method is unavailable.',
      invalidToken: 'This request is no longer valid. Start again.',
      weakPassword: 'The password does not meet the security rules.',
      passwordMismatch: 'The passwords do not match.',
      passwordUnchanged: 'Choose a password different from the old one.',
      networkError: 'Check your internet connection.',
      unexpectedError: 'Something went wrong. Try again.',
    ),
    'es': PasswordResetCopy(
      requestTitle: 'Contraseña olvidada',
      requestSubtitle:
          'Introduce el correo o teléfono verificado asociado a tu cuenta.',
      identifierHint: 'Correo o número de teléfono',
      continueLabel: 'Continuar',
      codeTitle: 'Introduce tu código',
      codeSent:
          'Si el identificador corresponde a una cuenta verificada, enviamos un código a',
      verify: 'Verificar el código',
      resend: 'Reenviar el código',
      resendIn: 'Reenviar en',
      securityNote: 'Nunca compartas este código, ni siquiera con PayFlow.',
      newPasswordTitle: 'Nueva contraseña',
      newPasswordSubtitle: 'Elige una contraseña diferente de la actual.',
      newPasswordHint: 'Nueva contraseña',
      confirmationHint: 'Confirmar contraseña',
      passwordRules:
          'Mínimo 12 caracteres, con mayúscula, minúscula, número y carácter especial.',
      savePassword: 'Guardar contraseña',
      success: 'Tu contraseña se modificó. Ya puedes iniciar sesión.',
      identifierRequired: 'Introduce tu correo o teléfono.',
      invalidCode: 'El código es incorrecto.',
      expiredCode: 'El código ha caducado. Solicita otro.',
      tooManyAttempts: 'Demasiados intentos. Solicita otro código.',
      channelUnavailable: 'Este método de envío no está disponible.',
      invalidToken: 'La solicitud ya no es válida. Empieza de nuevo.',
      weakPassword: 'La contraseña no cumple las reglas de seguridad.',
      passwordMismatch: 'Las contraseñas no coinciden.',
      passwordUnchanged: 'Elige una contraseña diferente de la anterior.',
      networkError: 'Comprueba tu conexión a internet.',
      unexpectedError: 'Se produjo un error. Inténtalo de nuevo.',
    ),
    'zh': PasswordResetCopy(
      requestTitle: '忘记密码',
      requestSubtitle: '请输入与账户关联且已验证的邮箱或手机号码。',
      identifierHint: '邮箱或手机号码',
      continueLabel: '继续',
      codeTitle: '输入验证码',
      codeSent: '如果该标识对应已验证账户，验证码已发送至',
      verify: '验证',
      resend: '重新发送验证码',
      resendIn: '重新发送倒计时',
      securityNote: '切勿向任何人透露此验证码，包括 PayFlow 工作人员。',
      newPasswordTitle: '新密码',
      newPasswordSubtitle: '请选择与当前密码不同的新密码。',
      newPasswordHint: '新密码',
      confirmationHint: '确认密码',
      passwordRules: '至少 12 个字符，包含大小写字母、数字和特殊字符。',
      savePassword: '保存密码',
      success: '密码已修改，现在可以登录。',
      identifierRequired: '请输入邮箱或手机号码。',
      invalidCode: '验证码不正确。',
      expiredCode: '验证码已过期，请重新获取。',
      tooManyAttempts: '尝试次数过多，请获取新验证码。',
      channelUnavailable: '此接收方式暂不可用。',
      invalidToken: '此请求已失效，请重新开始。',
      weakPassword: '密码不符合安全要求。',
      passwordMismatch: '两次输入的密码不一致。',
      passwordUnchanged: '新密码必须与旧密码不同。',
      networkError: '请检查网络连接。',
      unexpectedError: '发生错误，请重试。',
    ),
    'hi': PasswordResetCopy(
      requestTitle: 'पासवर्ड भूल गए',
      requestSubtitle:
          'अपने खाते से जुड़ा सत्यापित ईमेल या फ़ोन नंबर दर्ज करें।',
      identifierHint: 'ईमेल या फ़ोन नंबर',
      continueLabel: 'जारी रखें',
      codeTitle: 'अपना कोड दर्ज करें',
      codeSent:
          'यदि यह पहचानकर्ता सत्यापित खाते से जुड़ा है, तो कोड भेजा गया है',
      verify: 'कोड सत्यापित करें',
      resend: 'कोड दोबारा भेजें',
      resendIn: 'दोबारा भेजें',
      securityNote: 'यह कोड किसी से साझा न करें, PayFlow सलाहकार से भी नहीं।',
      newPasswordTitle: 'नया पासवर्ड',
      newPasswordSubtitle: 'मौजूदा पासवर्ड से अलग पासवर्ड चुनें।',
      newPasswordHint: 'नया पासवर्ड',
      confirmationHint: 'पासवर्ड की पुष्टि करें',
      passwordRules:
          'कम से कम 12 अक्षर, बड़े और छोटे अक्षर, अंक और विशेष चिह्न शामिल हों।',
      savePassword: 'पासवर्ड सहेजें',
      success: 'आपका पासवर्ड बदल गया है। अब आप साइन इन कर सकते हैं।',
      identifierRequired: 'अपना ईमेल या फ़ोन नंबर दर्ज करें।',
      invalidCode: 'कोड सही नहीं है।',
      expiredCode: 'कोड की अवधि समाप्त हो गई है। नया कोड लें।',
      tooManyAttempts: 'बहुत अधिक प्रयास। नया कोड लें।',
      channelUnavailable: 'यह माध्यम उपलब्ध नहीं है।',
      invalidToken: 'यह अनुरोध अब मान्य नहीं है। फिर से शुरू करें।',
      weakPassword: 'पासवर्ड सुरक्षा नियमों को पूरा नहीं करता।',
      passwordMismatch: 'दोनों पासवर्ड मेल नहीं खाते।',
      passwordUnchanged: 'पुराने पासवर्ड से अलग पासवर्ड चुनें।',
      networkError: 'अपना इंटरनेट कनेक्शन जाँचें।',
      unexpectedError: 'एक त्रुटि हुई। फिर प्रयास करें।',
    ),
  };
}
