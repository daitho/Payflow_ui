import 'package:flutter/foundation.dart';

import '../../../../core/service/session_service.dart';
import '../../domain/exception/login_exception.dart';
import '../../domain/service/login_service.dart';
import 'login_error_type.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService;
  final SessionService _sessionService;

  LoginViewModel({
    required LoginService loginService,
    required SessionService sessionService,
  }) : _loginService = loginService,
       _sessionService = sessionService;

  // =========================================================
  // STATE
  // =========================================================

  bool _passwordVisible = false;
  bool _identifierHasError = false;
  bool _passwordHasError = false;
  bool _isLoading = false;

  LoginErrorType? _loginError;

  // =========================================================
  // GETTERS
  // =========================================================
  bool get passwordVisible => _passwordVisible;

  bool get identifierHasError => _identifierHasError;

  bool get passwordHasError => _passwordHasError;

  bool get isLoading => _isLoading;

  LoginErrorType? get loginError => _loginError;

  // =========================================================
  // PASSWORD VISIBILITY
  // =========================================================
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;

    notifyListeners();
  }

  // =========================================================
  // IDENTIFIER
  // =========================================================

  void onIdentifierChanged(String value) {
    bool changed = false;

    if (_identifierHasError && value.trim().isNotEmpty) {
      _identifierHasError = false;
      changed = true;
    }

    if (_loginError != null) {
      _loginError = null;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  // =========================================================
  // PASSWORD
  // =========================================================

  void onPasswordChanged(String value) {
    bool changed = false;

    if (_passwordHasError && value.isNotEmpty) {
      _passwordHasError = false;
      changed = true;
    }

    if (_loginError != null) {
      _loginError = null;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  // =========================================================
  // SUBMIT
  // =========================================================

  Future<bool> submit({required String email, required String password}) async {
    final String cleanEmail = email.trim();

    final bool emailEmpty = cleanEmail.isEmpty;

    final bool passwordEmpty = password.isEmpty;

    // =========================================================
    // RESET SERVER ERROR
    // =========================================================

    _loginError = null;

    // =========================================================
    // LOCAL VALIDATION
    // =========================================================

    _identifierHasError = emailEmpty;

    _passwordHasError = passwordEmpty;

    if (emailEmpty || passwordEmpty) {
      notifyListeners();

      return false;
    }

    // =========================================================
    // ANTI DOUBLE-SUBMIT
    // =========================================================

    if (_isLoading) {
      return false;
    }

    // =========================================================
    // LOADING
    // =========================================================

    _isLoading = true;

    notifyListeners();

    try {
      debugPrint('[AUTH] Login started');

      final session = await _loginService.login(
        email: cleanEmail,
        password: password,
      );

      debugPrint('[AUTH] Backend login successful');

      await _sessionService.saveSession(session);

      debugPrint('[AUTH] Session saved successfully');
      return true;
    }
    // =========================================================
    // INVALID CREDENTIALS
    // =========================================================
    on InvalidCredentialsException {
      _loginError = LoginErrorType.invalidCredentials;
      return false;
    }
    // =========================================================
    // NETWORK
    // =========================================================
    on LoginNetworkException {
      _loginError = LoginErrorType.network;
      return false;
    }
    // =========================================================
    // TIMEOUT
    // =========================================================
    on LoginTimeoutException {
      _loginError = LoginErrorType.timeout;
      return false;
    }
    // =========================================================
    // SERVER
    // =========================================================
    on LoginServerException {
      _loginError = LoginErrorType.server;
      return false;
    }
    // =========================================================
    // UNEXPECTED
    // =========================================================
    on LoginUnexpectedException {
      _loginError = LoginErrorType.unexpected;
      return false;
    } catch (error, stackTrace) {
      /*
     * Filet de sécurité.
     *
     * Aucun token et aucun mot de passe
     * n'est loggué.
     */
      debugPrint(
        '[AUTH] Unexpected login failure: '
        '${error.runtimeType}',
      );

      debugPrintStack(stackTrace: stackTrace);
      _loginError = LoginErrorType.unexpected;

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
    _identifierHasError = false;
    _passwordHasError = false;
    _loginError = null;
    notifyListeners();
  }
}
