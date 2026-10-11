abstract final class TransferErrorCodes {
  static const String beneficiaryNotFound = 'BENEFICIARY_NOT_FOUND';
  static const String destinationNotFound = 'BEN_002';
  static const String paymentOperatorUnavailable = 'PAYMENT_OPERATOR_NOT_AVAILABLE';
  static const String paymentOperatorNotFound = 'PAYMENT_OPERATOR_NOT_FOUND';
  static const String countryOperatorNotFound = 'COUNTRY_OPERATOR_NOT_FOUND';
  static const String amountBelowMinimum = 'QUOTE_008';
  static const String amountAboveMaximum = 'QUOTE_009';
  static const String paymentProviderUnavailable = 'PAYMENT_001';
  static const String paymentProviderError = 'PAYMENT_002';
  static const String paymentIntentNotFound = 'PAYMENT_003';
  static const String paymentNotReady = 'PAYMENT_004';
  static const String paymentCaptureFailed = 'PAYMENT_005';
  static const String paymentAmountMismatch = 'PAYMENT_006';
  static const String paymentRequired = 'PAYMENT_007';
  static const String paymentNotCompleted = 'PAYMENT_008';
  static const String cardNotFound = 'CARD_001';
  static const String cardInvalid = 'CARD_002';
  static const String cardRequired = 'CARD_003';
}
