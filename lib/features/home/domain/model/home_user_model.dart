class HomeUserModel {
  final String publicId;
  final String? firstName;
  final String lastName;
  final bool verified;

  const HomeUserModel({
    required this.publicId,
    required this.firstName,
    required this.lastName,
    required this.verified,
  });

  String get displayName {
    final String? normalizedFirstName =
    firstName?.trim();

    if (normalizedFirstName == null ||
        normalizedFirstName.isEmpty) {
      return lastName;
    }

    return '$normalizedFirstName $lastName';
  }

  String get initials {
    final List<String> values = [];

    final String? normalizedFirstName =
    firstName?.trim();

    if (normalizedFirstName != null &&
        normalizedFirstName.isNotEmpty) {
      values.add(
        normalizedFirstName[0].toUpperCase(),
      );
    }

    final String normalizedLastName =
    lastName.trim();

    if (normalizedLastName.isNotEmpty) {
      values.add(
        normalizedLastName[0].toUpperCase(),
      );
    }

    return values.take(2).join();
  }
}