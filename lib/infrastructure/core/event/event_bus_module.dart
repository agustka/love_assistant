import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';

@module
abstract class EventBusModule {
  @singleton
  EventBus get eventBus {
    return EventBus();
  }
}
