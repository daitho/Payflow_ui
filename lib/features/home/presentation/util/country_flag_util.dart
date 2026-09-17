class CountryFlagUtil {
  CountryFlagUtil._();

  static String fromIsoCode2(String? isoCode2) {
    if (isoCode2 == null) {
      return '';
    }
    final String code = isoCode2.trim().toUpperCase();
    if (code.length != 2) {
      return '';
    }
    const int regionalIndicatorOffset = 0x1F1E6 - 0x41;
    return String.fromCharCodes(
      code.codeUnits.map((unit) => unit + regionalIndicatorOffset),
    );
  }

  // =========================================================
  // CURRENCY DISPLAY FLAG
  // =========================================================
  static String forCurrency({
    required String currencyCode,
    String? countryIsoCode2,
  }) {
    /*
     * EUR est représenté par le drapeau européen
     * dans la maquette PayFlow.
     */
    if (currencyCode.toUpperCase() == 'EUR') {
      return fromIsoCode2('EU');
    }
    return fromIsoCode2(countryIsoCode2);
  }
}
