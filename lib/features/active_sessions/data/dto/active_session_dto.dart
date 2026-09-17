import '../../domain/model/active_session_model.dart';

class ActiveSessionDto {
  final String sessionId;
  final String? deviceId;
  final String? deviceName;
  final String? userAgent;
  final String? creationIp;

  final DateTime sessionCreatedAt;
  final DateTime? lastUsedAt;
  final DateTime expiresAt;

  const ActiveSessionDto({
    required this.sessionId,
    required this.deviceId,
    required this.deviceName,
    required this.userAgent,
    required this.creationIp,
    required this.sessionCreatedAt,
    required this.lastUsedAt,
    required this.expiresAt,
  });

  factory ActiveSessionDto.fromJson(
      Map<String, dynamic> json,
      ) {
    return ActiveSessionDto(
      sessionId:
      json['sessionId'] as String,

      deviceId:
      json['deviceId'] as String?,

      deviceName:
      json['deviceName'] as String?,

      userAgent:
      json['userAgent'] as String?,

      creationIp:
      json['creationIp'] as String?,

      sessionCreatedAt:
      DateTime.parse(
        json['sessionCreatedAt'] as String,
      ),

      lastUsedAt:
      json['lastUsedAt'] == null
          ? null
          : DateTime.parse(
        json['lastUsedAt'] as String,
      ),

      expiresAt:
      DateTime.parse(
        json['expiresAt'] as String,
      ),
    );
  }

  ActiveSessionModel toModel() {
    return ActiveSessionModel(
      sessionId: sessionId,
      deviceId: deviceId,
      deviceName: deviceName,
      userAgent: userAgent,
      creationIp: creationIp,
      sessionCreatedAt:
      sessionCreatedAt,
      lastUsedAt:
      lastUsedAt,
      expiresAt:
      expiresAt,
    );
  }
}