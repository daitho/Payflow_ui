import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';

import '../../domain/exception/login_exception.dart';
import '../../domain/exception/session_expired_exception.dart';
import '../dto/auth_session_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/refresh_request_dto.dart';
import '../dto/register_request_dto.dart';

class AuthApiService {
  final Dio _dio;

  const AuthApiService({required Dio dio}) : _dio = dio;

  Future<AuthSessionDto> login(LoginRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authLogin,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const LoginUnexpectedException();
      }
      return AuthSessionDto.fromJson(data);
    } on DioException catch (exception) {
      final int? statusCode = exception.response?.statusCode;

      // =======================================================
      // 401 - EMAIL / PASSWORD INCORRECT
      // =======================================================
      if (statusCode == 401) {
        throw const InvalidCredentialsException();
      }
      // =======================================================
      // SERVER ERROR
      // =======================================================
      if (statusCode != null && statusCode >= 500) {
        throw const LoginServerException();
      }
      // =======================================================
      // TIMEOUT
      // =======================================================
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw const LoginTimeoutException();
        case DioExceptionType.connectionError:
          throw const LoginNetworkException();
        default:
          break;
      }
      // =======================================================
      // PAS DE RÉPONSE HTTP
      // =======================================================
      if (exception.response == null) {
        throw const LoginNetworkException();
      }
      // =======================================================
      // AUTRE ERREUR HTTP
      // =======================================================
      throw const LoginUnexpectedException();
    } on LoginException {
      rethrow;
    } catch (_) {
      /*
     * Exemple :
     * erreur de parsing du JSON AuthResponse.
     */
      throw const LoginUnexpectedException();
    }
  }

  Future<AuthSessionDto> register(RegisterRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authRegister,
      data: request.toJson(),
    );

    final data = response.data;

    if (data == null) {
      throw StateError('Empty register response');
    }

    return AuthSessionDto.fromJson(data);
  }

  // =========================================================
  // REFRESH
  // =========================================================

  Future<AuthSessionDto> refresh(RefreshRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authRefresh,
        data: request.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw StateError('Empty refresh response');
      }

      return AuthSessionDto.fromJson(data);
    } on DioException catch (exception) {
      if (exception.response?.statusCode == 401) {
        throw const SessionExpiredException();
      }

      rethrow;
    }
  }
}
