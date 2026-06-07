import "package:flutter_test/flutter_test.dart";
import "package:la/presentation/auth/email_confirmation_page.dart";
import "package:la/presentation/auth/login_page.dart";
import "package:la/presentation/main/main_page.dart";

import "../../_core/test_rig.dart";
import "../../_core/test_setup/builders/auth/auth_login_builder.dart";
import "../../_core/test_setup/driver/app_driver.dart";
import "driver/login_driver.dart";

const String _validEmail = "valid@example.com";
const String _validPassword = "password123";

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Login", () {
    testWidgets("Confirmed user lands on home", (WidgetTester tester) async {
      // Given a returning user is on the login page with valid credentials for a confirmed account.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When they submit the login form.
      await driver.tapLogin();

      // Then they land on the home screen and auth screens are removed from the navigation stack.
      appDriver.assertIsOnPage(MainPage.pageKey);
      driver.assertSignInRequestSent();
      await appDriver.popRoute();
      appDriver.assertIsOnPage(MainPage.pageKey);
      appDriver.assertPageDoesNotExist(LoginPage.pageKey);
      appDriver.assertPageDoesNotExist(EmailConfirmationPage.pageKey);
    });

    testWidgets("Invalid email shows inline validation", (WidgetTester tester) async {
      // Given a returning user is on the login page.
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();
      await driver.enterEmail("not-an-email");
      await driver.enterPassword(_validPassword);

      // When they submit an invalid email address.
      await driver.tapLogin();

      // Then the page shows an inline email validation error and no login request is sent.
      driver.assertEmailErrorVisible();
      driver.assertNoSignInRequestSent();
    });

    testWidgets("Missing password shows inline validation", (WidgetTester tester) async {
      // Given a returning user is on the login page.
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);

      // When they submit without entering a password.
      await driver.tapLogin();

      // Then the page shows an inline password validation error and no login request is sent.
      driver.assertPasswordErrorVisible();
      driver.assertNoSignInRequestSent();
    });

    testWidgets("Wrong credentials stay on login with clear error", (WidgetTester tester) async {
      // Given a returning user is on the login page with credentials that do not match an account.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().wrongCredentials()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When they submit the login form.
      await driver.tapLogin();

      // Then the page stays on login and shows a clear email-or-password error.
      appDriver.assertIsOnPage(LoginPage.pageKey);
      driver.assertFormErrorVisible();
    });

    testWidgets("Unconfirmed account routes to email confirmation", (WidgetTester tester) async {
      // Given a returning user enters valid credentials for an account whose email is not confirmed.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().unconfirmedEmail()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When they submit the login form.
      await driver.tapLogin();

      // Then they are taken to email confirmation with credentials available for checks and resends.
      appDriver.assertIsOnPage(EmailConfirmationPage.pageKey);
      await driver.tapConfirmationRecheck();
      await driver.tapConfirmationResend();
      driver.assertConfirmationCredentialsAvailable(email: _validEmail, password: _validPassword);
    });

    testWidgets("Network or unexpected auth failure stays on login", (WidgetTester tester) async {
      // Given a returning user is on the login page.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder().networkError()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When the login request fails because of a network or unexpected auth error.
      await driver.tapLogin();

      // Then the page stays on login and shows the appropriate existing auth error message.
      appDriver.assertIsOnPage(LoginPage.pageKey);
      driver.assertFormErrorVisible();
    });

    testWidgets("Duplicate submit processes one login attempt", (WidgetTester tester) async {
      // Given a login request is already in progress.
      final AppDriver appDriver = AppDriver(tester: tester);
      final LoginDriver driver = LoginDriver(tester: tester, builders: [AuthLoginBuilder()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When the user taps the login action again.
      await driver.tapLoginWithoutSettling();
      driver.assertLoginActionSubmitting();
      await driver.tapLoginAgainWhileBusy();
      await driver.waitForLoginToComplete();

      // Then only one login attempt is processed and the form remains submitting until completion.
      appDriver.assertIsOnPage(MainPage.pageKey);
      driver.assertSignInRequestSent();
      driver.assertOneSignInAttemptProcessed();
    });
  });
}
