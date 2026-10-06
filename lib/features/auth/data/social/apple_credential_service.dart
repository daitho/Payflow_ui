import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'social_credential.dart';

typedef AppleCredentialRequest = Future<AuthorizationCredentialAppleID> Function({
  required String nonce,
});

/// The signed identity token is verified by PayFlow's backend. Neither a local
/// Apple user ID nor the returned email is sufficient to link an account.
class AppleCredentialService {
  final Future<bool> Function() _isAvailable;
  final AppleCredentialRequest _requestCredential;
  final bool _platformSupported;
  bool _inProgress = false;

  AppleCredentialService({
    Future<bool> Function()? isAvailable,
    AppleCredentialRequest? requestCredential,
    bool? platformSupported,
  }) : _isAvailable = isAvailable ?? SignInWithApple.isAvailable,
       _requestCredential = requestCredential ?? _requestNativeCredential,
       _platformSupported = platformSupported ?? supportsPlatform;

  static bool get supportsPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static Future<AuthorizationCredentialAppleID> _requestNativeCredential({
    required String nonce,
  }) => SignInWithApple.getAppleIDCredential(
    scopes: [AppleIDAuthorizationScopes.email],
    nonce: nonce,
  );

  Future<SocialCredential?> acquire() async {
    if (_inProgress) return null;
    if (!_platformSupported) {
      throw UnsupportedError('Connexion Apple disponible sur iPhone et iPad.');
    }
    _inProgress = true;
    try {
      if (!await _isAvailable()) {
        throw UnsupportedError('Connexion Apple indisponible sur cet appareil.');
      }
      final random = Random.secure();
      final rawNonce = base64Url.encode(
        List<int>.generate(32, (_) => random.nextInt(256)),
      ).replaceAll('=', '');
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();
      final credential = await _requestCredential(nonce: nonce);
      final token = credential.identityToken;
      if (token == null || token.trim().isEmpty) {
        throw StateError('Apple n’a pas renvoyé de preuve de connexion. Réessaie.');
      }
      // Apple's nonce claim matches the exact hash supplied to the native SDK.
      // The existing backend compares it with expectedNonce after JWT validation.
      return SocialCredential(token, expectedNonce: nonce);
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) return null;
      throw StateError('Connexion Apple impossible. Réessaie.');
    } finally {
      _inProgress = false;
    }
  }
}
