import "package:flutter_test/flutter_test.dart";

import "../../_core/test_rig.dart";
import "driver/login_entry_points_driver.dart";

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Login entry points", () {
    testWidgets("First wizard page shows secondary login affordance", (WidgetTester tester) async {
      // Given the user opens the first wizard page.
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);

      // When the first wizard page is displayed.
      await driver.openWizardPage();

      // Then a secondary login affordance is visible without competing with the primary wizard action.
      driver.assertOnWizardPage();
      driver.assertWizardPrimaryActionVisible();
      driver.assertWizardLoginAffordanceVisible();
    });

    testWidgets("First wizard page login action opens login page", (WidgetTester tester) async {
      // Given the user is on the first wizard page.
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openWizardPage();

      // When the user taps the "Log in" action.
      await driver.tapWizardLogin();

      // Then the user is taken to the login page.
      driver.assertOnLoginPage();
      driver.assertLoginUnderConstructionVisible();
    });

    testWidgets("Post-wizard account page shows secondary login affordance", (WidgetTester tester) async {
      // Given the user completes the wizard and reaches the account option page.
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);

      // When the account option page is displayed.
      await driver.openLandingPage();

      // Then a secondary login affordance is visible while sign-up remains the most prominent action.
      driver.assertOnLandingPage();
      driver.assertLandingPrimaryActionVisible();
      driver.assertLandingLoginAffordanceVisible();
    });

    testWidgets("Post-wizard account page login action opens login page", (WidgetTester tester) async {
      // Given the user is on the account option page after the wizard.
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openLandingPage();

      // When the user taps the "Log in" action.
      await driver.tapLandingLogin();

      // Then the user is taken to the login page.
      driver.assertOnLoginPage();
      driver.assertLoginUnderConstructionVisible();
    });

    testWidgets("Wizard login page shows under-construction state", (WidgetTester tester) async {
      // Given the user navigates to the login page.
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openWizardPage();

      // When the login page opens.
      await driver.tapWizardLogin();

      // Then an under-construction state is visible with a way to go back.
      driver.assertOnLoginPage();
      driver.assertLoginUnderConstructionVisible();
      driver.assertBackButtonVisible();
    });

    testWidgets("Back from wizard login returns to wizard origin", (WidgetTester tester) async {
      // Given the user is on the under-construction login page.
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openWizardPage();
      await driver.tapWizardLogin();
      driver.assertOnLoginPage();

      // When the user goes back.
      await driver.tapBack();

      // Then they return to the page they came from.
      driver.assertOnWizardPage();
    });

    testWidgets("Back from account login returns to account origin", (WidgetTester tester) async {
      // Given the user is on the under-construction login page from the account option page.
      final LoginEntryPointsDriver driver = LoginEntryPointsDriver(tester: tester);
      await driver.openLandingPage();
      await driver.tapLandingLogin();
      driver.assertOnLoginPage();

      // When the user goes back.
      await driver.tapBack();

      // Then they return to the page they came from.
      driver.assertOnLandingPage();
    });
  });
}
