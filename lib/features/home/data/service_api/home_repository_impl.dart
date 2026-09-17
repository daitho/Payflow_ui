import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../dto/home_dto.dart';

class HomeApiService {
  final Dio _dio;

  const HomeApiService({
    required Dio dio,
  }) : _dio = dio;

  Future<HomeDto> getHome() async {
    final Response<dynamic> response =
    await _dio.get(
      ApiEndpoints.home,
    );

    final dynamic data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid home response format.',
      );
    }

    return HomeDto.fromJson(
      data,
    );
  }
}