import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/core/service/session_service.dart';

import '../support/biometric_fakes.dart';

void main() {
  late RecordingSecureStorage storage;
  late SessionService service;

  setUp(() {
    storage = RecordingSecureStorage()..seedSession();
    service = SessionService(secureStorage: storage);
  });

  test('startup reads metadata and denies token access until unlocked', () async {
    await service.initialize();
    expect(service.status, SessionStatus.refreshRequired);
    expect(storage.reads, isNot(contains(refreshTokenKey)));
    expect(() => service.readRefreshToken(), throwsStateError);
    service.authorizeSessionRestoration();
    expect(await service.readRefreshToken(), 'stored-refresh');
  });

  test('expired session is erased without reading its token', () async {
    storage.values[refreshExpiresAtKey] =
        DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
    await service.initialize();
    expect(service.status, SessionStatus.unauthenticated);
    expect(storage.reads, isNot(contains(refreshTokenKey)));
    expect(storage.values[refreshTokenKey], isNull);
    expect(() => service.authorizeSessionRestoration(), throwsStateError);
  });

  test('missing metadata clears an orphaned token without reading it', () async {
    storage.values.remove(sessionIdKey);
    await service.initialize();
    expect(service.status, SessionStatus.unauthenticated);
    expect(storage.values[refreshTokenKey], isNull);
    expect(storage.reads, isNot(contains(refreshTokenKey)));
  });

  test('active session survives initialization and access token stays in memory', () async {
    final session = testSession();
    await service.saveSession(session);
    await service.initialize();
    expect(service.currentSession, same(session));
    expect(service.isAuthenticated, isTrue);
    expect(storage.values.values, isNot(contains(session.accessToken)));
    await service.clearSession();
    expect(service.accessToken, isNull);
    expect(() => service.readRefreshToken(), throwsStateError);
  });
}
