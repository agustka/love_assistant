import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../_core/test_rig.dart';
import 'driver/sign_up_golden_driver.dart';

const Size _narrowPhone = Size(320, 844);

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Sign-up page", () {
    testGoldens("Light mode", (WidgetTester tester) async {
      final SignUpGoldenDriver driver = SignUpGoldenDriver(tester: tester, goldenTest: true, size: _narrowPhone);
      await driver.openPage();

      await screenMatchesGolden(tester, "sign_up_page_light");
    });

    testGoldens("Dark mode", (WidgetTester tester) async {
      final SignUpGoldenDriver driver = SignUpGoldenDriver(
        tester: tester,
        goldenTest: true,
        brightness: Brightness.dark,
        size: _narrowPhone,
      );
      await driver.openPage();

      await screenMatchesGolden(tester, "sign_up_page_dark");
    });

    testGoldens("Accessibility mode", (WidgetTester tester) async {
      final SignUpGoldenDriver driver = SignUpGoldenDriver(
        tester: tester,
        goldenTest: true,
        accessibilityMode: true,
        size: _narrowPhone,
      );
      await driver.openPage();

      await screenMatchesGolden(tester, "sign_up_page_accessibility");
    });
  });
}
