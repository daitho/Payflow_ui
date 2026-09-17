import 'package:dio/dio.dart';

import '../dto/available_exchange_rate_dto.dart';

abstract interface class ExchangeRateApiService {
  Future<List<AvailableExchangeRateDto>>
  getAvailableExchangeRates();
}

final class ExchangeRateApiServiceImpl
    implements ExchangeRateApiService {
  final Dio _dio;

  ExchangeRateApiServiceImpl(
      this._dio,
      );

  @override
  Future<List<AvailableExchangeRateDto>>
  getAvailableExchangeRates() async {
    final Response<List<dynamic>> response =
    await _dio.get<List<dynamic>>(
      '/api/v1/exchange-rates',
    );

    final List<dynamic> data =
        response.data ?? const [];

    return data
        .map(
          (dynamic item) =>
          AvailableExchangeRateDto.fromJson(
            Map<String, dynamic>.from(
              item as Map,
            ),
          ),
    )
        .toList(
      growable: false,
    );
  }
}