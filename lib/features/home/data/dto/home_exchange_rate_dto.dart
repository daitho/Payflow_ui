class HomeExchangeRateDto {
  final String? sourceCountryIsoCode2;
  final String? sourceCountryFlagUrl;

  final String? targetCountryIsoCode2;
  final String? targetCountryFlagUrl;

  final String sourceCurrencyCode;
  final String sourceCurrencyName;
  final String? sourceCurrencySymbol;

  final String targetCurrencyCode;
  final String targetCurrencyName;
  final String? targetCurrencySymbol;

  final num rate;

  final DateTime rateAt;

  final String source;

  const HomeExchangeRateDto({
    required this.sourceCountryIsoCode2,
    required this.sourceCountryFlagUrl,
    required this.targetCountryIsoCode2,
    required this.targetCountryFlagUrl,
    required this.sourceCurrencyCode,
    required this.sourceCurrencyName,
    required this.sourceCurrencySymbol,
    required this.targetCurrencyCode,
    required this.targetCurrencyName,
    required this.targetCurrencySymbol,
    required this.rate,
    required this.rateAt,
    required this.source,
  });

  factory HomeExchangeRateDto.fromJson(Map<String, dynamic> json) {
    return HomeExchangeRateDto(
      sourceCountryIsoCode2: json['sourceCountryIsoCode2'] as String?,

      sourceCountryFlagUrl: json['sourceCountryFlagUrl'] as String?,

      targetCountryIsoCode2: json['targetCountryIsoCode2'] as String?,

      targetCountryFlagUrl: json['targetCountryFlagUrl'] as String?,

      sourceCurrencyCode: json['sourceCurrencyCode'] as String,

      sourceCurrencyName: json['sourceCurrencyName'] as String,

      sourceCurrencySymbol: json['sourceCurrencySymbol'] as String?,

      targetCurrencyCode: json['targetCurrencyCode'] as String,

      targetCurrencyName: json['targetCurrencyName'] as String,

      targetCurrencySymbol: json['targetCurrencySymbol'] as String?,

      rate: json['rate'] as num,

      rateAt: DateTime.parse(json['rateAt'] as String),

      source: json['source'] as String,
    );
  }
}
