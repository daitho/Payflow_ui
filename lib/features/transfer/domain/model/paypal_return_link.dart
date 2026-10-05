enum PaypalReturnAction { approved, cancelled }

/// Only a callback for the current payment may advance its checkout.
PaypalReturnAction? paypalReturnAction(Uri uri, String paymentIntentId) {
  if (uri.scheme != 'payflow' ||
      uri.host != 'paypal' ||
      uri.queryParameters['paymentIntentId'] != paymentIntentId) {
    return null;
  }
  return switch (uri.path) {
    '/return' => PaypalReturnAction.approved,
    '/cancel' => PaypalReturnAction.cancelled,
    _ => null,
  };
}
