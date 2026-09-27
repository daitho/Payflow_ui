import '../../domain/model/linked_provider.dart';
import '../../domain/repository/linked_provider_repository.dart';
import '../service_api/linked_provider_api_service.dart';

class LinkedProviderRepositoryImpl implements LinkedProviderRepository {
  final LinkedProviderApiService _api;

  const LinkedProviderRepositoryImpl(this._api);

  @override
  Future<List<LinkedProvider>> list() async =>
      (await _api.list()).map((item) => item.toModel()).toList();

  @override
  Future<LinkedProvider> link({
    required ExternalProvider provider,
    required String credential,
    required String currentPassword,
    String? expectedNonce,
  }) async =>
      (await _api.link(
        provider: provider,
        credential: credential,
        currentPassword: currentPassword,
        expectedNonce: expectedNonce,
      )).toModel();
}
