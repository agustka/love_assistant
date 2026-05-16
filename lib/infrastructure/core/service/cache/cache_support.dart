import 'dart:convert';

import 'package:la/domain/core/entities/cache_wrapper.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';
import 'package:la/infrastructure/core/cache/i_hive_cache.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';
import 'package:la/setup.dart';

mixin class CacheSupport {
  void addCache({required String box, required String key, required dynamic data, required Duration timeToLive}) {
    addCacheAsync(box: box, key: key, data: data, timeToLive: timeToLive);
  }

  Future addCacheAsync({
    required String box,
    required String key,
    required dynamic data,
    required Duration timeToLive,
  }) async {
    final DateTime expires = DateTime.now().add(timeToLive);
    final IHiveCache hiveBox = getIt<IHiveCache>();
    await hiveBox.put(boxName: box, key: key, expires: expires, data: json.encode(data));
  }

  Future<Payload<T>> getCached<T>({
    required String box,
    required String key,
    required Map<dynamic, Function> conversions,
  }) {
    return _getCached<T, T>(box: box, key: key, conversions: conversions);
  }

  Future<CacheWrapper<T>> getCachedV2<T>({
    required String box,
    required String key,
    required Map<dynamic, Function> conversions,
  }) {
    return _getCachedV2<T, T>(box: box, key: key, conversions: conversions);
  }

  Future<Payload<List<T>>> getCachedList<T>({
    required String box,
    required String key,
    required Map<dynamic, Function> conversions,
  }) {
    return _getCached<List<T>, T>(box: box, key: key, conversions: conversions);
  }

  Future<Payload<ResultType>> _getCached<ResultType, InnerType>({
    required String box,
    required String key,
    required Map<dynamic, Function> conversions,
  }) async {
    try {
      final CacheResponse cache = await getIt<IHiveCache>().get(boxName: box, key: key);
      if (cache.hasCache) {
        final ResultType? element = _convert<ResultType, InnerType>(cache.data, conversions);
        if (element == null) {
          return Payload.failure(Failure("$key not found in cache"));
        }
        return Payload.successWithTimeToLive(
          payload: element,
          timeToLive: cache.expires?.difference(DateTime.now()) ?? Payload.defaultTimeToLive,
          cached: true,
          stale: cache.stale,
        );
      }
      return Payload.failure(Failure("$key not found in cache"));
    } catch (ex) {
      err(ex, location: "CacheSupport._getCached");
      return Payload.failure(Failure(ex.toString(), reference: ex));
    }
  }

  Future<CacheWrapper<ResultType>> _getCachedV2<ResultType, InnerType>({
    required String box,
    required String key,
    required Map<dynamic, Function> conversions,
  }) async {
    final CacheResponse cache = await getIt<IHiveCache>().get(boxName: box, key: key);
    if (cache.hasCache) {
      final ResultType? element = _convert<ResultType, InnerType>(cache.data, conversions);
      if (element == null) {
        return CacheWrapper.noCache();
      }
      return CacheWrapper.cache(
        element,
        stale: cache.expires?.isBefore(DateTime.now()) ?? false,
        timeStamp: cache.timeStamp ?? DateTime.now(),
      );
    }
    return CacheWrapper.noCache();
  }

  ResultType? _convert<ResultType, InnerType>(String data, Map<dynamic, Function> conversions) {
    final Function? conversion = conversions[InnerType];
    if (conversion == null) {
      err(
        "Hive cache: Unable to find a conversion method for type $ResultType",
        location: "1)CacheSupport._convert",
      );
      return null;
    }

    try {
      final dynamic result = json.decode(data);
      if (result is List) {
        return result
            .map(
              (dynamic item) => conversions[InnerType]?.call(item) as InnerType,
        )
            .toList()
        as ResultType;
      }
      return conversions[ResultType]?.call(result) as ResultType;
    } catch (ex) {
      err(
        "Hive cache: Error converting cached data $ResultType. Cached data: $data",
        location: "2)CacheSupport._convert",
      );
      return null;
    }
  }

  Future<void> deleteEntry({required String box, String? key}) {
    return getIt<IHiveCache>().delete(boxName: box, key: key);
  }
}
