class HomeUserDto {
  final String publicId;
  final String? firstName;
  final String lastName;
  final bool verified;

  const HomeUserDto({
    required this.publicId,
    required this.firstName,
    required this.lastName,
    required this.verified,
  });

  factory HomeUserDto.fromJson(Map<String, dynamic> json) {
    return HomeUserDto(
      publicId: json['publicId'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String,
      verified: json['verified'] as bool? ?? false,
    );
  }
}
