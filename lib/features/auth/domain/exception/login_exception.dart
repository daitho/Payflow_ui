sealed class LoginException implements Exception {
  const LoginException();
}

final class InvalidCredentialsException extends LoginException {
  const InvalidCredentialsException();
}

final class LoginNetworkException extends LoginException {
  const LoginNetworkException();
}

final class LoginTimeoutException extends LoginException {
  const LoginTimeoutException();
}

final class LoginServerException extends LoginException {
  const LoginServerException();
}

final class LoginUnexpectedException extends LoginException {
  const LoginUnexpectedException();
}

final class IdentifierNotVerifiedException extends LoginException {
  const IdentifierNotVerifiedException();
}
