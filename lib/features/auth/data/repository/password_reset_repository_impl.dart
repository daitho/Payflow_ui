import '../../domain/model/password_reset_token_model.dart';
import '../../domain/model/verification_challenge_model.dart';
import '../../domain/model/verification_channel.dart';
import '../../domain/repository/password_reset_repository.dart';
import '../dto/complete_password_reset_request_dto.dart';
import '../dto/request_password_reset_request_dto.dart';
import '../dto/resend_password_reset_request_dto.dart';
import '../dto/verify_password_reset_request_dto.dart';
import '../service_api/password_reset_api_service.dart';

class PasswordResetRepositoryImpl
    implements PasswordResetRepository {
  final PasswordResetApiService _apiService;

  const PasswordResetRepositoryImpl({
    required PasswordResetApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<VerificationChallengeModel> requestReset(
    String identifier,
  ) async {
    final response = await _apiService.requestReset(
      RequestPasswordResetRequestDto(
        identifier: identifier,
      ),
    );
    return response.toModel();
  }

  @override
  Future<VerificationChallengeModel> resendCode({
    required String challengeId,
    required VerificationChannel channel,
  }) async {
    final response = await _apiService.resendCode(
      ResendPasswordResetRequestDto(
        challengeId: challengeId,
        channel: channel.apiValue,
      ),
    );
    return response.toModel();
  }

  @override
  Future<PasswordResetTokenModel> verifyCode({
    required String challengeId,
    required String code,
  }) async {
    final response = await _apiService.verifyCode(
      VerifyPasswordResetRequestDto(
        challengeId: challengeId,
        code: code,
      ),
    );
    return response.toModel();
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    return _apiService.resetPassword(
      CompletePasswordResetRequestDto(
        resetToken: resetToken,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }
}
