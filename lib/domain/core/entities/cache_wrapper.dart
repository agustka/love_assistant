import 'package:equatable/equatable.dart';

class CacheWrapper<V> extends Equatable {
  final V? data;
  final bool stale;
  final DateTime timeStamp;

  const CacheWrapper._(
      this.data, {
        required this.stale,
        required this.timeStamp,
      });

  factory CacheWrapper.noCache() {
    return CacheWrapper._(
      null,
      stale: false,
      timeStamp:  DateTime.now(),
    );
  }

  factory CacheWrapper.cache(V payload, {required DateTime timeStamp, required bool stale}) {
    return CacheWrapper._(
      payload,
      stale: stale,
      timeStamp: timeStamp,
    );
  }

  CacheWrapper<T> transform<T>(T Function(V value) cached) {
    if (data != null) {
      final T t = cached(data as V);
      return CacheWrapper._(t, stale: stale, timeStamp: timeStamp);
    }
    return CacheWrapper._(null, stale: stale, timeStamp: timeStamp);
  }

  Future<CacheWrapper<T>> transformAsync<T>(Future<T> Function(V value) cached) async {
    if (data != null) {
      final T t = await cached(data as V);
      return CacheWrapper._(t, stale: stale, timeStamp: timeStamp);
    }
    return CacheWrapper._(null, stale: stale, timeStamp: timeStamp);
  }

  @override
  String toString() {
    if (data == null) {
      return "No cache";
    }
    return "Cache (stale: $stale) from $timeStamp: $data";
  }

  @override
  List<Object?> get props => [
    data,
    stale,
    timeStamp,
  ];
}
