import 'package:flutter/foundation.dart';

import '../../domain/exception/change_password_exception.dart';
import '../../domain/model/change_password_command.dart';
import '../../domain/service/change_password_service.dart';

enum CurrentPasswordFieldError { required, invalid }

enum NewPasswordFieldError { required, weak, unchanged }

enum ConfirmationPasswordFieldError { required, mismatch }

class ChangePasswordViewModel extends ChangeNotifier {
  final ChangePasswordService _service;

  ChangePasswordViewModel({
    required ChangePasswordService service,
  }) : _service = service;

  bool _isSubmitting = false;
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmationPasswordVisible = false;
  String _newPassword = '';

  CurrentPasswordFieldError? _currentPasswordError;
  NewPasswordFieldError? _newPasswordError;
  ConfirmationPasswordFieldError? _confirmationPasswordError;
  ChangePasswordErrorType? _errorType;

  bool get isSubmitting => _isSubmitting;
  bool get currentPasswordVisible => _currentPasswordVisible;
  bool get newPasswordVisible => _newPasswordVisible;
  bool get confirmationPasswordVisible => _confirmationPasswordVisible;
  String get newPassword => _newPassword;

  CurrentPasswordFieldError? get currentPasswordError =>
      _currentPasswordError;
  NewPasswordFieldError? get newPasswordError => _newPasswordError;
  ConfirmationPasswordFieldError? get confirmationPasswordError =>
      _confirmationPasswordError;
  ChangePasswordErrorType? get errorType => _errorType;

  bool get hasMinLength => _newPassword.length >= 12;
  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(_newPassword);
  bool get hasLowercase => RegExp(r'[a-z]').hasMatch(_newPassword);
  bool get hasDigit => RegExp(r'[0-9]').hasMatch(_newPassword);
  bool get hasSpecialCharacter =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(_newPassword);

  bool get isNewPasswordValid =>
      hasMinLength &&
      _newPassword.length <= 128 &&
      hasUppercase &&
      hasLowercase &&
      hasDigit &&
      hasSpecialCharacter;

  void toggleCurrentPasswordVisibility() {
    _currentPasswordVisible = !_currentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _newPasswordVisible = !_newPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmationPasswordVisibility() {
    _confirmationPasswordVisible = !_confirmationPasswordVisible;
    notifyListeners();
  }

  void onCurrentPasswordChanged(String value) {
    if (_currentPasswordError != null || _errorType != null) {
      _currentPasswordError = null;
      _errorType = null;
      notifyListeners();
    }
  }

  void onNewPasswordChanged(String value) {
    _newPassword = value;
    _newPasswordError = null;
    _confirmationPasswordError = null;
    _errorType = null;
    notifyListeners();
  }

  void onConfirmationPasswordChanged(String value) {
    if (_confirmationPasswordError != null) {
      _confirmationPasswordError = null;
      notifyListeners();
    }
  }

  Future<bool> submit({
    required String currentPassword,
    required String newPassword,
    required String confirmationPassword,
  }) async {
    if (_isSubmitting) {
      return false;
    }

    _clearErrors();

    _currentPasswordError = currentPassword.isEmpty
        ? CurrentPasswordFieldError.required
        : null;

    if (newPassword.isEmpty) {
      _newPasswordError = NewPasswordFieldError.required;
    } else if (!isNewPasswordValid) {
      _newPasswordError = NewPasswordFieldError.weak;
    } else if (newPassword == currentPassword) {
      _newPasswordError = NewPasswordFieldError.unchanged;
    }

    if (confirmationPassword.isEmpty) {
      _confirmationPasswordError =
          ConfirmationPasswordFieldError.required;
    } else if (confirmationPassword != newPassword) {
      _confirmationPasswordError =
          ConfirmationPasswordFieldError.mismatch;
    }

    if (_currentPasswordError != null ||
        _newPasswordError != null ||
        _confirmationPasswordError != null) {
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      await _service.changePassword(
        ChangePasswordCommand(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      return true;
    } on ChangePasswordException catch (exception) {
      _applyDomainError(exception.type);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void _applyDomainError(ChangePasswordErrorType type) {
    switch (type) {
      case ChangePasswordErrorType.invalidCurrentPassword:
        _currentPasswordError = CurrentPasswordFieldError.invalid;
      case ChangePasswordErrorType.weakPassword:
        _newPasswordError = NewPasswordFieldError.weak;
      case ChangePasswordErrorType.unchangedPassword:
        _newPasswordError = NewPasswordFieldError.unchanged;
      case ChangePasswordErrorType.passwordLoginUnavailable:
      case ChangePasswordErrorType.sessionExpired:
      case ChangePasswordErrorType.network:
      case ChangePasswordErrorType.server:
      case ChangePasswordErrorType.unexpected:
        _errorType = type;
    }
  }

  void _clearErrors() {
    _currentPasswordError = null;
    _newPasswordError = null;
    _confirmationPasswordError = null;
    _errorType = null;
  }
}
