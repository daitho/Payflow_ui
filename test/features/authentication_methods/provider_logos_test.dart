import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pay_flow_ui/core/service/session_service.dart';
import 'package:pay_flow_ui/features/auth/domain/repository/auth_repository.dart';
import 'package:pay_flow_ui/features/auth/domain/service/verification_service.dart';
import 'package:pay_flow_ui/features/auth/presentation/widget/social_provider_logo.dart';
import 'package:pay_flow_ui/features/authentication_methods/domain/model/linked_provider.dart';
import 'package:pay_flow_ui/features/authentication_methods/domain/repository/linked_provider_repository.dart';
import 'package:pay_flow_ui/features/authentication_methods/domain/service/linked_provider_service.dart';
import 'package:pay_flow_ui/features/authentication_methods/presentation/view/authentication_methods_view.dart';
import 'package:pay_flow_ui/features/authentication_methods/presentation/view_model/authentication_methods_view_model.dart';

class _UnusedAuth implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
class _UnusedProviders implements LinkedProviderRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
class _ViewModel extends AuthenticationMethodsViewModel {
  bool appleAvailable = true;
  bool appleLinked = false;
  _ViewModel() : super(
    verificationService: VerificationService(authRepository: _UnusedAuth()),
    linkedProviderService: LinkedProviderService(_UnusedProviders()),
    sessionService: SessionService(secureStorage: const FlutterSecureStorage()),
  );
  @override
  LinkedProvider? provider(ExternalProvider provider) => LinkedProvider(
    provider: provider, available: provider != ExternalProvider.apple || appleAvailable,
    linked: provider == ExternalProvider.apple && appleLinked,
  );
}

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  Future<void> showProfile(WidgetTester tester, _ViewModel vm) async {
    await tester.pumpWidget(ChangeNotifierProvider<AuthenticationMethodsViewModel>.value(
      value: vm, child: const MaterialApp(home: AuthenticationMethodsView()),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('Profile uses exactly the shared Login assets and logo sizes', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final vm = _ViewModel();
    addTearDown(vm.dispose);
    await showProfile(tester, vm);
    expect(find.byType(SocialProviderLogo), findsNWidgets(3));
    for (final entry in {'google': 32.0, 'apple': 31.0, 'facebook': 31.0}.entries) {
      final images = tester.widgetList<Image>(find.byType(Image)).where((image) =>
        (image.image as AssetImage).assetName == 'assets/images/login/${entry.key}_logo.png');
      expect(images, hasLength(1));
      expect(images.single.width, entry.value);
      expect(images.single.height, entry.value);
    }
  });

  testWidgets('available Apple on iOS asks for the PayFlow password before linking', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final vm = _ViewModel();
    addTearDown(vm.dispose);
    await showProfile(tester, vm);
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    expect(find.text('Mot de passe PayFlow actuel'), findsOneWidget);
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    testWidgets('unavailable Apple cannot start linking on $platform', (tester) async {
      debugDefaultTargetPlatformOverride = platform;
      final vm = _ViewModel()..appleAvailable = platform != TargetPlatform.iOS;
      addTearDown(vm.dispose);
      await showProfile(tester, vm);
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  }
}
