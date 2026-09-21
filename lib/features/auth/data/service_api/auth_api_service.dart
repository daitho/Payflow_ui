import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';

import '../../domain/exception/login_exception.dart';
import '../../domain/exception/session_expired_exception.dart';
import '../dto/auth_session_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/refresh_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../dto/verification_challenge_dto.dart';
import '../dto/confirm_verification_request_dto.dart';
import '../dto/resend_verification_request_dto.dart';
import '../dto/identifier_verification_status_dto.dart';
import '../../domain/model/verification_channel.dart';
import '../../domain/exception/verification_exception.dart';

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

  Future<VerificationChallengeDto> register(
    RegisterRequestDto request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.authRegister,
      data: request.toJson(),
    );

    final data = response.data;

    if (data == null) {
      throw StateError('Empty register response');
    }

    return VerificationChallengeDto.fromJson(data);
  }

  Future<AuthSessionDto> confirmVerification(
    ConfirmVerificationRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authVerificationConfirm,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(
          VerificationErrorType.unexpected,
        );
      }
      return AuthSessionDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
  }

  Future<VerificationChallengeDto> resendVerification(
    ResendVerificationRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authVerificationResend,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(
          VerificationErrorType.unexpected,
        );
      }
      return VerificationChallengeDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
  }

  VerificationException _mapVerificationException(
    DioException exception,
  ) {
    final data = exception.response?.data;
    final code = data is Map<String, dynamic>
        ? data['code'] as String?
        : null;

    return switch (code) {
      'VERIFY_002' => const VerificationException(
          VerificationErrorType.invalidCode,
        ),
      'VERIFY_003' => const VerificationException(
          VerificationErrorType.expired,
        ),
      'VERIFY_004' => const VerificationException(
          VerificationErrorType.tooManyAttempts,
        ),
      'VERIFY_005' => const VerificationException(
          VerificationErrorType.resendTooSoon,
        ),
      'VERIFY_006' => const VerificationException(
          VerificationErrorType.channelUnavailable,
        ),
      _ when exception.type == DioExceptionType.connectionError =>
        const VerificationException(VerificationErrorType.network),
      _ => const VerificationException(
          VerificationErrorType.unexpected,
        ),
    };
  }

  Future<IdentifierVerificationStatusDto>
  identifierVerificationStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.accountIdentifiers,
    );
    final data = response.data;
    if (data == null) {
      throw const VerificationException(
        VerificationErrorType.unexpected,
      );
    }
    return IdentifierVerificationStatusDto.fromJson(data);
  }

  Future<VerificationChallengeDto> startIdentifierVerification(
    VerificationChannel channel,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.accountIdentifierVerification(
          channel.apiValue,
        ),
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(
          VerificationErrorType.unexpected,
        );
      }
      return VerificationChallengeDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
  }

  Future<IdentifierVerificationStatusDto>
  confirmIdentifierVerification(
    ConfirmVerificationRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.accountIdentifierVerificationConfirm,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(
          VerificationErrorType.unexpected,
        );
      }
      return IdentifierVerificationStatusDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
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
