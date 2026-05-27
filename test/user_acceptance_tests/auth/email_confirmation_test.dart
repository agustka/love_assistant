import "package:flutter_test/flutter_test.dart";

import "../../_core/test_setup/app_driver.dart";
import "../../_core/test_setup/builders/auth_builder.dart";
import "driver/email_confirmation_driver.dart";
import "driver/sign_up_driver.dart";

void main() {
  late AuthBuilder authBuilder;
  late AppDriver appDriver;
  late SignUpDriver signUpDriver;
  late EmailConfirmationDriver driver;

  tearDown(() async {
    authBuilder.tearDown();
  });

  group("Email-confirmation screen", () {
    setUp(() {
      authBuilder = AuthBuilder();
    });

    testWidgets("Confirmed email — session established and main screen shown", (WidgetTester tester) async {
      // Given
      authBuilder.confirmationSucceeds = true;
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.tapConfirmed();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Confirmation not yet completed — pending message shown, user stays on screen", (WidgetTester tester) async {
      // Given
      authBuilder.confirmationSucceeds = false;
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.tapConfirmed();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Re-check fails with network error — distinct error shown, not pending message", (WidgetTester tester) async {
      // Given
      authBuilder.confirmationThrowsNetworkError = true;
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.tapConfirmed();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Re-check fails unexpectedly — generic error shown, not pending message", (WidgetTester tester) async {
      // Given
      authBuilder.confirmationThrowsUnexpectedError = true;
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.tapConfirmed();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Resend succeeds — confirmation sent, resend disabled for cooldown", (WidgetTester tester) async {
      // Given
      authBuilder.resendSucceeds = true;
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.tapResend();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Resend fails or rate-limited — failure message shown, stays on screen", (WidgetTester tester) async {
      // Given
      authBuilder.resendThrows = true;
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.tapResend();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Auto-detect confirmation — signed-in event routes to main automatically", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.simulateSignedInAuthEvent();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Back navigation — returns to sign-up screen", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await appDriver.pop();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });

    testWidgets("Re-check in flight — confirm button shows loading, duplicates prevented", (WidgetTester tester) async {
      // Given
      appDriver = AppDriver(tester: tester);
      signUpDriver = SignUpDriver(tester: tester, builders: authBuilder);
      driver = EmailConfirmationDriver(tester: tester, builders: authBuilder);
      await signUpDriver.openPage();

      // When
      await driver.tapConfirmed();

      // Then
      markTestSkipped("scaffold — implement after layers complete");
    });
  });
}
