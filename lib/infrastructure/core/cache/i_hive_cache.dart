import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:la/infrastructure/core/auth/session/i_purgeable_service.dart';

abstract class IHiveCache implements IPurgeableService {
  Future put({required String boxName, required String key, required String data, required DateTime expires});

  Future<CacheResponse> get({required String boxName, required String key});

  Future delete({required String boxName, String? key});

  Future initialize();
}

@immutable
class CacheResponse {
  final String data;
  final bool hasCache;
  final bool stale;
  final DateTime? expires;
  final DateTime? timeStamp;

  const CacheResponse({
    required this.data,
    required this.hasCache,
    required this.stale,
    required this.expires,
    required this.timeStamp,
  });

  factory CacheResponse.noCache() {
    return const CacheResponse(data: "", hasCache: false, stale: false, expires: null, timeStamp: null);
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
class CacheDataWithTimeStamp extends HiveObject {
  @HiveField(0)
  final int expiresTimeStamp;
  @HiveField(1)
  final String data;
  @HiveField(2)
  final int dataTimeStamp;

  CacheDataWithTimeStamp({
    required this.expiresTimeStamp,
    required this.data,
    required this.dataTimeStamp,
  });
}

class CacheDataWithTimeStampAdapter extends TypeAdapter<CacheDataWithTimeStamp> {
  @override
  int get typeId => 1;

  @override
  CacheDataWithTimeStamp read(BinaryReader reader) {
    final int expiresTimeStamp = reader.readInt();
    final String data = reader.readString();
    final int dataTimeStamp = reader.readInt();
    return CacheDataWithTimeStamp(expiresTimeStamp: expiresTimeStamp, data: data, dataTimeStamp: dataTimeStamp);
  }

  @override
  void write(BinaryWriter writer, CacheDataWithTimeStamp obj) {
    writer.writeInt(obj.expiresTimeStamp);
    writer.writeString(obj.data);
    writer.writeInt(obj.dataTimeStamp);
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
