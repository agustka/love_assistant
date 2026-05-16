import 'package:la/domain/core/analytics/base/event.dart';
import 'package:la/infrastructure/core/analytics/repository/i_logging_repository.dart';
import 'package:la/setup.dart';

mixin AnalyticsHelper {
  void log(Event event) {
    getIt<ILoggingRepository>().logEvent(event);
  }
}
