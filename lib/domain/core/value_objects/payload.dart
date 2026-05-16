import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';

class Payload<V> extends ValueObject<V> {
  static const Duration defaultTimeToLive = Duration(minutes: 30);

  final Duration timeToLive;
  final bool cached;
  final bool stale;

  bool get failed => failure != null;
  bool get succeeded => failure == null;

  const Payload._(
      V? result,
      this.timeToLive,
      Failure? failure, {
        this.cached = false,
        this.stale = false,
      }) : super(result, failure);

  factory Payload.successWithTimeToLive({
    required V payload,
    required Duration timeToLive,
    bool cached = false,
    bool stale = false,
  }) {
    return Payload._(
      payload,
      timeToLive,
      null,
      cached: cached,
      stale: stale,
    );
  }

  factory Payload.success(V payload, {bool cached = false, bool stale = false}) {
    return Payload._(
      payload,
      defaultTimeToLive,
      null,
      cached: cached,
      stale: stale,
    );
  }

  factory Payload.failure(Failure failure) {
    return Payload._(null, Duration.zero, failure);
  }
}
