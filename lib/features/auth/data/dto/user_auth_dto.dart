import '../../domain/model/user_auth_model.dart';

class UserAuthDto {
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

  const UserAuthDto({
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

  factory UserAuthDto.fromJson(Map<String, dynamic> json) {
    return UserAuthDto(
      id: json['id'] as String,
      publicId: json['publicId'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String,
      phoneE164: json['phoneE164'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      verified: json['verified'] as bool,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
    );
  }

  UserAuthModel toModel() => UserAuthModel(
    id: id,
    publicId: publicId,
    email: email,
    firstName: firstName,
    lastName: lastName,
    phoneE164: phoneE164,
    role: role,
    status: status,
    verified: verified,
    emailVerified: emailVerified,
    phoneVerified: phoneVerified,
  );
}
