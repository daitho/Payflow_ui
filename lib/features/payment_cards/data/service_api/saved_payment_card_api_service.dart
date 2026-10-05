import 'package:dio/dio.dart';

import '../../domain/model/saved_payment_card.dart';

class SavedPaymentCardApiService {
  const SavedPaymentCardApiService(this._dio);
  final Dio _dio;
  static const _path = '/api/v1/payment-cards';

  Future<List<SavedPaymentCard>> list() async {
    final response = await _dio.get<List<dynamic>>(_path);
    return (response.data ?? const [])
        .map((value) => _fromJson(value as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<SavedPaymentCard> add(NewSavedPaymentCard card) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _path,
      data: {
        'holderName': card.holderName.trim(),
        'brand': card.brand,
        'lastFour': card.lastFour,
        'expiryMonth': card.expiryMonth,
        'expiryYear': card.expiryYear,
      },
    );
    if (response.data == null) throw StateError('Empty saved card response');
    return _fromJson(response.data!);
  }

  Future<void> remove(String id) async {
    await _dio.delete<void>('$_path/${Uri.encodeComponent(id)}');
  }

  SavedPaymentCard _fromJson(Map<String, dynamic> json) => SavedPaymentCard(
    id: json['id'] as String,
    holderName: json['holderName'] as String,
    brand: json['brand'] as String,
    lastFour: json['lastFour'] as String,
    expiryMonth: json['expiryMonth'] as int,
    expiryYear: json['expiryYear'] as int,
    tokenized: json['tokenized'] == true,
  );
}
