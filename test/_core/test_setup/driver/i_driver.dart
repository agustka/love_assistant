import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_rig.dart';
import '../builders/base_builder.dart';

/// Base class for all feature drivers.
///
/// Holds the [tester] and the launch configuration, and exposes
/// [launchApplication] to boot the offline app with a given page as its home.
/// Feature drivers expose `find.byKey()` finders, `assertXxx()`, and `tapXxx()`
/// helpers so test files read as plain English.
class BaseDriver {
  final WidgetTester tester;
  final List<BaseBuilder> builders;
  final Brightness brightness;
  final bool accessibilityMode;
  final bool goldenTest;
  final Size size;

  const BaseDriver({
    required this.tester,
    this.builders = const [],
    this.brightness = Brightness.light,
    this.accessibilityMode = false,
    this.goldenTest = false,
    this.size = const Size(390, 844),
  });

  Future<void> launchApplication({required Widget home}) async {
    await launchApp(
      tester,
      home: home,
      builders: builders,
      brightness: brightness,
      accessibilityMode: accessibilityMode,
      size: size,
    );
  }
}
