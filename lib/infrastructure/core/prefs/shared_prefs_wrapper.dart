import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/prefs/i_shared_prefs_wrapper.dart';
import 'package:la/infrastructure/core/prefs/shared_prefs_keys.dart';
import 'package:la/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class SharedPreferencesModule {
  @InjectableEnv.online
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}

@InjectableEnv.online
@LazySingleton(as: ISharedPrefsWrapper)
class SharedPrefsWrapper implements ISharedPrefsWrapper {
  final SharedPreferences _prefs;
  Future? _isWorking;

  SharedPrefsWrapper(this._prefs);

  @override
  Object? get(String key) {
    return _prefs.get(key);
  }

  @override
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  @override
  DateTime? getDateTime(String key) {
    final int? dateInt = _getIntOrNull(key: key);
    if (dateInt == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(dateInt);
  }

  int? _getIntOrNull({required String key}) {
    try {
      final int? intValue = getInt(key);
      return intValue;
    } catch (_) {
      return null;
    }
  }

  @override
  Future setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  @override
  Future setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  @override
  Future setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  @override
  Future setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  @override
  Future setDateTime(String key, DateTime dateTime) {
    final int dateTimeInt = dateTime.millisecondsSinceEpoch;
    return setInt(key, dateTimeInt);
  }

  @override
  Future clearUserData() async {
    if (_isWorking != null) {
      await _isWorking;
      return clearUserData();
    }

    final Completer<void> completer = Completer<void>();
    _isWorking = completer.future;

    _prefs.reload();

    final Map<String, dynamic> valuesToSave = {};
    for (final String key in SharedPrefsKeys.getKeepKeys()) {
      final Object? value = _prefs.get(key);
      valuesToSave[key] = value;
    }
    for (final String key in SharedPrefsKeys.getKeepKeysWithPartialName()) {
      for (final String existingKey in _prefs.getKeys()) {
        if (existingKey.startsWith(key)) {
          final Object? value = _prefs.get(existingKey);
          valuesToSave[existingKey] = value;
          break;
        }
      }
    }

    await _prefs.clear();

    for (final MapEntry<String, dynamic> entry in valuesToSave.entries) {
      switch (entry.value.runtimeType) {
        case const (bool):
          await _prefs.setBool(entry.key, entry.value as bool);

        case const (double):
          await _prefs.setDouble(entry.key, entry.value as double);

        case const (int):
          await _prefs.setInt(entry.key, entry.value as int);

        case const (String):
          await _prefs.setString(entry.key, entry.value as String);

        default:
          break;
      }
    }

    completer.complete();
    _isWorking = null;
  }

  @override
  void reload() {
    _prefs.reload();
  }

  @override
  List<String> getKeys() {
    return _prefs.getKeys().toList();
  }

  @override
  Future remove(String key) {
    return _prefs.remove(key);
  }

  @override
  Future setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }
}
