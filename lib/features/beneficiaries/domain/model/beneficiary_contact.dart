enum BeneficiaryGender { male, female }

class BeneficiaryContact {
  final String id, fullName, countryId, countryName, countryCode;
  final String? destinationId,
      operatorId,
      operatorName,
      phoneE164,
      currencyCode;
  final BeneficiaryGender? gender;
  final bool favorite;
  const BeneficiaryContact({
    required this.id,
    required this.fullName,
    required this.countryId,
    required this.countryName,
    required this.countryCode,
    this.destinationId,
    this.operatorId,
    this.operatorName,
    this.phoneE164,
    this.currencyCode,
    this.gender,
    this.favorite = false,
  });
}

class BeneficiaryCountry {
  final String id, name, isoCode, phoneCode;
  const BeneficiaryCountry(this.id, this.name, this.isoCode, this.phoneCode);
}

class BeneficiaryOperator {
  final String id, countryId, name, currencyCode;
  const BeneficiaryOperator(
    this.id,
    this.countryId,
    this.name,
    this.currencyCode,
  );
}

class BeneficiaryCatalog {
  final List<BeneficiaryCountry> countries;
  final List<BeneficiaryOperator> operators;
  BeneficiaryCatalog(
    List<BeneficiaryCountry> countries,
    List<BeneficiaryOperator> operators,
  ) : countries = List.unmodifiable(countries),
      operators = List.unmodifiable(operators);
}

class BeneficiaryContactInput {
  final String fullName, countryId, operatorId, phoneE164;
  final BeneficiaryGender? gender;
  const BeneficiaryContactInput({
    required this.fullName,
    required this.countryId,
    required this.operatorId,
    required this.phoneE164,
    this.gender,
  });
}

/// Stable Latin normalization for search and alphabet-based avatars.
String beneficiarySearchKey(String value) {
  var result = value.trim().toUpperCase();
  const replacements = {
    'ÀÁÂÃÄÅ': 'A',
    'Ç': 'C',
    'ÈÉÊË': 'E',
    'ÌÍÎÏ': 'I',
    'Ñ': 'N',
    'ÒÓÔÕÖØ': 'O',
    'ÙÚÛÜ': 'U',
    'ÝŸ': 'Y',
    'Œ': 'OE',
    'Æ': 'AE',
  };
  for (final entry in replacements.entries) {
    for (final letter in entry.key.split('')) {
      result = result.replaceAll(letter, entry.value);
    }
  }
  return result.replaceAll(RegExp(r'\s+'), ' ');
}
