enum HomeExchangeRateSource {
  lastTransaction,
  defaultAvailable,
  unknown;

  factory HomeExchangeRateSource.fromApi(
      String value,
      ) {
    switch (value) {
      case 'LAST_TRANSACTION':
        return HomeExchangeRateSource
            .lastTransaction;

      case 'DEFAULT_AVAILABLE':
        return HomeExchangeRateSource
            .defaultAvailable;

      default:
        return HomeExchangeRateSource.unknown;
    }
  }
}