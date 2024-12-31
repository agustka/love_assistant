import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:la/setup.dart';

enum PollResult {
  keepPolling,
  stop,
}

abstract interface class IPollAndDebounce {
  void delayCall({required Duration delay, required VoidCallback action});

  Future delay(Duration duration);

  void cancel();

  Future<void> poll({
    required Duration maxDuration,
    Duration baseInterval = const Duration(milliseconds: 500),
    bool shouldIncreaseInterval = true,
    Duration maxInterval = const Duration(milliseconds: 5000),
    required Future<PollResult> Function() action,
  });
}

class Time {
  static Future delayed(Duration duration, [FutureOr Function()? computation]) async {
    await getIt<IPollAndDebounce>().delay(duration);
    computation?.call();
  }
}
