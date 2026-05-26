import 'package:flutter/cupertino.dart';

abstract class TestSetupConstructor {
  const TestSetupConstructor();

  @mustCallSuper
  Future<void> setup();

  @mustCallSuper
  Future<void> tearDown() async {}
}
