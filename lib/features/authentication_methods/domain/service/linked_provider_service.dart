import '../model/linked_provider.dart';
import '../repository/linked_provider_repository.dart';

class LinkedProviderService {
  final LinkedProviderRepository _repository;

  const LinkedProviderService(this._repository);

  Future<List<LinkedProvider>> list() => _repository.list();

  Future<LinkedProvider> link({
    required ExternalProvider provider,
    required String credential,
    required String currentPassword,
    String? expectedNonce,
  }) => _repository.link(
    provider: provider,
    credential: credential,
    currentPassword: currentPassword,
    expectedNonce: expectedNonce,
  );
}
