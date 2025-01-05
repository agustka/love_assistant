import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/infrastructure/core/cache/i_hive_cache.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:uuid/uuid.dart';

@Singleton()
class DeviceIdProvider {
  static const String _boxName = "theme";
  static const String _deviceIdStorageKey = "colors";

  String _deviceId = "";

  Future<String> get deviceId async {
    if (_deviceId.isEmpty) {
      await initialize();
    }
    return _deviceId;
  }

  final IHiveCache _storage;

  DeviceIdProvider(this._storage);

  Future<void> initialize() async {
    final CacheResponse cache = await _storage.get(boxName: _boxName, key: _deviceIdStorageKey);
    final String uuid = cache.data;
    if (uuid.isNotEmpty) {
      _deviceId = uuid;
      return;
    }

    if (PlatformDetector.isAndroid) {
      final String newUuid = const Uuid().v4();
      await _storage.put(
        boxName: _boxName,
        key: _deviceIdStorageKey,
        data: newUuid,
        expires: DateTime.now().add(5000.days),
      );
      _deviceId = newUuid;
    } else {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final IosDeviceInfo info = await deviceInfo.iosInfo;
      final String id = info.identifierForVendor ?? const Uuid().v4();

      await _storage.put(
        boxName: _boxName,
        key: _deviceIdStorageKey,
        data: id,
        expires: DateTime.now().add(5000.days),
      );

      _deviceId = id;
    }
  }
}
