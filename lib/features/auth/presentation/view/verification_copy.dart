import 'package:flutter/widgets.dart';

class VerificationCopy {
  final String emailTitle;
  final String phoneTitle;
  final String sentTo;
  final String confirm;
  final String resend;
  final String resendIn;
  final String useEmail;
  final String usePhone;
  final String invalidCode;
  final String expired;
  final String tooManyAttempts;
  final String channelUnavailable;
  final String networkError;
  final String unexpectedError;
  final String securityNote;
  final String recoveryTitle;
  final String recoveryMessage;
  final String recoveryAction;
  final String cancel;

  const VerificationCopy({
    required this.emailTitle,
    required this.phoneTitle,
    required this.sentTo,
    required this.confirm,
    required this.resend,
    required this.resendIn,
    required this.useEmail,
    required this.usePhone,
    required this.invalidCode,
    required this.expired,
    required this.tooManyAttempts,
    required this.channelUnavailable,
    required this.networkError,
    required this.unexpectedError,
    required this.securityNote,
    required this.recoveryTitle,
    required this.recoveryMessage,
    required this.recoveryAction,
    required this.cancel,
  });

  static VerificationCopy of(BuildContext context) {
    return _values[
          Localizations.localeOf(context).languageCode
        ] ??
        _values['fr']!;
  }

  static const _values = <String, VerificationCopy>{
    'fr': VerificationCopy(
      emailTitle: 'Vérifiez votre adresse e-mail',
      phoneTitle: 'Vérifiez votre numéro',
      sentTo: 'Nous avons envoyé un code à',
      confirm: 'Confirmer',
      resend: 'Renvoyer le code',
      resendIn: 'Renvoyer dans',
      useEmail: 'Recevoir plutôt par e-mail',
      usePhone: 'Recevoir plutôt par SMS',
      invalidCode: 'Le code saisi est incorrect.',
      expired: 'Ce code a expiré. Demandez-en un nouveau.',
      tooManyAttempts: 'Trop de tentatives. Demandez un nouveau code.',
      channelUnavailable: 'Ce mode de réception est indisponible.',
      networkError: 'Vérifiez votre connexion internet.',
      unexpectedError: 'Une erreur est survenue. Réessayez.',
      securityNote: 'Ne communiquez jamais ce code, même à un conseiller PayFlow.',
      recoveryTitle: 'Vérification nécessaire',
      recoveryMessage: "Cet identifiant n'est pas encore vérifié. Reprenez la vérification pour vous connecter.",
      recoveryAction: 'Reprendre la vérification',
      cancel: 'Annuler',
    ),
    'en': VerificationCopy(
      emailTitle: 'Verify your email address',
      phoneTitle: 'Verify your phone number',
      sentTo: 'We sent a code to',
      confirm: 'Confirm',
      resend: 'Resend code',
      resendIn: 'Resend in',
      useEmail: 'Receive by email instead',
      usePhone: 'Receive by SMS instead',
      invalidCode: 'The code is incorrect.',
      expired: 'This code has expired. Request a new one.',
      tooManyAttempts: 'Too many attempts. Request a new code.',
      channelUnavailable: 'This delivery method is unavailable.',
      networkError: 'Check your internet connection.',
      unexpectedError: 'Something went wrong. Try again.',
      securityNote: 'Never share this code, even with a PayFlow adviser.',
      recoveryTitle: 'Verification required',
      recoveryMessage: 'This identifier has not been verified. Resume verification to sign in.',
      recoveryAction: 'Resume verification',
      cancel: 'Cancel',
    ),
    'es': VerificationCopy(
      emailTitle: 'Verifica tu correo electrónico',
      phoneTitle: 'Verifica tu número',
      sentTo: 'Hemos enviado un código a',
      confirm: 'Confirmar',
      resend: 'Reenviar el código',
      resendIn: 'Reenviar en',
      useEmail: 'Recibir por correo electrónico',
      usePhone: 'Recibir por SMS',
      invalidCode: 'El código es incorrecto.',
      expired: 'El código ha caducado. Solicita uno nuevo.',
      tooManyAttempts: 'Demasiados intentos. Solicita otro código.',
      channelUnavailable: 'Este método de envío no está disponible.',
      networkError: 'Comprueba tu conexión a internet.',
      unexpectedError: 'Se produjo un error. Inténtalo de nuevo.',
      securityNote: 'Nunca compartas este código, ni siquiera con PayFlow.',
      recoveryTitle: 'Verificación necesaria',
      recoveryMessage: 'Este identificador no está verificado. Reanuda la verificación para iniciar sesión.',
      recoveryAction: 'Reanudar',
      cancel: 'Cancelar',
    ),
    'zh': VerificationCopy(
      emailTitle: '验证电子邮箱',
      phoneTitle: '验证手机号码',
      sentTo: '验证码已发送至',
      confirm: '确认',
      resend: '重新发送验证码',
      resendIn: '重新发送倒计时',
      useEmail: '改用电子邮件接收',
      usePhone: '改用短信接收',
      invalidCode: '验证码不正确。',
      expired: '验证码已过期，请重新获取。',
      tooManyAttempts: '尝试次数过多，请获取新验证码。',
      channelUnavailable: '此接收方式暂不可用。',
      networkError: '请检查您的网络连接。',
      unexpectedError: '发生错误，请重试。',
      securityNote: '切勿向任何人透露此验证码，包括PayFlow工作人员。',
      recoveryTitle: '需要验证',
      recoveryMessage: '此登录标识尚未验证。请继续验证后登录。',
      recoveryAction: '继续验证',
      cancel: '取消',
    ),
    'hi': VerificationCopy(
      emailTitle: 'अपना ईमेल सत्यापित करें',
      phoneTitle: 'अपना फ़ोन नंबर सत्यापित करें',
      sentTo: 'हमने कोड यहाँ भेजा है',
      confirm: 'पुष्टि करें',
      resend: 'कोड दोबारा भेजें',
      resendIn: 'दोबारा भेजें',
      useEmail: 'ईमेल से प्राप्त करें',
      usePhone: 'SMS से प्राप्त करें',
      invalidCode: 'कोड सही नहीं है।',
      expired: 'कोड की अवधि समाप्त हो गई है। नया कोड लें।',
      tooManyAttempts: 'बहुत अधिक प्रयास। नया कोड लें।',
      channelUnavailable: 'यह माध्यम उपलब्ध नहीं है।',
      networkError: 'अपना इंटरनेट कनेक्शन जाँचें।',
      unexpectedError: 'एक त्रुटि हुई। फिर प्रयास करें।',
      securityNote: 'यह कोड किसी से साझा न करें, PayFlow सलाहकार से भी नहीं।',
      recoveryTitle: 'सत्यापन आवश्यक है',
      recoveryMessage: 'यह पहचानकर्ता सत्यापित नहीं है। साइन इन करने के लिए सत्यापन जारी रखें।',
      recoveryAction: 'सत्यापन जारी रखें',
      cancel: 'रद्द करें',
    ),
  };
}
