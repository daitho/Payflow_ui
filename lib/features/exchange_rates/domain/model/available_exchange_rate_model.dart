class AvailableExchangeRateModel {
  final String corridorId;

  final String sourceCountryCode;
  final String sourceCountryName;

  final String destinationCountryCode;
  final String destinationCountryName;

  final String sourceCurrencyCode;
  final String sourceCurrencyName;
  final String? sourceCurrencySymbol;

  final String targetCurrencyCode;
  final String targetCurrencyName;
  final String? targetCurrencySymbol;

  /// Conservé en String côté Flutter :
  /// aucun calcul financier ne doit être effectué ici.
  final String rate;

  final String? minAmount;
  final String? maxAmount;

  final DateTime? validFrom;
  final DateTime? validUntil;

  const AvailableExchangeRateModel({
    required this.corridorId,
    required this.sourceCountryCode,
    required this.sourceCountryName,
    required this.destinationCountryCode,
    required this.destinationCountryName,
    required this.sourceCurrencyCode,
    required this.sourceCurrencyName,
    required this.sourceCurrencySymbol,
    required this.targetCurrencyCode,
    required this.targetCurrencyName,
    required this.targetCurrencySymbol,
    required this.rate,
    required this.minAmount,
    required this.maxAmount,
    required this.validFrom,
    required this.validUntil,
  });
}
