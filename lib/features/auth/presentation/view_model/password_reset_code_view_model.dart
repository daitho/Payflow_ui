import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/exception/password_reset_exception.dart';
import '../../domain/model/password_reset_token_model.dart';
import '../../domain/model/verification_challenge_model.dart';
import '../../domain/service/password_reset_service.dart';

class PasswordResetCodeViewModel extends ChangeNotifier {
  final PasswordResetService _service;

  VerificationChallengeModel _challenge;
  Timer? _timer;
  String _code = '';
  int _secondsUntilResend = 0;
  bool _isSubmitting = false;
  bool _isResending = false;
  PasswordResetErrorType? _error;

  PasswordResetCodeViewModel({
    required PasswordResetService service,
    required VerificationChallengeModel initialChallenge,
  }) : _service = service,
       _challenge = initialChallenge {
    _startCountdown();
  }

  VerificationChallengeModel get challenge => _challenge;
  String get code => _code;
  int get secondsUntilResend => _secondsUntilResend;
  bool get canSubmit => _code.length == 6 && !_isSubmitting;
  bool get canResend => _secondsUntilResend == 0 && !_isResending;
  bool get isSubmitting => _isSubmitting;
  bool get isResending => _isResending;
  PasswordResetErrorType? get error => _error;

  void setCode(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    _code = digits.length > 6
        ? digits.substring(0, 6)
        : digits;
    _error = null;
    notifyListeners();
  }

  Future<PasswordResetTokenModel?> verify() async {
    if (!canSubmit) return null;
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      return await _service.verifyCode(
        challengeId: _challenge.challengeId,
        code: _code,
      );
    } on PasswordResetException catch (exception) {
      _error = exception.type;
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> resend() async {
    if (!canResend) return;
    _isResending = true;
    _error = null;
    notifyListeners();
    try {
      _challenge = await _service.resendCode(
        challengeId: _challenge.challengeId,
        channel: _challenge.channel,
      );
      _code = '';
      _startCountdown();
    } on PasswordResetException catch (exception) {
      _error = exception.type;
    } finally {
      _isResending = false;
      notifyListeners();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    final difference = _challenge.resendAvailableAt
        .toUtc()
        .difference(DateTime.now().toUtc())
        .inSeconds;
    final next = difference < 0 ? 0 : difference;
    if (_secondsUntilResend != next) {
      _secondsUntilResend = next;
      notifyListeners();
    }
    if (next == 0) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
