import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pay_flow_ui/app/router/app_routes.dart';
import 'package:pay_flow_ui/app/router/guards/guest_guard.dart';
import 'package:pay_flow_ui/core/service/biometric_service.dart';
import 'package:pay_flow_ui/core/service/session_service.dart';
import 'package:pay_flow_ui/features/auth/domain/exception/session_expired_exception.dart';
import 'package:pay_flow_ui/features/auth/domain/model/auth_session_model.dart';
import 'package:pay_flow_ui/features/auth/domain/repository/auth_repository.dart';
import 'package:pay_flow_ui/features/auth/domain/service/refresh_service.dart';
import 'package:pay_flow_ui/features/auth/presentation/view/splash_view.dart';
import 'package:pay_flow_ui/features/auth/presentation/view_model/splash_view_model.dart';
import 'package:pay_flow_ui/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

DioException _technicalError({
  int status = 404,
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  final request = RequestOptions(path: '/api/v1/auth/refresh');
  return DioException(
    requestOptions: request,
    type: type,
    response: type == DioExceptionType.badResponse
        ? Response<Object>(requestOptions: request, statusCode: status)
        : null,
  );
}

class _TestSessionService extends SessionService {
  _TestSessionService()
      : super(secureStorage: const FlutterSecureStorage());

  SessionStatus _state = SessionStatus.unknown;
  String? storedRefreshToken = 'stored-refresh';
  int clearCalls = 0;
  Completer<void>? clearGate;
  Object? clearError;

  @override
  SessionStatus get status => _state;

  @override
  Future<void> initialize() async {
    _state = storedRefreshToken == null
        ? SessionStatus.unauthenticated
        : SessionStatus.refreshRequired;
    notifyListeners();
  }

  @override
  Future<String?> readRefreshToken() async => storedRefreshToken;

  @override
  Future<void> clearSession() async {
    clearCalls++;
    final gate = clearGate;
    if (gate != null) await gate.future;
    if (clearError != null) throw clearError!;
    storedRefreshToken = null;
    _state = SessionStatus.unauthenticated;
    notifyListeners();
  }
}

class _TestAuthRepository extends Fake implements AuthRepository {
  int refreshCalls = 0;
  final refreshStarted = Completer<void>();
  Future<AuthSessionModel> Function(String) response =
      (_) async => throw _technicalError();

  @override
  Future<AuthSessionModel> refresh(String refreshToken) {
    refreshCalls++;
    if (!refreshStarted.isCompleted) refreshStarted.complete();
    return response(refreshToken);
  }
}

class _NoBiometrics extends BiometricService {
  _NoBiometrics() : super(secureStorage: const FlutterSecureStorage());

  @override
  Future<bool> isBiometricsEnabled() async => false;
}

class _Fixture {
  final session = _TestSessionService();
  final repository = _TestAuthRepository();
  late final model = SplashViewModel(
    sessionService: session,
    refreshService: RefreshService(authRepository: repository),
    biometricService: _NoBiometrics(),
  );
  late final guard = GuestGuard(sessionService: session);

  Future<SplashDestination?> initialize() =>
      model.initialize(biometricReason: 'Unlock PayFlow');

  void dispose() {
    model.dispose();
    session.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final failure in <String, DioException Function()>{
    'route/proxy 404': () => _technicalError(),
    'server 500': () => _technicalError(status: 500),
    'network failure': () =>
        _technicalError(type: DioExceptionType.connectionError),
    'timeout': () => _technicalError(type: DioExceptionType.receiveTimeout),
  }.entries) {
    test('${failure.key} preserves session until explicit sign-in', () async {
      final fixture = _Fixture();
      addTearDown(fixture.dispose);
      fixture.repository.response = (_) async => throw failure.value();

      expect(await fixture.initialize(), isNull);
      expect(fixture.model.hasTechnicalError, isTrue);
      expect(fixture.session.storedRefreshToken, 'stored-refresh');
      expect(fixture.session.clearCalls, 0);
      expect(fixture.guard.redirect(), AppRoutes.splash);

      expect(await fixture.model.continueToLogin(), SplashDestination.login);
      expect(fixture.session.storedRefreshToken, isNull);
      expect(fixture.session.status, SessionStatus.unauthenticated);
      expect(fixture.guard.redirect(), isNull);
      expect(fixture.model.hasTechnicalError, isFalse);
      expect(fixture.repository.refreshCalls, 1);
    });
  }

  test('retry retains the session and retries refresh', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);

    await fixture.initialize();
    await fixture.initialize();

    expect(fixture.repository.refreshCalls, 2);
    expect(fixture.session.storedRefreshToken, 'stored-refresh');
    expect(fixture.session.clearCalls, 0);
  });

  test('expired session still opens login automatically', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);
    fixture.repository.response = (_) async =>
        throw const SessionExpiredException();

    expect(await fixture.initialize(), SplashDestination.login);
    expect(fixture.guard.redirect(), isNull);
    expect(fixture.session.clearCalls, 1);
  });

  test('sign-in waits for clearing and rejects concurrent actions', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);
    await fixture.initialize();
    fixture.session.clearGate = Completer<void>();

    final login = fixture.model.continueToLogin();
    expect(fixture.model.isLoading, isTrue);
    expect(fixture.guard.redirect(), AppRoutes.splash);
    expect(await fixture.model.continueToLogin(), isNull);
    expect(await fixture.initialize(), isNull);
    expect(fixture.session.clearCalls, 1);
    expect(fixture.repository.refreshCalls, 1);

    fixture.session.clearGate!.complete();
    expect(await login, SplashDestination.login);
    expect(fixture.guard.redirect(), isNull);
    expect(fixture.model.isLoading, isFalse);
  });

  test('sign-in cannot race an active refresh', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);
    final response = Completer<AuthSessionModel>();
    fixture.repository.response = (_) => response.future;

    final initialization = fixture.initialize();
    await fixture.repository.refreshStarted.future;
    expect(await fixture.model.continueToLogin(), isNull);
    expect(fixture.session.clearCalls, 0);

    response.completeError(_technicalError());
    expect(await initialization, isNull);
    expect(fixture.session.storedRefreshToken, 'stored-refresh');
  });

  test('storage failure keeps recovery available without opening login', () async {
    final fixture = _Fixture();
    addTearDown(fixture.dispose);
    await fixture.initialize();
    fixture.session.clearError = StateError('Storage unavailable');

    expect(await fixture.model.continueToLogin(), isNull);
    expect(fixture.model.hasTechnicalError, isTrue);
    expect(fixture.model.isLoading, isFalse);
    expect(fixture.guard.redirect(), AppRoutes.splash);

    fixture.session.clearError = null;
    expect(await fixture.model.continueToLogin(), SplashDestination.login);
    expect(fixture.guard.redirect(), isNull);
  });

  testWidgets('404 recovery button opens login without a splash redirect loop',
      (tester) async {
    final fixture = _Fixture();
    final router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: fixture.session,
      redirect: (context, state) => state.uri.path == AppRoutes.login
          ? fixture.guard.redirect()
          : null,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => ChangeNotifierProvider.value(
            value: fixture.model,
            child: const SplashView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const Scaffold(
            body: Text('Login page', key: ValueKey('login-page')),
          ),
        ),
      ],
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
      fixture.dispose();
    });

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Réessayer'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(fixture.session.clearCalls, 0);
    await tester.tap(find.byKey(const ValueKey('splash-sign-in')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('login-page')), findsOneWidget);
    expect(fixture.session.status, SessionStatus.unauthenticated);
    expect(fixture.repository.refreshCalls, 1);
    expect(tester.takeException(), isNull);
  });
}
