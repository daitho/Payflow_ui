class RequestPasswordResetRequestDto {
  final String identifier;

  const RequestPasswordResetRequestDto({
    required this.identifier,
  });

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
  };
}
