class HomeBeneficiaryModel {
  final String id;
  final String displayName;

  final String countryId;
  final String? countryIsoCode2;
  final String? countryFlagUrl;

  final String? phoneE164;
  final String? operatorName;

  final bool favorite;

  const HomeBeneficiaryModel({
    required this.id,
    required this.displayName,
    required this.countryId,
    required this.countryIsoCode2,
    required this.countryFlagUrl,
    required this.phoneE164,
    required this.operatorName,
    required this.favorite,
  });

  String get firstName {
    final List<String> parts =
    displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where(
          (part) => part.isNotEmpty,
    )
        .toList();

    if (parts.isEmpty) {
      return displayName;
    }
    return parts.first;
  }
}