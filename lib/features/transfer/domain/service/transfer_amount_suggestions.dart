abstract final class TransferAmountSuggestions {
  static const List<num> _standard = [20, 50, 100, 150, 200];

  static const Map<String, List<num>> _byCurrency = {
    'EUR': _standard,
    'USD': _standard,
    'CAD': _standard,
    'GBP': _standard,
    'CHF': _standard,
    'AUD': _standard,
    'NZD': _standard,
    'CNY': [100, 300, 500, 800, 1000],
    'HKD': [200, 500, 1000, 1500, 2000],
    'INR': [1000, 2500, 5000, 7500, 10000],
    'JPY': [2000, 5000, 10000, 15000, 20000],
    'KRW': [20000, 50000, 100000, 150000, 200000],
    'SGD': [20, 50, 100, 150, 200],
  };

  static List<num> forCurrency(String currencyCode) =>
      List.unmodifiable(
        _byCurrency[currencyCode.trim().toUpperCase()] ?? _standard,
      );
}
