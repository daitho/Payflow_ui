import '../../domain/model/linked_provider.dart';

class LinkedProviderDto {
  final ExternalProvider provider;
  final bool linked;
  final bool available;
  final String? providerEmail;
  final DateTime? linkedAt;

  const LinkedProviderDto({
    required this.provider,
    required this.linked,
    required this.available,
    this.providerEmail,
    this.linkedAt,
  });

  factory LinkedProviderDto.fromJson(Map<String, dynamic> json) {
    final provider = ExternalProvider.values.byName(
      (json['provider'] as String).toLowerCase(),
    );
    return LinkedProviderDto(
      provider: provider,
      linked: json['linked'] as bool,
      available: json['available'] as bool,
      providerEmail: json['providerEmail'] as String?,
      linkedAt: DateTime.tryParse(json['linkedAt']?.toString() ?? ''),
    );
  }

  LinkedProvider toModel() => LinkedProvider(
    provider: provider,
    linked: linked,
    available: available,
    email: providerEmail,
    linkedAt: linkedAt,
  );
}
