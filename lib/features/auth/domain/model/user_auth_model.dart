class UserAuthModel {
  final String id;
  final String publicId;
  final String email;
  final String? firstName;
  final String lastName;
  final String? phoneE164;
  final String role;
  final String status;
  final bool verified;
  final bool emailVerified;
  final bool phoneVerified;

  const UserAuthModel({
    required this.id,
    required this.publicId,
    required this.email,
    this.firstName,
    required this.lastName,
    required this.phoneE164,
    required this.role,
    required this.status,
    required this.verified,
    required this.emailVerified,
    required this.phoneVerified,
  });
}
