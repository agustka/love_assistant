import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class IHiveCache {
  Future put({required String boxName, required String key, required String data, required DateTime expires});

  Future<CacheResponse> get({required String boxName, required String key});

  Future delete({required String boxName, String? key});

  Future purge();

  Future initialize();
}

@immutable
class CacheResponse {
  final String data;
  final bool hasCache;
  final bool stale;
  final DateTime? expires;

  const CacheResponse({
    required this.data,
    required this.hasCache,
    required this.stale,
    required this.expires,
  });

  factory CacheResponse.noCache() {
    return const CacheResponse(data: "", hasCache: false, stale: false, expires: null);
  }

  @override
  String toString() {
    if (!hasCache) {
      return "No cache";
    }
    if (stale) {
      return "Stale ($expires): $data";
    }
    return "Active cache ($expires): $data";
  }
}

@HiveType(typeId: 1)
class CacheData extends HiveObject {
  @HiveField(0)
  final int expiresTimeStamp;
  @HiveField(1)
  final String data;

  CacheData({required this.expiresTimeStamp, required this.data});
}

class CacheDataAdapter extends TypeAdapter<CacheData> {
  @override
  int get typeId => 1;

  @override
  CacheData read(BinaryReader reader) {
    final int expiresTimeStamp = reader.readInt();
    final String data = reader.readString();
    return CacheData(expiresTimeStamp: expiresTimeStamp, data: data);
  }

  @override
  void write(BinaryWriter writer, CacheData obj) {
    writer.writeInt(obj.expiresTimeStamp);
    writer.writeString(obj.data);
  }
}
