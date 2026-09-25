import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_error_codes.dart';
import '../../domain/exception/password_reset_exception.dart';
import '../dto/complete_password_reset_request_dto.dart';
import '../dto/password_reset_token_dto.dart';
import '../dto/request_password_reset_request_dto.dart';
import '../dto/resend_password_reset_request_dto.dart';
import '../dto/verification_challenge_dto.dart';
import '../dto/verify_password_reset_request_dto.dart';

class PasswordResetApiService {
  final Dio _dio;

  const PasswordResetApiService({required Dio dio}) : _dio = dio;

  Future<VerificationChallengeDto> requestReset(
    RequestPasswordResetRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authPasswordForgot,
        data: request.toJson(),
      );
      return VerificationChallengeDto.fromJson(
        _requiredData(response),
      );
    } on DioException catch (exception) {
      throw _mapException(exception);
    } on PasswordResetException {
      rethrow;
    } catch (_) {
      throw const PasswordResetException(
        PasswordResetErrorType.unexpected,
      );
    }
  }

  Future<VerificationChallengeDto> resendCode(
    ResendPasswordResetRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authPasswordForgotResend,
        data: request.toJson(),
      );
      return VerificationChallengeDto.fromJson(
        _requiredData(response),
      );
    } on DioException catch (exception) {
      throw _mapException(exception);
    } on PasswordResetException {
      rethrow;
    } catch (_) {
      throw const PasswordResetException(
        PasswordResetErrorType.unexpected,
      );
    }
  }

  Future<PasswordResetTokenDto> verifyCode(
    VerifyPasswordResetRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.authPasswordForgotVerify,
        data: request.toJson(),
      );
      return PasswordResetTokenDto.fromJson(
        _requiredData(response),
      );
    } on DioException catch (exception) {
      throw _mapException(exception);
    } on PasswordResetException {
      rethrow;
    } catch (_) {
      throw const PasswordResetException(
        PasswordResetErrorType.unexpected,
      );
    }
  }

  Future<void> resetPassword(
    CompletePasswordResetRequestDto request,
  ) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.authPasswordForgotReset,
        data: request.toJson(),
      );
    } on DioException catch (exception) {
      throw _mapException(exception);
    }
  }

  Map<String, dynamic> _requiredData(
    Response<Map<String, dynamic>> response,
  ) {
    final data = response.data;
    if (data == null) {
      throw const PasswordResetException(
        PasswordResetErrorType.unexpected,
      );
    }
    return data;
  }

  PasswordResetException _mapException(
    DioException exception,
  ) {
    final data = exception.response?.data;
    final code = data is Map
        ? data['code']?.toString()
        : null;

    return switch (code) {
      ApiErrorCodes.passwordResetCodeInvalid ||
      ApiErrorCodes.invalidVerificationCode =>
        const PasswordResetException(
          PasswordResetErrorType.invalidCode,
        ),
      ApiErrorCodes.verificationExpired =>
        const PasswordResetException(
          PasswordResetErrorType.expiredCode,
        ),
      ApiErrorCodes.verificationAttemptsExceeded =>
        const PasswordResetException(
          PasswordResetErrorType.tooManyAttempts,
        ),
      ApiErrorCodes.verificationResendTooSoon =>
        const PasswordResetException(
          PasswordResetErrorType.resendTooSoon,
        ),
      ApiErrorCodes.verificationChannelUnavailable =>
        const PasswordResetException(
          PasswordResetErrorType.channelUnavailable,
        ),
      ApiErrorCodes.passwordResetTokenInvalid =>
        const PasswordResetException(
          PasswordResetErrorType.invalidToken,
        ),
      ApiErrorCodes.passwordResetTokenExpired =>
        const PasswordResetException(
          PasswordResetErrorType.expiredToken,
        ),
      ApiErrorCodes.weakPassword =>
        const PasswordResetException(
          PasswordResetErrorType.weakPassword,
        ),
      ApiErrorCodes.passwordConfirmationMismatch =>
        const PasswordResetException(
          PasswordResetErrorType.passwordMismatch,
        ),
      ApiErrorCodes.passwordUnchanged =>
        const PasswordResetException(
          PasswordResetErrorType.passwordUnchanged,
        ),
      _ when exception.type == DioExceptionType.connectionError ||
              exception.type == DioExceptionType.connectionTimeout ||
              exception.type == DioExceptionType.receiveTimeout ||
              exception.type == DioExceptionType.sendTimeout =>
        const PasswordResetException(
          PasswordResetErrorType.network,
        ),
      _ => const PasswordResetException(
        PasswordResetErrorType.unexpected,
      ),
    };
  }
}
