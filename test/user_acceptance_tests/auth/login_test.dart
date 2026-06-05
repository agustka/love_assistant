import 'package:flutter_test/flutter_test.dart';

import '../../_core/test_rig.dart';
import '../../_core/test_setup/builders/auth/auth_login_builder.dart';
import 'driver/login_driver.dart';
import 'driver/reset_password_driver.dart';

const String _validEmail = "valid@example.com";
const String _validPassword = "password123";

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Login screen", () {
    testWidgets("Correct credentials land on the main page with the auth stack cleared", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page with a confirmed account
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();
      driver.assertOnLoginPage();

      // When I enter correct email and password and tap the login button
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then I am taken to the main page and the auth stack is cleared (back navigation is gone)
      driver.assertOnMainPage();
    });

    testWidgets("Wrong credentials show a combined form-level error", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().wrongCredentials()]);
      await driver.openPage();

      // When I submit an email and password that do not match any confirmed account
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then I stay on the login page and a single combined form-level error is shown
      driver.assertOnLoginPage();
      driver.assertFormErrorVisible();
    });

    testWidgets("Unconfirmed-email login routes to the email-confirmation page", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I created an account but never confirmed my email
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().unconfirmedEmail()]);
      await driver.openPage();

      // When I submit my correct email and password on the login page
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then I am routed to the existing email-confirmation page (carrying my credentials)
      driver.assertOnConfirmationPage();
    });

    testWidgets("Empty or malformed email shows an inline email validation error, no network call", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();

      // When I submit with an empty email and a password
      await driver.enterEmail("");
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then the email field shows a validation error and I remain on the login page with no network call
      driver.assertEmailErrorVisible();
      driver.assertOnLoginPage();
    });

    testWidgets("Malformed email shows an inline email validation error", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();

      // When I submit with a malformed email
      await driver.enterEmail("not-an-email");
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then the email field shows a validation error and I remain on the login page
      driver.assertEmailErrorVisible();
      driver.assertOnLoginPage();
    });

    testWidgets("Empty password shows an inline password validation error, no network call", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();

      // When I submit with a valid email and an empty password
      await driver.enterEmail(_validEmail);
      await driver.enterPassword("");
      await driver.tapLogin();

      // Then the password field shows a validation error and I remain on the login page with no network call
      driver.assertPasswordErrorVisible();
      driver.assertOnLoginPage();
    });

    testWidgets("Network failure shows a connection form-level error", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page and the server is unreachable
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().networkError()]);
      await driver.openPage();

      // When I submit valid credentials
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then a form-level connection error message is shown and I stay on the login page
      driver.assertFormErrorVisible();
      driver.assertOnLoginPage();
    });

    testWidgets("Rate-limited login shows a try-again form-level error", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I have submitted login too many times in a short window
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().rateLimited()]);
      await driver.openPage();

      // When Supabase rate-limits the request
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then a form-level rate-limit message is shown and I stay on the login page
      driver.assertFormErrorVisible();
      driver.assertOnLoginPage();
    });

    testWidgets("Unexpected login failure shows a generic form-level error", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page and login fails for an unhandled reason
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().wrongCredentials()]);
      await driver.openPage();

      // When I submit valid credentials and an unexpected error occurs
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);
      await driver.tapLogin();

      // Then a generic form-level error message is shown and I remain on the login page
      driver.assertFormErrorVisible();
      driver.assertOnLoginPage();
    });

    testWidgets("Tapping Forgot password? navigates to the reset-password page", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the login page
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();

      // When I tap "Forgot password?"
      await driver.tapForgotPassword();

      // Then the reset-password page opens with a single email field and a send-reset-link action
      driver.assertOnResetPasswordPage();
    });
  });

  group("Reset-password screen", () {
    Future<ResetPasswordDriver> openResetPassword(WidgetTester tester, AuthLoginBuilder builder) async {
      final LoginDriver login = LoginDriver(tester: tester, builders: [builder]);
      await login.openPage();
      await login.tapForgotPassword();
      return ResetPasswordDriver(tester: tester);
    }

    testWidgets("Valid email shows the send-link confirmation message", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the reset-password page
      final ResetPasswordDriver driver = await openResetPassword(tester, AuthLoginBuilder());

      // When I enter an email and tap "Send reset link"
      await driver.enterEmail(_validEmail);
      await driver.tapSendResetLink();

      // Then a confirmation message is shown (same message regardless of whether the email is registered)
      driver.assertConfirmationMessageVisible();
    });

    testWidgets("Empty email shows an inline email validation error and makes no request", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the reset-password page
      final ResetPasswordDriver driver = await openResetPassword(tester, AuthLoginBuilder());

      // When I tap "Send reset link" without entering an email
      await driver.enterEmail("");
      await driver.tapSendResetLink();

      // Then the email field shows a validation error and no network call is made
      driver.assertEmailErrorVisible();
      driver.assertOnResetPasswordPage();
    });

    testWidgets("Malformed email shows an inline email validation error and makes no request", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the reset-password page
      final ResetPasswordDriver driver = await openResetPassword(tester, AuthLoginBuilder());

      // When I submit with a malformed email
      await driver.enterEmail("not-an-email");
      await driver.tapSendResetLink();

      // Then the email field shows a validation error and no network call is made
      driver.assertEmailErrorVisible();
      driver.assertOnResetPasswordPage();
    });

    testWidgets("Network failure during reset shows a connection form-level error", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the reset-password page and the server is unreachable
      final ResetPasswordDriver driver = await openResetPassword(tester, AuthLoginBuilder().passwordResetNetworkError());

      // When I submit a valid email
      await driver.enterEmail(_validEmail);
      await driver.tapSendResetLink();

      // Then a form-level connection error message is shown and I remain on the reset-password page
      driver.assertFormErrorVisible();
      driver.assertOnResetPasswordPage();
    });

    testWidgets("Rate-limited reset shows a try-again form-level error", (WidgetTester tester) async {
      markTestSkipped("scaffold — implement after layers complete");

      // Given I am on the reset-password page and the request is rate-limited
      final ResetPasswordDriver driver = await openResetPassword(tester, AuthLoginBuilder().passwordResetRateLimited());

      // When the reset request is submitted and rate-limited
      await driver.enterEmail(_validEmail);
      await driver.tapSendResetLink();

      // Then a form-level rate-limit message is shown and I remain on the reset-password page
      driver.assertFormErrorVisible();
      driver.assertOnResetPasswordPage();
    });
  });
}
