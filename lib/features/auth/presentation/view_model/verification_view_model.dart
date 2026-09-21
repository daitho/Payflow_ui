import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/service/session_service.dart';
import '../../domain/exception/verification_exception.dart';
import '../../domain/model/verification_challenge_model.dart';
import '../../domain/model/verification_channel.dart';
import '../../domain/service/verification_service.dart';

enum VerificationFlow {
  registration,
  additionalIdentifier,
}

class VerificationViewModel extends ChangeNotifier {
  final VerificationService _verificationService;
  final SessionService _sessionService;
  final VerificationFlow flow;

  VerificationChallengeModel _challenge;
  Timer? _timer;
  String _code = '';
  int _secondsUntilResend = 0;
  bool _isSubmitting = false;
  bool _isResending = false;
  VerificationErrorType? _error;

  VerificationViewModel({
    required VerificationChallengeModel initialChallenge,
    required VerificationService verificationService,
    required SessionService sessionService,
    this.flow = VerificationFlow.registration,
  }) : _challenge = initialChallenge,
       _verificationService = verificationService,
       _sessionService = sessionService {
    _startCountdown();
  }

  bool get isRegistration =>
      flow == VerificationFlow.registration;
  VerificationChannel get channel => _challenge.channel;
  String get maskedDestination => _challenge.maskedDestination;
  String get code => _code;
  int get secondsUntilResend => _secondsUntilResend;
  bool get canResend => _secondsUntilResend == 0 && !_isResending;
  bool get canSubmit => _code.length == 6 && !_isSubmitting;
  bool get isSubmitting => _isSubmitting;
  bool get isResending => _isResending;
  VerificationErrorType? get error => _error;

  void setCode(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    _code = digits.length > 6
        ? digits.substring(0, 6)
        : digits;
    _error = null;
    notifyListeners();
  }

  Future<bool> confirm() async {
    if (!canSubmit) return false;
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      if (isRegistration) {
        final session = await _verificationService.confirm(
          challengeId: _challenge.challengeId,
          code: _code,
        );
        await _sessionService.saveSession(session);
      } else {
        await _verificationService.confirmAdditional(
          challengeId: _challenge.challengeId,
          code: _code,
        );
      }
      return true;
    } on VerificationException catch (exception) {
      _error = exception.type;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> resend({
    VerificationChannel? channel,
  }) async {
    if (!canResend) return;
    _isResending = true;
    _error = null;
    notifyListeners();

    try {
      final requestedChannel =
          channel ?? _challenge.channel;
      _challenge = isRegistration
          ? await _verificationService.resend(
              challengeId: _challenge.challengeId,
              channel: requestedChannel,
            )
          : await _verificationService.startAdditional(
              requestedChannel,
            );
      _code = '';
      _startCountdown();
    } on VerificationException catch (exception) {
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
