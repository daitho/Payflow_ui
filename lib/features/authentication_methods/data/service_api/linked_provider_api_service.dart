import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../domain/model/linked_provider.dart';
import '../dto/linked_provider_dto.dart';

class LinkedProviderApiService {
  final Dio _dio;

  const LinkedProviderApiService(this._dio);

  Future<List<LinkedProviderDto>> list() async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.accountExternalIdentities,
    );
    final data = response.data;
    if (data == null) throw const FormatException('Empty provider response');
    return data
        .map((item) => LinkedProviderDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }

  Future<LinkedProviderDto> link({
    required ExternalProvider provider,
    required String credential,
    required String currentPassword,
    String? expectedNonce,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.accountExternalIdentity(provider.apiValue),
      data: {
        'credential': credential,
        'currentPassword': currentPassword,
        if (expectedNonce != null) 'expectedNonce': expectedNonce,
      },
    );
    final data = response.data;
    if (data == null) throw const FormatException('Empty provider response');
    return LinkedProviderDto.fromJson(data);
  }
}
