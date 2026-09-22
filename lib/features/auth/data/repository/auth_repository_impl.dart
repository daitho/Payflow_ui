import '../../../../core/service/device_service.dart';
import '../../domain/model/auth_session_model.dart';
import '../../domain/model/login_credentials.dart';
import '../../domain/model/register_command.dart';
import '../../domain/model/verification_challenge_model.dart';
import '../../domain/model/verification_channel.dart';
import '../../domain/model/identifier_verification_status_model.dart';
import '../../domain/repository/auth_repository.dart';

import '../dto/login_request_dto.dart';
import '../dto/recover_verification_request_dto.dart';
import '../dto/refresh_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../dto/confirm_verification_request_dto.dart';
import '../dto/resend_verification_request_dto.dart';
import '../service_api/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final DeviceService _deviceService;

  const AuthRepositoryImpl({
    required AuthApiService authApiService,
    required DeviceService deviceService,
  }) : _authApiService = authApiService,
       _deviceService = deviceService;

  // =========================================================
  // LOGIN
  // =========================================================

  @override
  Future<AuthSessionModel> login(LoginCredentials credentials) async {
    final deviceContext = await _deviceService.getDeviceContext();
    final request = LoginRequestDto(
      identifier: credentials.identifier,
      password: credentials.password,
      deviceId: deviceContext.deviceId,
      deviceName: deviceContext.deviceName,
    );

    final response = await _authApiService.login(request);

    return response.toModel();
  }

  @override
  Future<VerificationChallengeModel> recoverVerification({
    required String identifier,
    required String password,
    required VerificationChannel channel,
  }) async {
    final response = await _authApiService.recoverVerification(
      RecoverVerificationRequestDto(
        identifier: identifier,
        password: password,
        channel: channel,
      ),
    );
    return response.toModel();
  }

  // =========================================================
  // REGISTER
  // =========================================================

  @override
  Future<VerificationChallengeModel> register(
    RegisterCommand command,
  ) async {
    final deviceContext = await _deviceService.getDeviceContext();
    var registerRequestDto = RegisterRequestDto(
      lastName: command.lastName,
      firstName: command.firstName,
      email: command.email,
      password: command.password,
      phoneE164: command.phoneE164,
      residenceCountryIsoCode2:
          command.residenceCountryIsoCode2,
      verificationChannel: command.verificationChannel.apiValue,
      deviceId: deviceContext.deviceId,
      deviceName: deviceContext.deviceName,
    );
    final request = registerRequestDto;

    final response = await _authApiService.register(request);

    return response.toModel();
  }

  @override
  Future<AuthSessionModel> confirmVerification({
    required String challengeId,
    required String code,
  }) async {
    final deviceContext = await _deviceService.getDeviceContext();
    final response = await _authApiService.confirmVerification(
      ConfirmVerificationRequestDto(
        challengeId: challengeId,
        code: code,
        deviceId: deviceContext.deviceId,
        deviceName: deviceContext.deviceName,
      ),
    );
    return response.toModel();
  }

  @override
  Future<VerificationChallengeModel> resendVerification({
    required String challengeId,
    required VerificationChannel channel,
  }) async {
    final response = await _authApiService.resendVerification(
      ResendVerificationRequestDto(
        challengeId: challengeId,
        channel: channel.apiValue,
      ),
    );
    return response.toModel();
  }

  @override
  Future<IdentifierVerificationStatusModel>
  identifierVerificationStatus() async {
    final response =
        await _authApiService.identifierVerificationStatus();
    return response.toModel();
  }

  @override
  Future<VerificationChallengeModel>
  startIdentifierVerification(
    VerificationChannel channel,
  ) async {
    final response =
        await _authApiService.startIdentifierVerification(
      channel,
    );
    return response.toModel();
  }

  @override
  Future<IdentifierVerificationStatusModel>
  confirmIdentifierVerification({
    required String challengeId,
    required String code,
  }) async {
    final response =
        await _authApiService.confirmIdentifierVerification(
      ConfirmVerificationRequestDto(
        challengeId: challengeId,
        code: code,
      ),
    );
    return response.toModel();
  }

  // =========================================================
  // REFRESH
  // =========================================================
  @override
  Future<AuthSessionModel> refresh(String refreshToken) async {
    final request = RefreshRequestDto(refreshToken: refreshToken);

    final response = await _authApiService.refresh(request);

    return response.toModel();
  }
}
