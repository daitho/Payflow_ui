import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/auth/data/dto/refresh_request_dto.dart';
import 'package:pay_flow_ui/features/auth/data/service_api/auth_api_service.dart';
import 'package:pay_flow_ui/features/auth/domain/exception/session_expired_exception.dart';

class _RefreshAdapter implements HttpClientAdapter {
  int status = 404;
  Object body = {'status': 404, 'error': 'Not Found'};
  bool timeout = false;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    request = options;
    if (timeout) {
      throw DioException(requestOptions: options,
          type: DioExceptionType.receiveTimeout);
    }
    return ResponseBody.fromString(body is String ? body as String : jsonEncode(body),
        status, headers: {
          Headers.contentTypeHeader: [body is String ? 'text/html' : Headers.jsonContentType],
        });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _RefreshAdapter adapter;
  late AuthApiService api;
  late DebugPrintCallback originalDebugPrint;
  late List<String> messages;
  const request = RefreshRequestDto(refreshToken: 'refresh-secret-do-not-log');

  setUp(() {
    adapter = _RefreshAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://payflow.example'))
      ..httpClientAdapter = adapter;
    api = AuthApiService(dio: dio);
    messages = [];
    originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) messages.add(message);
    };
  });
  tearDown(() {
    debugPrint = originalDebugPrint;
    dio.close(force: true);
  });

  test('401 invalid refresh returns to login', () async {
    adapter.status = 401;
    adapter.body = {'code': 'SESSION_001'};
    await expectLater(api.refresh(request), throwsA(isA<SessionExpiredException>()));
    expect(adapter.request!.path, '/api/v1/auth/refresh');
  });

  test('404 missing session account returns to login', () async {
    adapter.body = {'code': 'SESSION_007', 'message': 'Utilisateur introuvable.'};
    await expectLater(api.refresh(request), throwsA(isA<SessionExpiredException>()));
  });

  for (final body in <Object>[
    {'status': 404, 'error': 'Not Found'},
    '<html>ERR_NGROK_3200</html>',
    {'code': 'UNKNOWN_404'},
  ]) {
    test('route/proxy 404 preserves the technical error: $body', () async {
      adapter.body = body;
      await expectLater(api.refresh(request), throwsA(isA<DioException>()
          .having((e) => e.response?.statusCode, 'status', 404)));
    });
  }

  test('server failure with a misleading code is not session expiration', () async {
    adapter.status = 500;
    adapter.body = {'code': 'SESSION_007'};
    await expectLater(api.refresh(request), throwsA(isA<DioException>()));
  });

  test('network timeout is not session expiration', () async {
    adapter.timeout = true;
    await expectLater(api.refresh(request), throwsA(isA<DioException>()
        .having((e) => e.type, 'type', DioExceptionType.receiveTimeout)));
  });

  test('diagnostics expose endpoint/status but omit all credentials and payloads', () async {
    dio.options.baseUrl = 'https://user:base-url-password@payflow.example';
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.queryParameters['token'] = 'query-secret';
      options.headers['Authorization'] = 'Bearer header-secret';
      handler.next(options);
    }));
    adapter.body = {'code': 'SESSION_007', 'message': 'response-secret'};
    await expectLater(api.refresh(request), throwsA(isA<SessionExpiredException>()));
    final diagnostic = messages.join('\n');
    expect(diagnostic, contains('POST https://payflow.example/api/v1/auth/refresh'));
    expect(diagnostic, contains('status=404 code=SESSION_007'));
    for (final secret in ['refresh-secret-do-not-log', 'base-url-password',
      'query-secret', 'header-secret', 'response-secret']) {
      expect(diagnostic, isNot(contains(secret)));
    }
  });

  test('a valid session response still returns the rotated refresh token', () async {
    adapter.status = 200;
    adapter.body = {
      'tokenType': 'Bearer', 'accessToken': 'new-access',
      'accessExpiresAt': '2026-10-20T08:10:00Z', 'refreshToken': 'rotated-refresh',
      'refreshExpiresAt': '2026-10-27T08:00:00Z', 'sessionId': 'session',
      'user': {'id': 'user', 'publicId': 'public', 'email': 'test@example.com',
        'lastName': 'Test', 'role': 'USER', 'status': 'ACTIF', 'verified': true},
    };
    final result = await api.refresh(request);
    expect(result.refreshToken, 'rotated-refresh');
    expect(result.accessToken, 'new-access');
    expect(messages, isEmpty);
  });
}
