import '../../domain/model/available_exchange_rate_model.dart';
import '../../domain/repository/exchange_rate_repository.dart';
import '../service_api/exchange_rate_api_service.dart';

final class ExchangeRateRepositoryImpl
    implements ExchangeRateRepository {
  final ExchangeRateApiService _apiService;

  ExchangeRateRepositoryImpl(
      this._apiService
      );

  @override
  Future<List<AvailableExchangeRateModel>>
  getAvailableExchangeRates() async {
    final dtos =
    await _apiService.getAvailableExchangeRates();

    return dtos
        .map(
          (dto) => dto.toDomain(),
    )
        .toList(
      growable: false,
    );
  }
}