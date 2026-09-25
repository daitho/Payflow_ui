class RegistrationException implements Exception {
  final String message;
  final String? code;

  const RegistrationException({required this.message, this.code});

  @override
  String toString() => message;
}
