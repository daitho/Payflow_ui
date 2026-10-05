import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/transfer/domain/model/paypal_return_link.dart';

void main() {
  test('approval callback belongs to the active PayPal payment', () {
    final url = Uri.parse(
      'payflow://paypal/return?paymentIntentId=active&token=provider-token',
    );
    expect(paypalReturnAction(url, 'active'), PaypalReturnAction.approved);
    expect(paypalReturnAction(url, 'another'), isNull);
  });

  test('cancellation does not authorize a capture', () {
    final url = Uri.parse('payflow://paypal/cancel?paymentIntentId=active');
    expect(paypalReturnAction(url, 'active'), PaypalReturnAction.cancelled);
    expect(
      paypalReturnAction(
        Uri.parse('payflow://other/return?paymentIntentId=active'),
        'active',
      ),
      isNull,
    );
  });
}
