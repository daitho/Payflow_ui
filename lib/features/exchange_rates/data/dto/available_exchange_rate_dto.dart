import '../../domain/model/available_exchange_rate_model.dart';

class AvailableExchangeRateDto {
  final String corridorId;

  final String sourceCountryCode;
  final String sourceCountryName;

  final String destinationCountryCode;
  final String destinationCountryName;
  final String? destinationCountryFlagUrl;

  final String sourceCurrencyCode;
  final String sourceCurrencyName;
  final String? sourceCurrencySymbol;

  final String targetCurrencyCode;
  final String targetCurrencyName;
  final String? targetCurrencySymbol;

  final String rate;

  final String? minAmount;
  final String? maxAmount;

  final DateTime? validFrom;
  final DateTime? validUntil;

  const AvailableExchangeRateDto({
    required this.corridorId,
    required this.sourceCountryCode,
    required this.sourceCountryName,
    required this.destinationCountryCode,
    required this.destinationCountryName,
    required this.destinationCountryFlagUrl,
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

  factory AvailableExchangeRateDto.fromJson(Map<String, dynamic> json) {
    return AvailableExchangeRateDto(
      corridorId: json['corridorId'] as String,

      sourceCountryCode: json['sourceCountryCode'] as String,

      sourceCountryName: json['sourceCountryName'] as String,

      destinationCountryCode: json['destinationCountryCode'] as String,

      destinationCountryName: json['destinationCountryName'] as String,

      destinationCountryFlagUrl: json['destinationCountryFlagUrl'] as String?,

      sourceCurrencyCode: json['sourceCurrencyCode'] as String,

      sourceCurrencyName: json['sourceCurrencyName'] as String,

      sourceCurrencySymbol: json['sourceCurrencySymbol'] as String?,

      targetCurrencyCode: json['targetCurrencyCode'] as String,

      targetCurrencyName: json['targetCurrencyName'] as String,

      targetCurrencySymbol: json['targetCurrencySymbol'] as String?,

      rate: _decimalToString(json['rate']),

      minAmount: _nullableDecimalToString(json['minAmount']),

      maxAmount: _nullableDecimalToString(json['maxAmount']),

      validFrom: _parseDateTime(json['validFrom']),

      validUntil: _parseDateTime(json['validUntil']),
    );
  }

  AvailableExchangeRateModel toDomain() {
    return AvailableExchangeRateModel(
      corridorId: corridorId,

      sourceCountryCode: sourceCountryCode,
      sourceCountryName: sourceCountryName,

      destinationCountryCode: destinationCountryCode,
      destinationCountryName: destinationCountryName,

      sourceCurrencyCode: sourceCurrencyCode,
      sourceCurrencyName: sourceCurrencyName,
      sourceCurrencySymbol: sourceCurrencySymbol,

      targetCurrencyCode: targetCurrencyCode,
      targetCurrencyName: targetCurrencyName,
      targetCurrencySymbol: targetCurrencySymbol,

      rate: rate,

      minAmount: minAmount,
      maxAmount: maxAmount,

      validFrom: validFrom,
      validUntil: validUntil,
    );
  }

  static String _decimalToString(dynamic value) {
    if (value == null) {
      throw const FormatException('Exchange rate is missing.');
    }

    return value.toString();
  }

  static String? _nullableDecimalToString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }
}
