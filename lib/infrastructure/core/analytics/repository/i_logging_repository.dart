import 'package:la/domain/core/analytics/base/event.dart';

abstract class ILoggingRepository {
  void initialize();

  Future<void> dispose();

  Future<void> logEvent(Event event);
}
