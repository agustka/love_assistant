import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:la/setup.dart';

class LaEventBusListener<A> extends StatefulWidget {
  final void Function(A message) onMessage;
  final Widget child;

  const LaEventBusListener({super.key, required this.onMessage, required this.child});

  @override
  _LaEventBusListenerState createState() => _LaEventBusListenerState<A>();
}

class _LaEventBusListenerState<B> extends State<LaEventBusListener<B>> {
  late final StreamSubscription<B> _eventSubscription;

  @override
  void initState() {
    super.initState();

    _eventSubscription = getIt<EventBus>().on<B>().listen((B event) {
      widget.onMessage(event);
    });
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
