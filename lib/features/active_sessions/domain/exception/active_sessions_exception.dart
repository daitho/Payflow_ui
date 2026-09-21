enum ActiveSessionsErrorType { network, unauthorized, server, unexpected }

class ActiveSessionsException implements Exception {
  final ActiveSessionsErrorType type;

  const ActiveSessionsException(this.type);
}
