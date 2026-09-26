import '../model/linked_provider.dart';

abstract class LinkedProviderRepository {
  Future<List<LinkedProvider>> list();

  Future<LinkedProvider> link({
    required ExternalProvider provider,
    required String credential,
    required String currentPassword,
    String? expectedNonce,
  });
}
