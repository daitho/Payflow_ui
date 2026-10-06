import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/auth/data/service_api/auth_api_service.dart';
import 'package:pay_flow_ui/features/authentication_methods/data/service_api/linked_provider_api_service.dart';
import 'package:pay_flow_ui/features/authentication_methods/domain/model/linked_provider.dart';

class _Adapter implements HttpClientAdapter {
  RequestOptions? request;
  bool linking = false;
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    request = options;
    final data = linking ? {
      'provider': 'APPLE', 'linked': true, 'available': true,
      'providerEmail': 'alias@privaterelay.appleid.com', 'linkedAt': '2026-10-06T08:00:00Z',
    } : {
      'tokenType': 'Bearer', 'accessToken': 'access',
      'accessExpiresAt': '2026-10-06T08:10:00Z', 'refreshToken': 'refresh',
      'refreshExpiresAt': '2026-10-13T08:00:00Z', 'sessionId': 'session',
      'user': {'id': 'user', 'publicId': 'public', 'email': 'payflow@test.example',
        'lastName': 'Test', 'role': 'USER', 'status': 'ACTIF', 'verified': true},
    };
    return ResponseBody.fromString(jsonEncode(data), 200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
  }
  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _Adapter adapter;
  setUp(() {
    adapter = _Adapter();
    dio = Dio(BaseOptions(baseUrl: 'https://payflow.test'))..httpClientAdapter = adapter;
  });
  tearDown(() => dio.close(force: true));

  test('Apple login sends idToken and nonce to the existing Apple endpoint', () async {
    await AuthApiService(dio: dio).socialLogin(provider: 'apple',
      credential: 'apple-proof', expectedNonce: 'nonce', deviceId: 'device', deviceName: 'iPhone');
    expect(adapter.request!.path, '/api/v1/auth/oauth/apple');
    expect(adapter.request!.data, {
      'idToken': 'apple-proof', 'expectedNonce': 'nonce',
      'deviceId': 'device', 'deviceName': 'iPhone',
    });
  });

  test('Apple login cannot submit a token without the native nonce', () async {
    await expectLater(AuthApiService(dio: dio).socialLogin(provider: 'APPLE',
      credential: 'proof', deviceId: 'device', deviceName: 'iPhone'), throwsStateError);
    expect(adapter.request, isNull);
  });

  test('Apple linking sends the current PayFlow password, signed token and nonce', () async {
    adapter.linking = true;
    final linked = await LinkedProviderApiService(dio).link(
      provider: ExternalProvider.apple, credential: 'apple-proof',
      currentPassword: 'current-password', expectedNonce: 'nonce',
    );
    expect(adapter.request!.path, '/api/v1/account/external-identities/APPLE');
    expect(adapter.request!.data, {
      'credential': 'apple-proof', 'currentPassword': 'current-password',
      'expectedNonce': 'nonce',
    });
    expect(linked.linked, isTrue);
  });

  for (final provider in ['GOOGLE', 'FACEBOOK']) {
    test('$provider retains its original credential field', () async {
      await AuthApiService(dio: dio).socialLogin(provider: provider,
        credential: 'proof', deviceId: 'device', deviceName: 'phone');
      final body = adapter.request!.data as Map;
      expect(body[provider == 'GOOGLE' ? 'idToken' : 'accessToken'], 'proof');
      expect(body.containsKey('expectedNonce'), isFalse);
    });
  }
}
