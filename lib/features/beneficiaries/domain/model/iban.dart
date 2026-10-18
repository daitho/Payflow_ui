/// Early feedback only. The authenticated backend validates and encrypts the account.
String normalizeIban(String value) => value.replaceAll(RegExp(r'[\s\u00a0\u202f]'), '').toUpperCase();
bool isSupportedIban(String input) {
  if (!RegExp(r'^[A-Za-z0-9\s\u00a0\u202f]+$').hasMatch(input)) return false;
  final value = normalizeIban(input);
  if (value.length < 15 || value.length > 34) return false;
  const patterns = {
    'FR': r'[0-9]{10}[A-Z0-9]{11}[0-9]{2}', 'DE': r'[0-9]{18}',
    'ES': r'[0-9]{20}', 'IT': r'[A-Z][0-9]{10}[A-Z0-9]{12}',
    'LU': r'[0-9]{3}[A-Z0-9]{13}', 'CH': r'[0-9]{5}[A-Z0-9]{12}',
    'GB': r'[A-Z]{4}[0-9]{14}',
  };
  if (!RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]+$').hasMatch(value)) return false;
  final pattern = patterns[value.substring(0, 2)];
  if (pattern == null || !RegExp('^$pattern\$').hasMatch(value.substring(4))) return false;
  var remainder = 0;
  for (final c in (value.substring(4) + value.substring(0, 4)).codeUnits) {
    final n = c >= 65 ? c - 65 + 10 : c - 48;
    remainder = (remainder * (n >= 10 ? 100 : 10) + n) % 97;
  }
  return remainder == 1;
}
