import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/core/network/auth_interceptor.dart';
import 'package:pay_flow_ui/core/service/session_service.dart';
import 'package:pay_flow_ui/features/auth/domain/service/refresh_service.dart';

import '../support/biometric_fakes.dart';

class _UnauthorizedAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString('{}', 401,
    headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  test('a protected 401 cannot bypass startup biometric restoration', () async {
    final storage = RecordingSecureStorage()..seedSession();
    final session = SessionService(secureStorage: storage);
    await session.initialize();
    final repository = FakeRefreshRepository();
    final dio = Dio(BaseOptions(baseUrl: 'https://payflow.test'));
    dio.httpClientAdapter = _UnauthorizedAdapter();
    dio.interceptors.add(AuthInterceptor(
      dio: dio, sessionService: session,
      refreshService: RefreshService(authRepository: repository),
    ));
    addTearDown(() { dio.close(force: true); session.dispose(); });

    await expectLater(dio.get('/api/v1/transfer-quotes'), throwsA(isA<DioException>()));
    expect(repository.calls, 0);
    expect(storage.reads, isNot(contains(refreshTokenKey)));
    expect(session.status, SessionStatus.refreshRequired);
    expect(storage.values[refreshTokenKey], 'stored-refresh');
  });
}
