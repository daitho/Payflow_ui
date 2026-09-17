import 'user_auth_model.dart';

class AuthSessionModel {
  final String tokenType;
  final String accessToken;
  final DateTime accessExpiresAt;
  final String refreshToken;
  final DateTime refreshExpiresAt;
  final String sessionId;
  final UserAuthModel user;

  const AuthSessionModel({
    required this.tokenType,
    required this.accessToken,
    required this.accessExpiresAt,
    required this.refreshToken,
    required this.refreshExpiresAt,
    required this.sessionId,
    required this.user,
  });
}