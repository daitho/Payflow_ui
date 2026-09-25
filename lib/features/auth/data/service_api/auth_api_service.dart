import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_error_codes.dart';

import '../../domain/exception/login_exception.dart';
import '../../domain/exception/registration_exception.dart';
import '../../domain/exception/session_expired_exception.dart';
import '../dto/auth_session_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/recover_verification_request_dto.dart';
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
      final Object? responseData = exception.response?.data;
      final String? errorCode = responseData is Map
          ? responseData['code']?.toString()
          : null;

      if (statusCode == 403 &&
          (errorCode == ApiErrorCodes.identifierNotVerified ||
              errorCode == ApiErrorCodes.accountVerificationRequired)) {
        throw const IdentifierNotVerifiedException();
      }

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

  Future<VerificationChallengeDto> register(RegisterRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authRegister,
        data: request.toJson(),
      );

      final data = response.data;
      if (data == null) {
        throw const RegistrationException(
          message: "La réponse du serveur est incomplète. Réessaie.",
        );
      }
      return VerificationChallengeDto.fromJson(data);
    } on DioException catch (exception) {
      final response = exception.response;
      if (response != null) {
        final body = response.data;
        final code = body is Map ? body['code']?.toString() : null;
        final serverMessage = body is Map ? body['message'] : null;
        final status = response.statusCode ?? 0;

        if (status >= 400 && status < 500) {
          throw RegistrationException(
            code: code,
            message: serverMessage is String && serverMessage.trim().isNotEmpty
                ? serverMessage
                : "Les informations saisies n'ont pas pu être acceptées.",
          );
        }
        throw const RegistrationException(
          message: "Le service est temporairement indisponible. Réessaie plus tard.",
        );
      }

      throw const RegistrationException(
        message: "Impossible de joindre le serveur. Vérifie ta connexion.",
      );
    }
  }

  Future<VerificationChallengeDto> recoverVerification(
    RecoverVerificationRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authVerificationRecover,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(VerificationErrorType.unexpected);
      }
      return VerificationChallengeDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
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
        throw const VerificationException(VerificationErrorType.unexpected);
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
        throw const VerificationException(VerificationErrorType.unexpected);
      }
      return VerificationChallengeDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
  }

  VerificationException _mapVerificationException(DioException exception) {
    final data = exception.response?.data;
    final code = data is Map<String, dynamic> ? data['code'] as String? : null;

    return switch (code) {
      ApiErrorCodes.invalidVerificationCode => const VerificationException(
        VerificationErrorType.invalidCode,
      ),
      ApiErrorCodes.verificationExpired => const VerificationException(
        VerificationErrorType.expired,
      ),
      ApiErrorCodes.verificationAttemptsExceeded => const VerificationException(
        VerificationErrorType.tooManyAttempts,
      ),
      ApiErrorCodes.verificationResendTooSoon => const VerificationException(
        VerificationErrorType.resendTooSoon,
      ),
      ApiErrorCodes.verificationChannelUnavailable =>
        const VerificationException(VerificationErrorType.channelUnavailable),
      _ when exception.type == DioExceptionType.connectionError =>
        const VerificationException(VerificationErrorType.network),
      _ => const VerificationException(VerificationErrorType.unexpected),
    };
  }

  Future<IdentifierVerificationStatusDto> identifierVerificationStatus() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.accountIdentifiers,
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(VerificationErrorType.unexpected);
      }
      return IdentifierVerificationStatusDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
  }

  Future<VerificationChallengeDto> startIdentifierVerification(
    VerificationChannel channel,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.accountIdentifierVerification(channel.apiValue),
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(VerificationErrorType.unexpected);
      }
      return VerificationChallengeDto.fromJson(data);
    } on DioException catch (exception) {
      throw _mapVerificationException(exception);
    }
  }

  Future<IdentifierVerificationStatusDto> confirmIdentifierVerification(
    ConfirmVerificationRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.accountIdentifierVerificationConfirm,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const VerificationException(VerificationErrorType.unexpected);
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
