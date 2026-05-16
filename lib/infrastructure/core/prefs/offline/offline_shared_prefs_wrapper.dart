import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart';
import 'package:la/setup.dart';

@InjectableEnv.offline
@LazySingleton(as: ISharedPrefsWrapper)
class OfflineSharedPrefsWrapper implements ISharedPrefsWrapper {
  final Map<String, dynamic> _map = {};

  bool tutorialShown = true;

  OfflineSharedPrefsWrapper();

  @override
  Object? get(String key) {
    if (!_map.keys.contains(key)) {
      return null;
    }
    return _map[key];
  }

  @override
  bool containsKey(String key) {
    return _map.containsKey(key);
  }

  @override
  int? getInt(String key) {
    if (!_map.keys.contains(key)) {
      return null;
    }
    return _map[key] as int?;
  }

  @override
  bool? getBool(String key) {
    if (!_map.keys.contains(key)) {
      return null;
    }
    return _map[key] as bool?;
  }

  @override
  DateTime? getDateTime(String key) {
    if (!_map.keys.contains(key)) {
      return null;
    }
    return _map[key] as DateTime?;
  }

  @override
  String? getString(String key) {
    if (!_map.keys.contains(key)) {
      return null;
    }
    return _map[key] as String?;
  }

  @override
  List<String>? getStringList(String key) {
    if (!_map.keys.contains(key)) {
      return null;
    }
    return _map[key] as List<String>?;
  }

  @override
  Future setString(String key, String value) async {
    _map[key] = value;
  }

  @override
  Future setStringList(String key, List<String> value) async {
    _map[key] = value;
  }

  @override
  Future setBool(String key, bool value) async {
    _map[key] = value;
  }

  @override
  Future setInt(String key, int value) async {
    _map[key] = value;
  }

  @override
  Future setDateTime(String key, DateTime dateTime) async {
    _map[key] = dateTime;
  }

  @override
  Future clearUserData() async {
    _map.clear();
  }

  @override
  void reload() {}

  @override
  List<String> getKeys() {
    return _map.keys.toList();
  }

  @override
  Future setDouble(String key, double value) async {
    _map[key] = value;
  }

  @override
  Future remove(String key) async {
    if (_map.containsKey(key)) {
      _map.remove(key);
    }
  }
}
