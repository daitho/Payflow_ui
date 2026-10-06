import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pay_flow_ui/core/service/biometric_service.dart';
import 'package:pay_flow_ui/features/profile/presentation/view_model/security_privacy_view_model.dart';

import '../../support/biometric_fakes.dart';

void main() {
  late RecordingSecureStorage storage;
  late FakeLocalAuthentication localAuth;
  late SecurityPrivacyViewModel vm;

  setUp(() {
    storage = RecordingSecureStorage()..seedSession(enabled: false);
    localAuth = FakeLocalAuthentication();
    vm = SecurityPrivacyViewModel(
      biometricService: BiometricService(
        secureStorage: storage, localAuthentication: localAuth,
      ),
    );
  });
  tearDown(() => vm.dispose());

  Future<BiometricToggleResult> toggle(bool enabled) => vm.setBiometricsEnabled(
    enabled: enabled, localizedReason: 'Change biometric preference',
  );

  test('enable and disable both require successful native authentication', () async {
    await vm.initialize();
    expect(await toggle(true), BiometricToggleResult.success);
    expect(storage.values[biometricsEnabledKey], 'true');
    expect(vm.biometricsEnabled, isTrue);
    expect(await toggle(false), BiometricToggleResult.success);
    expect(storage.values[biometricsEnabledKey], 'false');
    expect(vm.biometricsEnabled, isFalse);
    expect(localAuth.calls, 2);
  });

  test('cancellation cannot enable the preference', () async {
    await vm.initialize();
    localAuth.errorCode = LocalAuthExceptionCode.userCanceled;
    expect(await toggle(true), BiometricToggleResult.authenticationFailed);
    expect(vm.biometricsEnabled, isFalse);
    expect(storage.values[biometricsEnabledKey], 'false');
  });

  test('failed authentication cannot disable an existing protection', () async {
    storage.values[biometricsEnabledKey] = 'true';
    await vm.initialize();
    localAuth.result = false;
    expect(await toggle(false), BiometricToggleResult.authenticationFailed);
    expect(vm.biometricsEnabled, isTrue);
    expect(storage.values[biometricsEnabledKey], 'true');
  });

  test('persistence error does not report a successful activation', () async {
    await vm.initialize();
    storage.failingWriteKey = biometricsEnabledKey;
    expect(await toggle(true), BiometricToggleResult.technicalError);
    expect(vm.biometricsEnabled, isFalse);
    expect(storage.values[biometricsEnabledKey], 'false');
  });

  test('technical native error is separate from authentication failure', () async {
    await vm.initialize();
    localAuth.errorCode = LocalAuthExceptionCode.unknownError;
    expect(await toggle(true), BiometricToggleResult.technicalError);
  });

  test('unavailable hardware never silently changes the stored preference', () async {
    storage.values[biometricsEnabledKey] = 'true';
    localAuth.available = false;
    await vm.initialize();
    expect(vm.biometricsAvailable, isFalse);
    expect(vm.biometricsEnabled, isTrue);
    expect(await toggle(false), BiometricToggleResult.unavailable);
    expect(storage.values[biometricsEnabledKey], 'true');
  });

  test('storage initialization failure prevents accidental toggles', () async {
    storage.failingReadKey = biometricsEnabledKey;
    await vm.initialize();
    expect(vm.hasInitializationError, isTrue);
    expect(vm.isInitializing, isFalse);
    expect(await toggle(true), BiometricToggleResult.technicalError);
    expect(localAuth.calls, 0);
  });
}
