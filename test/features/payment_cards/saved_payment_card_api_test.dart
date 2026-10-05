import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_flow_ui/features/payment_cards/data/service_api/saved_payment_card_api_service.dart';
import 'package:pay_flow_ui/features/payment_cards/domain/model/saved_payment_card.dart';

class _Adapter implements HttpClientAdapter {
  RequestOptions? request;
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    request = options;
    return ResponseBody.fromBytes(utf8.encode(jsonEncode({
      'id': 'card-1', 'holderName': 'Amina Test', 'brand': 'VISA',
      'lastFour': '4242', 'expiryMonth': 12, 'expiryYear': 2030,
    })), 201, headers: {Headers.contentTypeHeader: ['application/json']});
  }
  @override
  void close({bool force = false}) {}
}

void main() {
  test('card registration sends display metadata without a card number or CVV', () async {
    final adapter = _Adapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://payflow.test'));
    dio.httpClientAdapter = adapter;
    final saved = await SavedPaymentCardApiService(dio).add(
      const NewSavedPaymentCard(holderName: 'Amina Test', brand: 'VISA',
          lastFour: '4242', expiryMonth: 12, expiryYear: 2030),
    );
    expect(saved.maskedNumber, '•••• 4242');
    expect(adapter.request!.path, '/api/v1/payment-cards');
    expect(adapter.request!.data, {
      'holderName': 'Amina Test', 'brand': 'VISA', 'lastFour': '4242',
      'expiryMonth': 12, 'expiryYear': 2030,
    });
    dio.close(force: true);
  });
}
