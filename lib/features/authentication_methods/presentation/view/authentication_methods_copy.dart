import 'package:flutter/widgets.dart';

class AuthenticationMethodsCopy {
  final String title;
  final String identifiers;
  final String linkedAccounts;
  final String email;
  final String phone;
  final String verified;
  final String verify;
  final String linked;
  final String notLinked;
  final String providersLater;
  final String error;

  const AuthenticationMethodsCopy({
    required this.title,
    required this.identifiers,
    required this.linkedAccounts,
    required this.email,
    required this.phone,
    required this.verified,
    required this.verify,
    required this.linked,
    required this.notLinked,
    required this.providersLater,
    required this.error,
  });

  static AuthenticationMethodsCopy of(BuildContext context) {
    return values[Localizations.localeOf(context).languageCode] ??
        values['fr']!;
  }

  static const values = <String, AuthenticationMethodsCopy>{
    'fr': AuthenticationMethodsCopy(
      title: 'Moyens de connexion',
      identifiers: 'IDENTIFIANTS PAYFLOW',
      linkedAccounts: 'COMPTES ASSOCIÉS',
      email: 'Adresse e-mail',
      phone: 'Numéro de téléphone',
      verified: 'Vérifié',
      verify: 'Vérifier',
      linked: 'Lié',
      notLinked: 'Non lié',
      providersLater: 'La liaison sera activée avec le fournisseur.',
      error: 'Impossible de charger vos moyens de connexion.',
    ),
    'en': AuthenticationMethodsCopy(
      title: 'Sign-in methods',
      identifiers: 'PAYFLOW IDENTIFIERS',
      linkedAccounts: 'LINKED ACCOUNTS',
      email: 'Email address',
      phone: 'Phone number',
      verified: 'Verified',
      verify: 'Verify',
      linked: 'Linked',
      notLinked: 'Not linked',
      providersLater: 'Linking will be enabled with the provider.',
      error: 'Unable to load your sign-in methods.',
    ),
    'es': AuthenticationMethodsCopy(
      title: 'Métodos de acceso',
      identifiers: 'IDENTIFICADORES PAYFLOW',
      linkedAccounts: 'CUENTAS VINCULADAS',
      email: 'Correo electrónico',
      phone: 'Número de teléfono',
      verified: 'Verificado',
      verify: 'Verificar',
      linked: 'Vinculado',
      notLinked: 'No vinculado',
      providersLater: 'La vinculación se activará con el proveedor.',
      error: 'No se pueden cargar los métodos de acceso.',
    ),
    'zh': AuthenticationMethodsCopy(
      title: '登录方式',
      identifiers: 'PAYFLOW登录信息',
      linkedAccounts: '关联账户',
      email: '电子邮箱',
      phone: '手机号码',
      verified: '已验证',
      verify: '验证',
      linked: '已关联',
      notLinked: '未关联',
      providersLater: '提供商配置完成后可进行关联。',
      error: '无法加载登录方式。',
    ),
    'hi': AuthenticationMethodsCopy(
      title: 'साइन-इन के तरीके',
      identifiers: 'PAYFLOW पहचान',
      linkedAccounts: 'जुड़े खाते',
      email: 'ईमेल पता',
      phone: 'फ़ोन नंबर',
      verified: 'सत्यापित',
      verify: 'सत्यापित करें',
      linked: 'जुड़ा हुआ',
      notLinked: 'नहीं जुड़ा',
      providersLater: 'प्रदाता सक्षम होने पर खाता जोड़ा जा सकेगा।',
      error: 'साइन-इन के तरीके लोड नहीं हो सके।',
    ),
  };
}
