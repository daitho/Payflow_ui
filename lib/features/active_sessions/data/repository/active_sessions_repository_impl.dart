import 'package:dio/dio.dart';

import '../../domain/exception/active_sessions_exception.dart';
import '../../domain/model/active_session_model.dart';
import '../../domain/repository/active_sessions_repository.dart';
import '../service_api/active_sessions_api_service.dart';

class ActiveSessionsRepositoryImpl implements ActiveSessionsRepository {
  final ActiveSessionsApiService _apiService;

  ActiveSessionsRepositoryImpl({required ActiveSessionsApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<ActiveSessionModel>> getSessions() async {
    try {
      final dtos = await _apiService.getSessions();

      return dtos.map((dto) => dto.toModel()).toList();
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (_) {
      throw const ActiveSessionsException(ActiveSessionsErrorType.unexpected);
    }
  }

  @override
  Future<void> revokeSession({required String sessionId}) async {
    try {
      await _apiService.revokeSession(sessionId: sessionId);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (_) {
      throw const ActiveSessionsException(ActiveSessionsErrorType.unexpected);
    }
  }

  @override
  Future<void> logoutOthers() async {
    try {
      await _apiService.logoutOthers();
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (_) {
      throw const ActiveSessionsException(ActiveSessionsErrorType.unexpected);
    }
  }

  @override
  Future<void> logoutCurrent({required String refreshToken}) async {
    try {
      await _apiService.logoutCurrent(refreshToken: refreshToken);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (_) {
      throw const ActiveSessionsException(ActiveSessionsErrorType.unexpected);
    }
  }

  ActiveSessionsException _mapDioException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const ActiveSessionsException(ActiveSessionsErrorType.network);
    }

    final int? statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return const ActiveSessionsException(
        ActiveSessionsErrorType.unauthorized,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return const ActiveSessionsException(ActiveSessionsErrorType.server);
    }

    return const ActiveSessionsException(ActiveSessionsErrorType.unexpected);
  }
}
