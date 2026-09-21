import 'home_exchange_rate_source.dart';

class HomeExchangeRateModel {
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

  final HomeExchangeRateSource source;

  const HomeExchangeRateModel({
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

  bool get comesFromLastTransaction =>
      source == HomeExchangeRateSource.lastTransaction;

  bool get isDefaultAvailable =>
      source == HomeExchangeRateSource.defaultAvailable;
}
