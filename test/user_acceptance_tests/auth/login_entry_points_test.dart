import "package:flutter_test/flutter_test.dart";
import "package:la/presentation/auth/login_page.dart";
import "package:la/presentation/landing/landing_page.dart";
import "package:la/presentation/wizard/wizard_page.dart";

import "../../_core/test_rig.dart";
import "../../_core/test_setup/driver/app_driver.dart";
import "driver/login_entry_points_driver.dart";

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Login entry points", () {
    testWidgets("Landing login entry point shows the wired page", (WidgetTester tester) async {
      // Given a user is on a screen that offers login as the secondary account action.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openLandingPage();
      appDriver.assertIsOnPage(LandingPage.pageKey);
      driver.assertLandingLoginAffordanceVisible();

      // When they choose to log in.
      await driver.tapLandingLogin();

      // Then the login page shows an email field, password field, and login action.
      appDriver.assertIsOnPage(LoginPage.pageKey);
      driver.assertLoginFormVisible();
    });

    testWidgets("Wizard login entry point shows the wired page", (WidgetTester tester) async {
      // Given a user is on a screen that offers login as the secondary account action.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openWizardPage();
      appDriver.assertIsOnPage(WizardPage.pageKey);
      driver.assertWizardLoginAffordanceVisible();

      // When they choose to log in.
      await driver.tapWizardLogin();

      // Then the login page shows an email field, password field, and login action.
      appDriver.assertIsOnPage(LoginPage.pageKey);
      driver.assertLoginFormVisible();
    });
  });
}
