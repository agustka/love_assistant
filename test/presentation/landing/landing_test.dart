import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../_core/test_rig.dart';
import 'driver/landing_driver.dart';

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Landing page", () {
    testGoldens("Light mode", (WidgetTester tester) async {
      final LandingDriver driver = LandingDriver(tester: tester, goldenTest: true);
      await driver.openPage();

      await screenMatchesGolden(tester, "landing_page_light");
    });

    testGoldens("Dark mode", (WidgetTester tester) async {
      final LandingDriver driver = LandingDriver(tester: tester, goldenTest: true, brightness: Brightness.dark);
      await driver.openPage();

      await screenMatchesGolden(tester, "landing_page_dark");
    });

    testGoldens("Accessibility mode", (WidgetTester tester) async {
      final LandingDriver driver = LandingDriver(
        tester: tester,
        goldenTest: true,
        accessibilityMode: true,
      );
      await driver.openPage();

      await screenMatchesGolden(tester, "landing_page_accessibility");
    });
  });
}
