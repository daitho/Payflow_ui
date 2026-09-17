import '../model/available_exchange_rate_model.dart';

abstract interface class ExchangeRateRepository {
  Future<List<AvailableExchangeRateModel>>
  getAvailableExchangeRates();
}