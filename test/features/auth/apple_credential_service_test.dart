import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:pay_flow_ui/features/auth/data/social/apple_credential_service.dart';
import 'package:pay_flow_ui/features/auth/data/social/social_credential_service.dart';

AuthorizationCredentialAppleID credential({String? token = 'signed-identity-token'}) =>
    AuthorizationCredentialAppleID(
      userIdentifier: 'apple-user', givenName: null, familyName: null,
      authorizationCode: 'authorization-code', email: null,
      identityToken: token, state: null,
    );

void main() {
  test('Apple returns a fresh nonce bound to the native request on each attempt', () async {
    final requested = <String>[];
    final apple = AppleCredentialService(
      platformSupported: true, isAvailable: () async => true,
      requestCredential: ({required nonce}) async {
        requested.add(nonce);
        return credential();
      },
    );
    final service = SocialCredentialService(appleCredentialService: apple);
    final first = await service.acquire('APPLE');
    final second = await service.acquire('apple');
    expect(first!.token, 'signed-identity-token');
    expect(first.expectedNonce, requested.first);
    expect(second!.expectedNonce, requested.last);
    expect(requested.first, matches(RegExp(r'^[a-f0-9]{64}$')));
    expect(requested.first, isNot(requested.last));
  });

  test('native cancellation returns no credential and permits another attempt', () async {
    var cancel = true;
    final apple = AppleCredentialService(
      platformSupported: true, isAvailable: () async => true,
      requestCredential: ({required nonce}) async {
        if (cancel) {
          throw const SignInWithAppleAuthorizationException(
            code: AuthorizationErrorCode.canceled, message: 'Canceled',
          );
        }
        return credential();
      },
    );
    expect(await apple.acquire(), isNull);
    cancel = false;
    expect((await apple.acquire())!.token, 'signed-identity-token');
  });

  test('missing signed identity token is refused even if Apple returns a user ID', () async {
    final apple = AppleCredentialService(
      platformSupported: true, isAvailable: () async => true,
      requestCredential: ({required nonce}) async => credential(token: null),
    );
    await expectLater(apple.acquire(), throwsStateError);
  });

  test('an unsupported platform never starts native authentication', () async {
    var calls = 0;
    final apple = AppleCredentialService(
      platformSupported: false, isAvailable: () async => true,
      requestCredential: ({required nonce}) async { calls++; return credential(); },
    );
    await expectLater(apple.acquire(), throwsUnsupportedError);
    expect(calls, 0);
  });

  test('an unavailable device never starts native authentication', () async {
    var calls = 0;
    final apple = AppleCredentialService(
      platformSupported: true, isAvailable: () async => false,
      requestCredential: ({required nonce}) async { calls++; return credential(); },
    );
    await expectLater(apple.acquire(), throwsUnsupportedError);
    expect(calls, 0);
  });

  test('duplicate attempts do not open concurrent Apple authorization sheets', () async {
    final pending = Completer<AuthorizationCredentialAppleID>();
    var calls = 0;
    final apple = AppleCredentialService(
      platformSupported: true, isAvailable: () async => true,
      requestCredential: ({required nonce}) { calls++; return pending.future; },
    );
    final first = apple.acquire();
    await Future<void>.delayed(Duration.zero);
    expect(await apple.acquire(), isNull);
    expect(calls, 1);
    pending.complete(credential());
    expect((await first)!.token, 'signed-identity-token');
  });
}
