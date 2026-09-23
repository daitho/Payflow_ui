import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/transfer_quote.dart';
import 'package:pay_flow_ui/features/transfer/domain/service/transfer_funding_availability.dart';

void main() {
  test('Apple Pay and PayPal are always visible', () {
    final methods = TransferFundingAvailability.resolve(
      supportsGooglePay: false,
      hasSavedCard: false,
    );

    expect(methods, [
      TransferFundingMethod.applePay,
      TransferFundingMethod.paypal,
    ]);
  });

  test('Google Pay is added on supported platforms', () {
    final methods = TransferFundingAvailability.resolve(
      supportsGooglePay: true,
      hasSavedCard: false,
    );

    expect(methods, contains(TransferFundingMethod.googlePay));
  });

  test('card is hidden until a saved card exists', () {
    final hidden = TransferFundingAvailability.resolve(
      supportsGooglePay: true,
      hasSavedCard: false,
    );
    final visible = TransferFundingAvailability.resolve(
      supportsGooglePay: true,
      hasSavedCard: true,
    );

    expect(hidden, isNot(contains(TransferFundingMethod.card)));
    expect(visible, contains(TransferFundingMethod.card));
  });
}
