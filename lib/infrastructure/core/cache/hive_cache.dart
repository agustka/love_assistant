import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:la/infrastructure/core/cache/i_hive_cache.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: IHiveCache)
class HiveCache implements IHiveCache {
  static const String _hiveSubFolder = "jycu23t";

  const HiveCache();

  @override
  Future put({
    required String boxName,
    required String key,
    required String data,
    required DateTime expires,
  }) async {
    try {
      final Box<CacheData> box = await Hive.openBox<CacheData>(boxName, encryptionCipher: _getHiveKey(boxName));
      box.put(key, CacheData(data: data, expiresTimeStamp: expires.millisecondsSinceEpoch));
    } catch (ex) {
      err(ex, location: "HiveCache.put");
    }
  }

  @override
  Future<CacheResponse> get({required String boxName, required String key}) async {
    try {
      final Box<CacheData> box = await Hive.openBox<CacheData>(boxName, encryptionCipher: _getHiveKey(boxName));
      final CacheData? data = box.get(key);
      if (data == null) {
        return CacheResponse.noCache();
      }
      final bool stale = data.expiresTimeStamp < DateTime.now().millisecondsSinceEpoch;
      return CacheResponse(
        data: data.data,
        stale: stale,
        hasCache: true,
        expires: DateTime.fromMillisecondsSinceEpoch(data.expiresTimeStamp),
      );
    } catch (ex) {
      err(ex, location: "HiveCache.get");
      return CacheResponse.noCache();
    }
  }

  @override
  Future delete({required String boxName, String? key}) async {
    try {
      if (key == null) {
        return Hive.deleteBoxFromDisk(boxName);
      }
      final Box<CacheData> box = await Hive.openBox<CacheData>(boxName, encryptionCipher: _getHiveKey(boxName));
      return box.delete(key);
    } catch (ex) {
      err(ex, location: "HiveCache.delete");
    }
  }

  @override
  Future purge() async {
    try {
      await Hive.close();
      final Directory directory = await _getHiveDir();
      if (directory.existsSync()) {
        await directory.delete(recursive: true);
      }
    } catch (e, stackTrace) {
      err(e, trace: stackTrace, location: "HiveCache.put");
    } finally {
      final Directory dir = await _getHiveDir();
      Hive.init(dir.path);
    }
  }

  @override
  Future initialize() async {
    final Directory dir = await _getHiveDir();
    Hive.init(dir.path);
    Hive.registerAdapter<CacheData>(CacheDataAdapter());
  }

  Future<Directory> _getHiveDir() async {
    final Directory appDir = await getApplicationSupportDirectory();
    final Directory hiveDbDir = Directory("${appDir.path}/$_hiveSubFolder");
    return hiveDbDir;
  }

  HiveAesCipher _getHiveKey(String boxName) {
    List<int> key = utf8.encode(boxName.hashCode.toString()).toList();
    if (key.length > 32) {
      key = key.sublist(0, 32);
    }
    if (key.length < 32) {
      final int add = 32 - key.length;
      for (int i = 0; i < add; i++) {
        key.add(0);
      }
    }
    return HiveAesCipher(key);
  }
}
