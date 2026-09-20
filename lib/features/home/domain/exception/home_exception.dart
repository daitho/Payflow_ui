abstract class HomeException implements Exception {
  final Object? cause;

  const HomeException({this.cause});
}

// ============================================================
// NETWORK
// ============================================================

class HomeNetworkException extends HomeException {
  const HomeNetworkException({super.cause});
}

// ============================================================
// TIMEOUT
// ============================================================

class HomeTimeoutException extends HomeException {
  const HomeTimeoutException({super.cause});
}

// ============================================================
// SERVER / HTTP RESPONSE
// ============================================================

class HomeServerException extends HomeException {
  final int? statusCode;

  const HomeServerException({this.statusCode, super.cause});
}

// ============================================================
// AUTHENTICATION / SESSION
// ============================================================

class HomeSessionExpiredException extends HomeException {
  const HomeSessionExpiredException({super.cause});
}

// ============================================================
// INVALID API RESPONSE
// ============================================================

class HomeInvalidResponseException extends HomeException {
  const HomeInvalidResponseException({super.cause});
}

// ============================================================
// UNEXPECTED
// ============================================================

class HomeUnexpectedException extends HomeException {
  const HomeUnexpectedException({super.cause});
}
