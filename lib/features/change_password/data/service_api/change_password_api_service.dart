import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../dto/change_password_request_dto.dart';

class ChangePasswordApiService {
  final Dio _dio;

  const ChangePasswordApiService({required Dio dio}) : _dio = dio;

  Future<void> changePassword(ChangePasswordRequestDto request) async {
    await _dio.put<void>(ApiEndpoints.accountPassword, data: request.toJson());
  }
}
