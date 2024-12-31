import 'dart:async';
import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:la/domain/core/extensions/common_extensions.dart';
import 'package:la/infrastructure/core/time/i_poll_and_debounce.dart';

@Injectable(as: IPollAndDebounce)
class PollAndDebounce implements IPollAndDebounce {
  Timer? _timer;
  bool _stop = false;
  Completer<void>? _completer;

  @override
  void delayCall({required Duration delay, required VoidCallback action}) {
    cancel();
    _timer = Timer(delay, () {
      _timer = null;
      action();
    });
  }

  @override
  void cancel() {
    if (!(_completer?.isCompleted ?? false)) {
      _completer?.complete();
    }
    _timer?.cancel();
    _timer = null;
    _completer = null;
    _stop = true;
  }

  @override
  Future delay(Duration duration) {
    return Future.delayed(duration);
  }

  @override
  Future<void> poll({
    required Duration maxDuration,
    Duration baseInterval = const Duration(milliseconds: 500),
    bool shouldIncreaseInterval = true,
    Duration maxInterval = const Duration(milliseconds: 5000),
    required Future<PollResult> Function() action,
  }) {
    _stop = false;
    _completer = Completer<void>();
    _doPoll(
      maxDuration: maxDuration,
      baseInterval: baseInterval,
      shouldIncreaseInterval: shouldIncreaseInterval,
      maxInterval: maxInterval,
      action: action,
    );

    return _completer?.future ?? Future.delayed(Duration.zero);
  }

  Future<void> _doPoll({
    required Duration maxDuration,
    Duration baseInterval = const Duration(milliseconds: 500),
    bool shouldIncreaseInterval = true,
    Duration maxInterval = const Duration(milliseconds: 5000),
    required Future<PollResult> Function() action,
  }) async {
    try {
      int elapsedTime = 0;
      double intervalMultiplier = 1.0;
      int interval = baseInterval.inMilliseconds;

      while (elapsedTime < maxDuration.inMilliseconds) {
        if (_stop) {
          _stop = false;
          break;
        }

        if (await action() == PollResult.stop) {
          break;
        }

        await delay(interval.milliseconds);
        elapsedTime += interval;

        if (shouldIncreaseInterval) {
          intervalMultiplier = (elapsedTime / maxDuration.inMilliseconds) + 1;
          interval = (interval * intervalMultiplier).toInt().clamp(
            baseInterval.inMilliseconds,
            maxInterval.inMilliseconds,
          );
        }
      }

      _completer?.complete();
    } finally {
      if (!(_completer?.isCompleted ?? false)) {
        _completer?.complete();
      }
      _completer = null;
    }
  }
}
