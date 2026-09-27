import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialCredential {
  final String token;
  final String? expectedNonce;

  const SocialCredential(this.token, {this.expectedNonce});
}

/// Obtains a short-lived provider credential. Never persist or log these tokens.
class SocialCredentialService {
  SocialCredentialService._();
  static final instance = SocialCredentialService._();

  static const googleIosClientId =
      '1007248328587-5bjni9adknn56hh8oqd96hkppvs7032d.apps.googleusercontent.com';
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '1007248328587-p36mvuiqe2u4343nn6nr1u674hdki7fq.apps.googleusercontent.com',
  );
  bool _googleInitialized = false;

  Future<SocialCredential?> acquire(String provider) async {
    switch (provider.toUpperCase()) {
      case 'GOOGLE':
        if (googleWebClientId.isEmpty) {
          throw StateError('GOOGLE_WEB_CLIENT_ID manquant');
        }
        final signIn = GoogleSignIn.instance;
        if (!_googleInitialized) {
          await signIn.initialize(
            clientId: !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
                ? googleIosClientId
                : null,
            serverClientId: googleWebClientId,
          );
          _googleInitialized = true;
        }
        if (!signIn.supportsAuthenticate()) {
          throw UnsupportedError('Connexion Google indisponible sur cette plateforme');
        }
        try {
          final account = await signIn.authenticate();
          return SocialCredential(account.authentication.idToken ??
              (throw StateError('Jeton Google absent')));
        } on GoogleSignInException catch (error) {
          if (error.code == GoogleSignInExceptionCode.canceled) return null;
          rethrow;
        }
      case 'FACEBOOK':
        if (kIsWeb) throw UnsupportedError('Connexion Facebook mobile uniquement');
        // A fresh login prevents reusing a token from a different Facebook account.
        await FacebookAuth.instance.logOut();
        final random = Random.secure();
        final nonce = base64Url.encode(
          List<int>.generate(32, (_) => random.nextInt(256)),
        ).replaceAll('=', '');
        final result = await FacebookAuth.instance.login(
          permissions: ['public_profile', 'email'],
          loginTracking: defaultTargetPlatform == TargetPlatform.iOS
              ? LoginTracking.limited
              : LoginTracking.enabled,
          nonce: nonce,
        );
        if (result.status == LoginStatus.cancelled) return null;
        if (result.status != LoginStatus.success) {
          throw StateError(result.message ?? 'Connexion Facebook échouée');
        }
        final token = result.accessToken;
        if (token is LimitedToken) {
          return SocialCredential(token.tokenString, expectedNonce: nonce);
        }
        if (token is ClassicToken) {
          return SocialCredential(token.tokenString);
        }
        throw StateError('Jeton Facebook absent');
      default:
        throw UnsupportedError('Fournisseur indisponible');
    }
  }
}
