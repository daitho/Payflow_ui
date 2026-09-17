import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../device/device_context.dart';

class DeviceService {
  static const String _deviceIdStorageKey = 'payflow.device.id';

  final FlutterSecureStorage _secureStorage;
  final DeviceInfoPlugin _deviceInfoPlugin;
  final Uuid _uuid;

  DeviceService({
    required FlutterSecureStorage secureStorage,
    DeviceInfoPlugin? deviceInfoPlugin,
    Uuid? uuid,
  }) : _secureStorage = secureStorage,
       _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin(),
       _uuid = uuid ?? const Uuid();

  // =========================================================
  // PUBLIC
  // =========================================================

  Future<DeviceContext> getDeviceContext() async {
    final String deviceId = await _getOrCreateDeviceId();

    final String deviceName = await _getDeviceName();

    return DeviceContext(deviceId: deviceId, deviceName: deviceName);
  }

  // =========================================================
  // DEVICE ID
  // =========================================================

  Future<String> _getOrCreateDeviceId() async {
    final String? storedDeviceId = await _secureStorage.read(
      key: _deviceIdStorageKey,
    );

    if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
      return storedDeviceId;
    }

    final String newDeviceId = _uuid.v4();

    await _secureStorage.write(key: _deviceIdStorageKey, value: newDeviceId);

    return newDeviceId;
  }

  // =========================================================
  // DEVICE NAME
  // =========================================================

  Future<String> _getDeviceName() async {
    try {
      if (kIsWeb) {
        final info = await _deviceInfoPlugin.webBrowserInfo;

        return _normalizeDeviceName('${info.browserName.name} browser');
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final info = await _deviceInfoPlugin.androidInfo;

          return _normalizeDeviceName('${info.brand} ${info.model}');

        case TargetPlatform.iOS:
          final info = await _deviceInfoPlugin.iosInfo;

          return _normalizeDeviceName(
            info.name.isNotEmpty ? info.name : info.model,
          );

        default:
          return 'PayFlow device';
      }
    } catch (_) {
      return 'PayFlow device';
    }
  }

  // =========================================================
  // NORMALIZATION
  // =========================================================

  String _normalizeDeviceName(String value) {
    final String cleanValue = value.trim();

    if (cleanValue.isEmpty) {
      return 'PayFlow device';
    }

    // Backend :
    // @Size(max = 160) String deviceName

    if (cleanValue.length <= 160) {
      return cleanValue;
    }

    return cleanValue.substring(0, 160);
  }
}
