import '../../domain/model/auth_session_model.dart';
import 'user_auth_dto.dart';

class AuthSessionDto {
  final String tokenType;
  final String accessToken;
  final DateTime accessExpiresAt;
  final String refreshToken;
  final DateTime refreshExpiresAt;
  final String sessionId;
  final UserAuthDto user;

  const AuthSessionDto({
    required this.tokenType,
    required this.accessToken,
    required this.accessExpiresAt,
    required this.refreshToken,
    required this.refreshExpiresAt,
    required this.sessionId,
    required this.user,
  });

  factory AuthSessionDto.fromJson(
      Map<String, dynamic> json,
      ) {
    return AuthSessionDto(
      tokenType: json['tokenType'] as String,
      accessToken: json['accessToken'] as String,
      accessExpiresAt: DateTime.parse(
        json['accessExpiresAt'] as String,
      ),
      refreshToken: json['refreshToken'] as String,
      refreshExpiresAt: DateTime.parse(
        json['refreshExpiresAt'] as String,
      ),
      sessionId: json['sessionId'] as String,

      user: UserAuthDto.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }

  AuthSessionModel toModel() {
    return AuthSessionModel(
      tokenType: tokenType,
      accessToken: accessToken,
      accessExpiresAt: accessExpiresAt,
      refreshToken: refreshToken,
      refreshExpiresAt: refreshExpiresAt,
      sessionId: sessionId,
      user: user.toModel(),
    );
  }
}