import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:pay_flow_ui/app/router/app_routes.dart';
import 'package:pay_flow_ui/app/router/guards/auth_guard.dart';
import 'package:pay_flow_ui/app/router/guards/guest_guard.dart';
import 'package:pay_flow_ui/core/service/biometric_service.dart';
import 'package:pay_flow_ui/core/service/session_service.dart';
import 'package:pay_flow_ui/features/auth/domain/service/refresh_service.dart';
import 'package:pay_flow_ui/features/auth/presentation/view/splash_view.dart';
import 'package:pay_flow_ui/features/auth/presentation/view_model/splash_view_model.dart';
import 'package:pay_flow_ui/l10n/app_localizations.dart';

import '../../support/biometric_fakes.dart';

void main() {
  for (final technicalError in [false, true]) {
    testWidgets('Login fallback works with real guards (technical=$technicalError)', (tester) async {
      final storage = RecordingSecureStorage()..seedSession();
      final localAuth = FakeLocalAuthentication()..result = false;
      if (technicalError) {
        localAuth.errorCode = LocalAuthExceptionCode.unknownError;
      }
      final session = SessionService(secureStorage: storage);
      final vm = SplashViewModel(
        sessionService: session,
        refreshService: RefreshService(authRepository: FakeRefreshRepository()),
        biometricService: BiometricService(
          secureStorage: storage, localAuthentication: localAuth,
        ),
      );
      final router = GoRouter(
        initialLocation: AppRoutes.splash,
        refreshListenable: session,
        redirect: (context, state) {
          if (state.matchedLocation == AppRoutes.login) {
            return GuestGuard(sessionService: session).redirect();
          }
          if (state.matchedLocation == AppRoutes.home) {
            return AuthGuard(sessionService: session).redirect();
          }
          return null;
        },
        routes: [
          GoRoute(path: AppRoutes.splash, builder: (_, _) =>
            ChangeNotifierProvider.value(value: vm, child: const SplashView())),
          GoRoute(path: AppRoutes.login, builder: (_, _) =>
            const Scaffold(body: Text('Login screen'))),
          GoRoute(path: AppRoutes.home, builder: (_, _) =>
            const Scaffold(body: Text('Home screen'))),
        ],
      );
      addTearDown(() { router.dispose(); vm.dispose(); session.dispose(); });
      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Se connecter'), findsOneWidget);
      expect(find.text('Home screen'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();
      expect(find.text('Login screen'), findsOneWidget);
      expect(session.status, SessionStatus.unauthenticated);
      expect(tester.takeException(), isNull);
    });
  }
}
