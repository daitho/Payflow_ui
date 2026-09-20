enum TransferHistoryFailure {
  network,
  timeout,
  sessionExpired,
  notFound,
  server,
  invalidResponse,
  unexpected,
}

class TransferHistoryException implements Exception {
  final TransferHistoryFailure failure;
  const TransferHistoryException(this.failure);
}
