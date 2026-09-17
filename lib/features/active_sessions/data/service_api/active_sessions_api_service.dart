import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../dto/active_session_dto.dart';

class ActiveSessionsApiService {
  final Dio _dio;

  ActiveSessionsApiService({
    required Dio dio,
  }) : _dio = dio;

  // =========================================================
  // GET ACTIVE SESSIONS
  // =========================================================

  Future<List<ActiveSessionDto>>
  getSessions() async {
    final Response<dynamic> response =
    await _dio.get(
      ApiEndpoints.authSessions,
    );

    final dynamic data =
        response.data;

    if (data is! List) {
      throw const FormatException(
        'Invalid sessions response.',
      );
    }

    return data
        .map(
          (dynamic item) =>
          ActiveSessionDto.fromJson(
            Map<String, dynamic>.from(
              item as Map,
            ),
          ),
    )
        .toList();
  }

  // =========================================================
  // REVOKE ONE SESSION
  // =========================================================
  Future<void> revokeSession({
    required String sessionId,
  }) async {
    await _dio.delete(
      '${ApiEndpoints.authSessions}/$sessionId',
    );
  }

  // =========================================================
  // LOGOUT OTHER SESSIONS
  // =========================================================
  Future<void> logoutOthers() async {
    await _dio.post(
      ApiEndpoints.authLogoutOthers,
    );
  }

  // =========================================================
  // LOGOUT CURRENT SESSION
  // =========================================================
  Future<void> logoutCurrent({
    required String refreshToken,
  }) async {
    await _dio.post(
      ApiEndpoints.authLogout,
      data: {
        'refreshToken': refreshToken,
      },
    );
  }
}