import 'package:flutter/foundation.dart';

import '../../domain/exception/password_reset_exception.dart';
import '../../domain/model/verification_challenge_model.dart';
import '../../domain/service/password_reset_service.dart';

class PasswordResetRequestViewModel extends ChangeNotifier {
  final PasswordResetService _service;

  String _identifier;
  bool _identifierHasError = false;
  bool _isLoading = false;
  PasswordResetErrorType? _error;

  PasswordResetRequestViewModel({
    required PasswordResetService service,
    String initialIdentifier = '',
  }) : _service = service,
       _identifier = initialIdentifier.trim();

  String get identifier => _identifier;
  bool get identifierHasError => _identifierHasError;
  bool get isLoading => _isLoading;
  PasswordResetErrorType? get error => _error;

  void setIdentifier(String value) {
    _identifier = value;
    _identifierHasError = false;
    _error = null;
    notifyListeners();
  }

  Future<VerificationChallengeModel?> submit() async {
    if (_isLoading) return null;
    if (_identifier.trim().isEmpty) {
      _identifierHasError = true;
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      return await _service.requestReset(_identifier);
    } on PasswordResetException catch (exception) {
      _error = exception.type;
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
