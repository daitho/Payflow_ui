class ProfileModel {
  final String publicId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String role;
  final String status;
  final bool verified;

  const ProfileModel({
    required this.publicId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.verified,
  });

  String get fullName {
    final String name = '$firstName $lastName'.trim();
    return name;
  }

  String get initials {
    final String first = firstName.trim().isNotEmpty ? firstName.trim()[0] : '';
    final String last = lastName.trim().isNotEmpty ? lastName.trim()[0] : '';
    return '$first$last'.toUpperCase();
  }
}
