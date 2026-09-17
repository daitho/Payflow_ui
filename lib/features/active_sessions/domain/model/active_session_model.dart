class ActiveSessionModel {
  final String sessionId;
  final String? deviceId;
  final String? deviceName;
  final String? userAgent;
  final String? creationIp;

  final DateTime sessionCreatedAt;
  final DateTime? lastUsedAt;
  final DateTime expiresAt;

  const ActiveSessionModel({
    required this.sessionId,
    required this.deviceId,
    required this.deviceName,
    required this.userAgent,
    required this.creationIp,
    required this.sessionCreatedAt,
    required this.lastUsedAt,
    required this.expiresAt,
  });
}