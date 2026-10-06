import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pay_flow_ui/features/auth/domain/model/auth_session_model.dart';
import 'package:pay_flow_ui/features/auth/domain/model/user_auth_model.dart';
import 'package:pay_flow_ui/features/auth/domain/repository/auth_repository.dart';

const refreshTokenKey = 'payflow.auth.refresh_token';
const refreshExpiresAtKey = 'payflow.auth.refresh_expires_at';
const sessionIdKey = 'payflow.auth.session_id';
const biometricsEnabledKey = 'payflow.biometrics.enabled.v2';

class RecordingSecureStorage implements FlutterSecureStorage {
  final Map<String, String> values = {};
  final List<String> reads = [];
  String? failingReadKey;
  String? failingWriteKey;

  void seedSession({bool enabled = true}) {
    values.addAll({
      refreshTokenKey: 'stored-refresh',
      refreshExpiresAtKey: DateTime.now().toUtc()
          .add(const Duration(days: 7)).toIso8601String(),
      sessionIdKey: 'stored-session',
      biometricsEnabledKey: enabled.toString(),
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final key = invocation.namedArguments[#key] as String;
    switch (invocation.memberName) {
      case #read:
        reads.add(key);
        if (key == failingReadKey) {
          return Future<String?>.error(StateError('Storage unavailable'));
        }
        return Future<String?>.value(values[key]);
      case #write:
        if (key == failingWriteKey) {
          return Future<void>.error(StateError('Write failed'));
        }
        final value = invocation.namedArguments[#value] as String?;
        if (value == null) {
          values.remove(key);
        } else {
          values[key] = value;
        }
        return Future<void>.value();
      case #delete:
        values.remove(key);
        return Future<void>.value();
      default:
        return super.noSuchMethod(invocation);
    }
  }
}

class FakeLocalAuthentication implements LocalAuthentication {
  bool available = true;
  bool result = true;
  LocalAuthExceptionCode? errorCode;
  Completer<bool>? pending;
  int calls = 0;
  bool? biometricOnly;
  bool? persistAcrossBackgrounding;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    switch (invocation.memberName) {
      case #isDeviceSupported:
      case #canCheckBiometrics:
        return Future<bool>.value(available);
      case #getAvailableBiometrics:
        return Future<List<BiometricType>>.value(
          available ? [BiometricType.face] : [],
        );
      case #authenticate:
        calls++;
        biometricOnly = invocation.namedArguments[#biometricOnly] as bool?;
        persistAcrossBackgrounding =
            invocation.namedArguments[#persistAcrossBackgrounding] as bool?;
        final code = errorCode;
        if (code != null) {
          return Future<bool>.error(LocalAuthException(code: code));
        }
        return pending?.future ?? Future<bool>.value(result);
      default:
        return super.noSuchMethod(invocation);
    }
  }
}

class FakeRefreshRepository implements AuthRepository {
  int calls = 0;
  Object? error;
  String? receivedToken;

  @override
  Future<AuthSessionModel> refresh(String refreshToken) async {
    calls++;
    receivedToken = refreshToken;
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    return testSession();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

AuthSessionModel testSession() => AuthSessionModel(
  tokenType: 'Bearer',
  accessToken: 'access-in-memory',
  accessExpiresAt: DateTime.now().add(const Duration(minutes: 10)),
  refreshToken: 'rotated-refresh',
  refreshExpiresAt: DateTime.now().add(const Duration(days: 7)),
  sessionId: 'stored-session',
  user: const UserAuthModel(
    id: 'user-1', publicId: 'public-1', email: 'user@payflow.test',
    lastName: 'Test', role: 'USER', status: 'ACTIVE', verified: true,
    emailVerified: true, phoneVerified: true,
  ),
);
