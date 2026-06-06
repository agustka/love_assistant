import "package:flutter_test/flutter_test.dart";
import "package:la/presentation/auth/login_page.dart";
import "package:la/presentation/auth/sign_up_page.dart";
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
      driver.assertLanguageSelectorVisible();
      driver.assertLandingLoginAffordanceVisible();

      // When they choose to log in.
      await driver.tapLandingLogin();

      // Then the login page shows an email field, password field, and login action.
      appDriver.assertIsOnPage(LoginPage.pageKey);
      driver.assertLanguageSelectorVisible();
      driver.assertLoginFormVisible();
    });

    testWidgets("Sign-up page shows the language selector", (WidgetTester tester) async {
      // Given a user is on the sign-up page.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openSignUpPage();

      // Then they can change language before creating an account.
      appDriver.assertIsOnPage(SignUpPage.pageKey);
      driver.assertLanguageSelectorVisible();
      await driver.tapLanguageSelector();
      driver.assertLanguageOptionsVisible();
    });

    testWidgets("Login page shows the language selector", (WidgetTester tester) async {
      // Given a user is on the login page.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openLoginPage();

      // Then they can change language before signing in.
      appDriver.assertIsOnPage(LoginPage.pageKey);
      driver.assertLanguageSelectorVisible();
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
