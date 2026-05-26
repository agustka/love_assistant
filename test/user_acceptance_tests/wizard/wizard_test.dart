import 'package:flutter_test/flutter_test.dart';

import '../../_core/test_rig.dart';
import '../../_core/test_setup/builders/wizard/partner_profile_builder.dart';
import 'driver/wizard_driver.dart';

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Initial wizard", () {
    testWidgets("Wizard opens on the greetings step", (WidgetTester tester) async {
      // Given a first-time user with no saved partner profile
      final WizardDriver driver = WizardDriver(
        tester: tester,
        builders: [PartnerProfileBuilder()],
      );

      // When the wizard opens
      await driver.openPage();

      // Then the greetings step is shown first
      driver.assertOnGreetingsStep();
    });

    testWidgets("Continuing from greetings advances to the partner basics step", (WidgetTester tester) async {
      // Given a first-time user on the greetings step
      final WizardDriver driver = WizardDriver(
        tester: tester,
        builders: [PartnerProfileBuilder()],
      );
      await driver.openPage();

      // When they continue past the greeting
      await driver.tapNext();

      // Then the partner basics step is shown
      driver.assertOnBasicInfoStep();
    });
  });
}
