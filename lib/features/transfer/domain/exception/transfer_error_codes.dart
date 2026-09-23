abstract final class TransferErrorCodes {
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
}
