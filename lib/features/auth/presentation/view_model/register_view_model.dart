import 'package:flutter/foundation.dart';

import '../../domain/exception/registration_exception.dart';
import '../../domain/model/verification_challenge_model.dart';
import '../../domain/service/register_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final RegisterService _registerService;
  RegisterViewModel({required RegisterService registerService})
    : _registerService = registerService;

  VerificationChallengeModel? _challenge;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  VerificationChallengeModel? get challenge => _challenge;

  // =========================================================
  // PASSWORD STATE
  // =========================================================

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _password = '';

  // =========================================================
  // TERMS
  // =========================================================
  bool _termsAccepted = false;

  // =========================================================
  // VALIDATION
  // =========================================================
  bool _firstNameHasError = false;
  bool _lastNameHasError = false;
  bool _emailHasError = false;
  bool _phoneHasError = false;
  bool _passwordHasError = false;
  bool _confirmPasswordHasError = false;
  bool _passwordMismatch = false;
  bool _termsHasError = false;
  bool _passwordRulesError = false;

  bool get passwordRulesError => _passwordRulesError;

  // =========================================================
  // LOADING
  // ========================================================
  bool _isLoading = false;

  // =========================================================
  // GETTERS
  // =========================================================
  bool get passwordVisible => _passwordVisible;

  String get password => _password;

  bool get confirmPasswordVisible => _confirmPasswordVisible;

  bool get termsAccepted => _termsAccepted;

  bool get firstNameHasError => _firstNameHasError;

  bool get lastNameHasError => _lastNameHasError;

  bool get emailHasError => _emailHasError;

  bool get phoneHasError => _phoneHasError;

  bool get passwordHasError => _passwordHasError;

  bool get confirmPasswordHasError => _confirmPasswordHasError;

  bool get passwordMismatch => _passwordMismatch;

  bool get termsHasError => _termsHasError;

  bool get isLoading => _isLoading;

  // =========================================================
  // PASSWORD VISIBILITY
  // =========================================================

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  // =========================================================
  // FIRST NAME
  // =========================================================

  void onFirstNameChanged(String value) {
    if (!_firstNameHasError || value.trim().isEmpty) {
      return;
    }

    _firstNameHasError = false;
    notifyListeners();
  }

  // =========================================================
  // LAST NAME
  // =========================================================

  void onLastNameChanged(String value) {
    if (!_lastNameHasError || value.trim().isEmpty) {
      return;
    }

    _lastNameHasError = false;
    notifyListeners();
  }

  // =========================================================
  // EMAIL
  // =========================================================

  void onEmailChanged(String value) {
    if (!_emailHasError || value.trim().isEmpty) {
      return;
    }

    _emailHasError = false;
    notifyListeners();
  }

  // =========================================================
  // PHONE
  // =========================================================

  void onPhoneChanged(String value) {
    if (!_phoneHasError || value.trim().isEmpty) {
      return;
    }
    _phoneHasError = false;
    notifyListeners();
  }

  // =========================================================
  // PASSWORD
  // =========================================================
  void onPasswordChanged(String value) {
    bool changed = false;
    // =========================================================
    // REAL-TIME PASSWORD VALUE
    // =========================================================
    if (_password != value) {
      _password = value;
      changed = true;
    }
    // =========================================================
    // REQUIRED ERROR
    // =========================================================
    if (_passwordHasError && value.isNotEmpty) {
      _passwordHasError = false;
      changed = true;
    }
    // =========================================================
    // PASSWORD RULE ERROR
    // =========================================================
    if (_passwordRulesError) {
      _passwordRulesError = false;
      changed = true;
    }
    // =========================================================
    // MISMATCH ERROR
    // =========================================================
    if (_passwordMismatch) {
      _passwordMismatch = false;
      changed = true;
    }
    // =========================================================
    // REFRESH UI
    // =========================================================

    if (changed) {
      notifyListeners();
    }
  }

  // =========================================================
  // CONFIRM PASSWORD
  // =========================================================
  void onConfirmPasswordChanged(String value) {
    bool changed = false;

    if (_confirmPasswordHasError && value.isNotEmpty) {
      _confirmPasswordHasError = false;
      changed = true;
    }

    if (_passwordMismatch) {
      _passwordMismatch = false;

      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
  }

  // =========================================================
  // TERMS
  // =========================================================
  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    if (value) {
      _termsHasError = false;
    }
    notifyListeners();
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  Future<bool> submit({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneE164,
    required String residenceCountryIsoCode2,
    required String password,
    required String confirmPassword,
  }) async {
    _errorMessage = null;
    final String cleanFirstName = firstName.trim();
    final String cleanLastName = lastName.trim();
    final String cleanEmail = email.trim();
    final String cleanPhoneE164 = phoneE164.trim();
    final bool firstNameEmpty = cleanFirstName.isEmpty;
    final bool lastNameEmpty = cleanLastName.isEmpty;
    final bool emailEmpty = cleanEmail.isEmpty;
    final bool phoneEmpty = cleanPhoneE164.isEmpty;
    final bool passwordEmpty = password.isEmpty;
    final bool confirmPasswordEmpty = confirmPassword.isEmpty;
    final bool passwordMismatch =
        !passwordEmpty && !confirmPasswordEmpty && password != confirmPassword;
    final bool passwordInvalid = !passwordEmpty && !isPasswordValid(password);

    // =========================================================
    // VALIDATION STATE
    // =========================================================
    _firstNameHasError = firstNameEmpty;
    _lastNameHasError = lastNameEmpty;
    _emailHasError = emailEmpty;
    _phoneHasError = phoneEmpty;
    _passwordHasError = passwordEmpty;
    _passwordRulesError = passwordInvalid;
    _confirmPasswordHasError = confirmPasswordEmpty;
    _passwordMismatch = passwordMismatch;
    _termsHasError = !_termsAccepted;
    notifyListeners();

    // =========================================================
    // INVALID FORM
    // =========================================================

    if (firstNameEmpty ||
        lastNameEmpty ||
        emailEmpty ||
        phoneEmpty ||
        passwordEmpty ||
        passwordInvalid ||
        confirmPasswordEmpty ||
        passwordMismatch ||
        !_termsAccepted) {
      return false;
    }

    // =========================================================
    // LOADING
    // =========================================================
    _isLoading = true;
    notifyListeners();

    try {
      _challenge = await _registerService.register(
        firstName: cleanFirstName,
        lastName: cleanLastName,
        email: cleanEmail,
        phoneE164: cleanPhoneE164,
        residenceCountryIsoCode2: residenceCountryIsoCode2,
        password: password,
      );
      return true;
    } on RegistrationException catch (error) {
      _errorMessage = error.message;
      debugPrint('Registration rejected: ${error.code ?? 'unknown'}');
      return false;
    } catch (error) {
      _errorMessage = 'Une erreur inattendue est survenue. Réessaie.';
      debugPrint('Registration failed unexpectedly: $error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // LOADING
  // =========================================================
  void setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }

  // =========================================================
  // RESET
  // =========================================================
  void resetValidation() {
    _firstNameHasError = false;
    _lastNameHasError = false;
    _emailHasError = false;
    _phoneHasError = false;
    _passwordHasError = false;
    _passwordRulesError = false;
    _confirmPasswordHasError = false;
    _passwordMismatch = false;
    _termsHasError = false;
    notifyListeners();
  }

  bool hasMinLength(String password) => password.length >= 12;

  bool hasMaxLength(String password) => password.length <= 128;

  bool hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);

  bool hasLowercase(String password) => RegExp(r'[a-z]').hasMatch(password);

  bool hasDigit(String password) => RegExp(r'[0-9]').hasMatch(password);

  bool hasSpecialCharacter(String password) {
    return RegExp(r'[^A-Za-z0-9]').hasMatch(password);
  }

  bool isPasswordValid(String password) {
    return hasMinLength(password) &&
        hasMaxLength(password) &&
        hasUppercase(password) &&
        hasLowercase(password) &&
        hasDigit(password) &&
        hasSpecialCharacter(password);
  }
}
