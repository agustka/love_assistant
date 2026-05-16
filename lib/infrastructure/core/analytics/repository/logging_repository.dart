import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:la/domain/core/analytics/base/event.dart';
import 'package:la/infrastructure/core/analytics/repository/i_logging_repository.dart';

@LazySingleton(as: ILoggingRepository)
class LoggingRepository implements ILoggingRepository {
  LoggingRepository(

      );

  @override
  void initialize() {
    // TODO
  }

  @override
  Future<void> logEvent(Event event) async {
    // TODO start logging events
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
  }
}
