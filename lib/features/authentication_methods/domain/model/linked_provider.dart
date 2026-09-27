enum ExternalProvider {
  google,
  apple,
  facebook;

  String get apiValue => name.toUpperCase();
}

class LinkedProvider {
  final ExternalProvider provider;
  final bool linked;
  final bool available;
  final String? email;
  final DateTime? linkedAt;

  const LinkedProvider({
    required this.provider,
    required this.linked,
    required this.available,
    this.email,
    this.linkedAt,
  });
}
