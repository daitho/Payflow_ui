import 'package:dio/dio.dart';

import '../../domain/exception/change_password_exception.dart';
import '../../domain/model/change_password_command.dart';
import '../../domain/repository/change_password_repository.dart';
import '../dto/change_password_request_dto.dart';
import '../service_api/change_password_api_service.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordApiService _apiService;

  const ChangePasswordRepositoryImpl({
    required ChangePasswordApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<void> changePassword(ChangePasswordCommand command) async {
    try {
      await _apiService.changePassword(
        ChangePasswordRequestDto(
          currentPassword: command.currentPassword,
          newPassword: command.newPassword,
        ),
      );
    } on DioException catch (exception) {
      throw _mapDioException(exception);
    } catch (_) {
      throw const ChangePasswordException(ChangePasswordErrorType.unexpected);
    }
  }

  ChangePasswordException _mapDioException(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.connectionError) {
      return const ChangePasswordException(ChangePasswordErrorType.network);
    }

    final String? errorCode = _errorCode(exception.response?.data);

    return switch (errorCode) {
      'AUTH_008' => const ChangePasswordException(
        ChangePasswordErrorType.invalidCurrentPassword,
      ),
      'AUTH_003' => const ChangePasswordException(
        ChangePasswordErrorType.weakPassword,
      ),
      'AUTH_009' => const ChangePasswordException(
        ChangePasswordErrorType.unchangedPassword,
      ),
      'AUTH_007' => const ChangePasswordException(
        ChangePasswordErrorType.passwordLoginUnavailable,
      ),
      _ => _mapStatusCode(exception.response?.statusCode),
    };
  }

  ChangePasswordException _mapStatusCode(int? statusCode) {
    if (statusCode == 401) {
      return const ChangePasswordException(
        ChangePasswordErrorType.sessionExpired,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return const ChangePasswordException(ChangePasswordErrorType.server);
    }

    return const ChangePasswordException(ChangePasswordErrorType.unexpected);
  }

  String? _errorCode(Object? data) {
    if (data is Map) {
      final Object? code = data['code'];
      return code?.toString();
    }

    return null;
  }
}
