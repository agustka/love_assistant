import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../_core/test_rig.dart';
import 'driver/login_golden_driver.dart';

const Size _narrowPhone = Size(320, 844);

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Login page", () {
    testGoldens("Light mode", (WidgetTester tester) async {
      final LoginGoldenDriver driver = LoginGoldenDriver(tester: tester, goldenTest: true, size: _narrowPhone);
      await driver.openPage();

      await screenMatchesGolden(tester, "login_page_light");
    });

    testGoldens("Dark mode", (WidgetTester tester) async {
      final LoginGoldenDriver driver = LoginGoldenDriver(
        tester: tester,
        goldenTest: true,
        brightness: Brightness.dark,
        size: _narrowPhone,
      );
      await driver.openPage();

      await screenMatchesGolden(tester, "login_page_dark");
    });

    testGoldens("Accessibility mode", (WidgetTester tester) async {
      final LoginGoldenDriver driver = LoginGoldenDriver(
        tester: tester,
        goldenTest: true,
        accessibilityMode: true,
        size: _narrowPhone,
      );
      await driver.openPage();

      await screenMatchesGolden(tester, "login_page_accessibility");
    });
  });
}
