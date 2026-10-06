import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pay_flow_ui/core/service/biometric_service.dart';
import 'package:pay_flow_ui/core/service/session_service.dart';
import 'package:pay_flow_ui/features/auth/domain/exception/session_expired_exception.dart';
import 'package:pay_flow_ui/features/auth/domain/service/refresh_service.dart';
import 'package:pay_flow_ui/features/auth/presentation/view_model/splash_view_model.dart';

import '../../support/biometric_fakes.dart';

void main() {
  late RecordingSecureStorage storage;
  late FakeLocalAuthentication localAuth;
  late FakeRefreshRepository repository;
  late SessionService session;
  late SplashViewModel vm;

  setUp(() {
    storage = RecordingSecureStorage()..seedSession();
    localAuth = FakeLocalAuthentication();
    repository = FakeRefreshRepository();
    session = SessionService(secureStorage: storage);
    vm = SplashViewModel(
      sessionService: session,
      refreshService: RefreshService(authRepository: repository),
      biometricService: BiometricService(
        secureStorage: storage, localAuthentication: localAuth,
      ),
    );
  });
  tearDown(() { vm.dispose(); session.dispose(); });

  Future<SplashDestination?> start() => vm.initialize(biometricReason: 'Unlock PayFlow');

  test('disabled preference restores without any biometric prompt', () async {
    storage.values[biometricsEnabledKey] = 'false';
    expect(await start(), SplashDestination.home);
    expect(localAuth.calls, 0);
    expect(repository.calls, 1);
  });

  test('first launch without a session never asks for biometrics', () async {
    storage.values.clear();
    expect(await start(), SplashDestination.login);
    expect(localAuth.calls, 0);
    expect(repository.calls, 0);
  });

  test('pending Face ID blocks token reads and duplicate startup attempts', () async {
    localAuth.pending = Completer<bool>();
    final attempt = start();
    // Drain asynchronous storage/availability checks without completing auth.
    await Future<void>.delayed(Duration.zero);
    expect(localAuth.calls, 1);
    expect(vm.biometricState, SplashBiometricState.authenticating);
    expect(storage.reads, isNot(contains(refreshTokenKey)));
    expect(repository.calls, 0);
    expect(await start(), isNull);
    localAuth.pending!.complete(true);
    expect(await attempt, SplashDestination.home);
    expect(repository.receivedToken, 'stored-refresh');
    expect(storage.values[refreshTokenKey], 'rotated-refresh');
    expect(localAuth.biometricOnly, isTrue);
    expect(localAuth.persistAcrossBackgrounding, isTrue);
  });

  test('third failed prompt clears session and allows Login guards', () async {
    localAuth.result = false;
    expect(await start(), isNull);
    expect(vm.biometricAttemptsRemaining, 2);
    expect(await start(), isNull);
    expect(vm.biometricAttemptsRemaining, 1);
    expect(await start(), SplashDestination.login);
    expect(session.status, SessionStatus.unauthenticated);
    expect(repository.calls, 0);
    expect(storage.reads, isNot(contains(refreshTokenKey)));
    expect(storage.values[refreshTokenKey], isNull);
  });

  for (final code in [
    LocalAuthExceptionCode.userCanceled,
    LocalAuthExceptionCode.userRequestedFallback,
    LocalAuthExceptionCode.temporaryLockout,
    LocalAuthExceptionCode.biometricLockout,
    LocalAuthExceptionCode.noBiometricsEnrolled,
  ]) {
    test('$code immediately returns to Login without a refresh', () async {
      localAuth.errorCode = code;
      expect(await start(), SplashDestination.login);
      expect(repository.calls, 0);
      expect(storage.values[refreshTokenKey], isNull);
    });
  }

  test('removed biometrics require Login instead of bypassing protection', () async {
    localAuth.available = false;
    expect(await start(), SplashDestination.login);
    expect(localAuth.calls, 0);
    expect(repository.calls, 0);
  });

  test('biometric technical errors are distinct and can fall back to Login', () async {
    localAuth.errorCode = LocalAuthExceptionCode.unknownError;
    expect(await start(), isNull);
    expect(vm.biometricState, SplashBiometricState.technicalError);
    expect(vm.hasTechnicalError, isFalse);
    expect(vm.biometricAttemptCount, 0);
    expect(repository.calls, 0);
    expect(await vm.useLogin(), SplashDestination.login);
    expect(session.isAuthenticated, isFalse);
  });

  test('network failure retains token and retry reuses successful Face ID', () async {
    repository.error = TimeoutException('Offline');
    expect(await start(), isNull);
    expect(vm.hasTechnicalError, isTrue);
    expect(vm.biometricAttemptCount, 0);
    expect(storage.values[refreshTokenKey], 'stored-refresh');
    repository.error = null;
    expect(await start(), SplashDestination.home);
    expect(localAuth.calls, 1);
    expect(repository.calls, 2);
  });

  test('expired server session requires Login even after Face ID success', () async {
    repository.error = const SessionExpiredException();
    expect(await start(), SplashDestination.login);
    expect(session.status, SessionStatus.unauthenticated);
    expect(storage.values[refreshTokenKey], isNull);
  });
}
