class HomeBeneficiaryDto {
  final String id;
  final String displayName;

  final String countryId;
  final String? countryIsoCode2;
  final String? countryFlagUrl;

  final String? phoneE164;
  final String? operatorName;

  final bool favorite;

  const HomeBeneficiaryDto({
    required this.id,
    required this.displayName,
    required this.countryId,
    required this.countryIsoCode2,
    required this.countryFlagUrl,
    required this.phoneE164,
    required this.operatorName,
    required this.favorite,
  });

  factory HomeBeneficiaryDto.fromJson(
      Map<String, dynamic> json,
      ) {
    return HomeBeneficiaryDto(
      id: json['id'] as String,

      displayName:
      json['displayName'] as String,

      countryId:
      json['countryId'] as String,

      countryIsoCode2:
      json['countryIsoCode2'] as String?,

      countryFlagUrl:
      json['countryFlagUrl'] as String?,

      phoneE164:
      json['phoneE164'] as String?,

      operatorName:
      json['operatorName'] as String?,

      favorite:
      json['favorite'] as bool? ?? false,
    );
  }
}