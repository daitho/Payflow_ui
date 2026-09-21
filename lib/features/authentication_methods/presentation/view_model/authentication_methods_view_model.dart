import 'package:flutter/foundation.dart';

import '../../../../core/service/session_service.dart';
import '../../../auth/domain/exception/verification_exception.dart';
import '../../../auth/domain/model/verification_challenge_model.dart';
import '../../../auth/domain/model/verification_channel.dart';
import '../../../auth/domain/service/verification_service.dart';

class AuthenticationMethodsViewModel extends ChangeNotifier {
  final VerificationService _verificationService;
  final SessionService _sessionService;

  bool _loading = false;
  bool _emailVerified = false;
  bool _phoneVerified = false;
  VerificationErrorType? _error;

  AuthenticationMethodsViewModel({
    required VerificationService verificationService,
    required SessionService sessionService,
  }) : _verificationService = verificationService,
       _sessionService = sessionService {
    final user = _sessionService.currentUser;
    _emailVerified = user?.emailVerified ?? false;
    _phoneVerified = user?.phoneVerified ?? false;
  }

  bool get loading => _loading;
  bool get emailVerified => _emailVerified;
  bool get phoneVerified => _phoneVerified;
  String get email => _sessionService.currentUser?.email ?? '';
  String get phone =>
      _sessionService.currentUser?.phoneE164 ?? '';
  VerificationErrorType? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final status = await _verificationService.status();
      _emailVerified = status.emailVerified;
      _phoneVerified = status.phoneVerified;
    } on VerificationException catch (exception) {
      _error = exception.type;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<VerificationChallengeModel?> start(
    VerificationChannel channel,
  ) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      return await _verificationService.startAdditional(
        channel,
      );
    } on VerificationException catch (exception) {
      _error = exception.type;
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
