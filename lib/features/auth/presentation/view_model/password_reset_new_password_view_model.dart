import 'package:flutter/foundation.dart';

import '../../domain/exception/password_reset_exception.dart';
import '../../domain/model/password_reset_token_model.dart';
import '../../domain/service/password_reset_service.dart';

class PasswordResetNewPasswordViewModel extends ChangeNotifier {
  final PasswordResetService _service;
  final PasswordResetTokenModel _token;

  String _password = '';
  String _confirmation = '';
  bool _passwordVisible = false;
  bool _confirmationVisible = false;
  bool _isLoading = false;
  PasswordResetErrorType? _error;

  PasswordResetNewPasswordViewModel({
    required PasswordResetService service,
    required PasswordResetTokenModel token,
  }) : _service = service,
       _token = token;

  bool get passwordVisible => _passwordVisible;
  bool get confirmationVisible => _confirmationVisible;
  bool get isLoading => _isLoading;
  PasswordResetErrorType? get error => _error;

  void setPassword(String value) {
    _password = value;
    _error = null;
    notifyListeners();
  }

  void setConfirmation(String value) {
    _confirmation = value;
    _error = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void toggleConfirmationVisibility() {
    _confirmationVisible = !_confirmationVisible;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (_isLoading) return false;
    if (_password != _confirmation) {
      _error = PasswordResetErrorType.passwordMismatch;
      notifyListeners();
      return false;
    }
    if (!_isStrongPassword(_password)) {
      _error = PasswordResetErrorType.weakPassword;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.resetPassword(
        resetToken: _token.resetToken,
        newPassword: _password,
        passwordConfirmation: _confirmation,
      );
      return true;
    } on PasswordResetException catch (exception) {
      _error = exception.type;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isStrongPassword(String password) {
    return password.length >= 12 &&
        password.length <= 128 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password) &&
        RegExp(r'[^A-Za-z0-9]').hasMatch(password);
  }
}
