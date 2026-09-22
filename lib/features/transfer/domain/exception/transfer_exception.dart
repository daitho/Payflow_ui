enum TransferFailure {
  invalid,
  sessionExpired,
  notFound,
  conflict,
  quoteExpired,
  amountBelowMinimum,
  amountAboveMaximum,
  unavailable,
  network,
  timeout,
  server,
  invalidResponse,
  unexpected,
}

class TransferException implements Exception {
  final TransferFailure failure;
  const TransferException(this.failure);
}
