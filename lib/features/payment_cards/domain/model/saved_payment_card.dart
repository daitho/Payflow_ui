class SavedPaymentCard {
  const SavedPaymentCard({
    required this.id,
    required this.holderName,
    required this.brand,
    required this.lastFour,
    required this.expiryMonth,
    required this.expiryYear,
    this.tokenized = false,
  });

  final String id;
  final String holderName;
  final String brand;
  final String lastFour;
  final int expiryMonth;
  final int expiryYear;
  final bool tokenized;

  String get displayLabel => '${brand == 'VISA' ? 'Visa' : brand == 'MASTERCARD' ? 'Mastercard' : brand} •••• $lastFour';

  String get maskedNumber => '•••• $lastFour';
  String get expiry {
    final month = expiryMonth.toString().padLeft(2, '0');
    final year = (expiryYear % 100).toString().padLeft(2, '0');
    return '$month/$year';
  }
  bool get expired {
    final now = DateTime.now();
    return expiryYear < now.year ||
        (expiryYear == now.year && expiryMonth < now.month);
  }
}

class NewSavedPaymentCard {
  const NewSavedPaymentCard({
    required this.holderName,
    required this.brand,
    required this.lastFour,
    required this.expiryMonth,
    required this.expiryYear,
  });

  final String holderName;
  final String brand;
  final String lastFour;
  final int expiryMonth;
  final int expiryYear;
}
