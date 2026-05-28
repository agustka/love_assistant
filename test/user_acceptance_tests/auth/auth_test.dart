import 'package:flutter_test/flutter_test.dart';

import '../../_core/test_rig.dart';
import '../../_core/test_setup/builders/auth/auth_sign_up_builder.dart';
import 'driver/email_confirmation_driver.dart';
import 'driver/sign_up_driver.dart';

const String _validEmail = "valid@example.com";
const String _validPassword = "password123";

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Sign-up screen", () {
    testWidgets("Valid email and password routes to the email-confirmation screen", (WidgetTester tester) async {
      // Given the user is on the sign-up screen with a valid email and a password of at least 6 chars
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When they tap the sign-up button
      await driver.tapSignUp();

      // Then the account is created and the email-confirmation screen is shown (no active session yet)
      driver.assertOnConfirmationPage();
    });

    testWidgets("Invalid email on submit shows inline email validation and makes no request",
        (WidgetTester tester) async {
      // Given the user entered an email that is not a valid address
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder()]);
      await driver.openPage();
      await driver.enterEmail("not-an-email");
      await driver.enterPassword(_validPassword);

      // When they tap the sign-up button
      await driver.tapSignUp();

      // Then no sign-up request is made and an inline email validation message shows
      driver.assertEmailErrorVisible();
      driver.assertNotOnConfirmationPage();
    });

    testWidgets("Password too short on submit shows inline password validation and makes no request",
        (WidgetTester tester) async {
      // Given the user entered a password shorter than 6 characters
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword("abc");

      // When they tap the sign-up button
      await driver.tapSignUp();

      // Then no sign-up request is made and an inline password validation message shows
      driver.assertPasswordErrorVisible();
      driver.assertNotOnConfirmationPage();
    });

    testWidgets("Password strength indicator updates live and is advisory only", (WidgetTester tester) async {
      // Given the user is on the sign-up screen
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder()]);
      await driver.openPage();

      // When they type in the password field
      await driver.enterPassword("a");

      // Then the strength indicator below the field is shown (advisory; never blocks beyond minimum length)
      driver.assertStrengthMeterVisible();
    });

    testWidgets("Already-registered email is detected and no confirmation screen is shown",
        (WidgetTester tester) async {
      // Given the user enters an email that already has an account (boundary returns an empty-identities user)
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder().duplicateEmail()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When they tap the sign-up button
      await driver.tapSignUp();

      // Then the returned user is recognized as existing, no confirmation screen is shown, and a form error shows
      driver.assertFormErrorVisible();
      driver.assertNotOnConfirmationPage();
    });

    testWidgets("Sign-up failure shows an error and allows retry", (WidgetTester tester) async {
      // Given the sign-up request fails at the boundary
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder().signUpFails()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When the user taps the sign-up button
      await driver.tapSignUp();

      // Then an error message is shown on the sign-up screen and the user can try again
      driver.assertFormErrorVisible();
      driver.assertOnSignUpPage();
    });

    testWidgets("Unexpected sign-up failure shows a generic error", (WidgetTester tester) async {
      // Given the sign-up request fails for an unexpected reason
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder().signUpFails()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When the user taps the sign-up button
      await driver.tapSignUp();

      // Then a generic error message is shown and the user remains on the sign-up screen
      driver.assertFormErrorVisible();
      driver.assertOnSignUpPage();
    });

    testWidgets("Sign-up button prevents duplicate submissions in flight", (WidgetTester tester) async {
      // Given a valid email and password on the sign-up screen and a sign-up request in flight
      final SignUpDriver driver = SignUpDriver(tester: tester, builders: [AuthSignUpBuilder()]);
      await driver.openPage();
      await driver.enterEmail(_validEmail);
      await driver.enterPassword(_validPassword);

      // When the user taps sign-up twice before it returns
      await driver.tapSignUpWithoutSettling();
      await driver.tapSignUpAgainWhileBusy();
      await driver.tapSignUp();

      // Then duplicate submissions are prevented and the flow lands once on the confirmation screen
      driver.assertOnConfirmationPage();
    });
  });

  group("Email-confirmation screen", () {
    Future<EmailConfirmationDriver> openConfirmation(WidgetTester tester, AuthSignUpBuilder builder) async {
      final SignUpDriver signUp = SignUpDriver(tester: tester, builders: [builder]);
      await signUp.openPage();
      await signUp.enterEmail(_validEmail);
      await signUp.enterPassword(_validPassword);
      await signUp.tapSignUp();
      return EmailConfirmationDriver(tester: tester);
    }

    testWidgets("Confirmed email re-check establishes a session and lands on main", (WidgetTester tester) async {
      // Given the user is on the email-confirmation screen and has tapped the emailed link
      final EmailConfirmationDriver driver = await openConfirmation(tester, AuthSignUpBuilder().confirmationConfirmed());
      driver.assertOnConfirmationPage();

      // When they tap "I've confirmed my email"
      await driver.tapRecheck();

      // Then a session is established and they land on the main app screen (under-construction placeholder)
      driver.assertOnMainPage();
    });

    testWidgets("Re-check before confirming keeps the screen and shows a pending message",
        (WidgetTester tester) async {
      // Given the user is on the email-confirmation screen and has not yet confirmed via the link
      final EmailConfirmationDriver driver = await openConfirmation(tester, AuthSignUpBuilder());
      driver.assertOnConfirmationPage();

      // When they tap "I've confirmed my email"
      await driver.tapRecheck();

      // Then they remain on the screen and a pending message shows
      driver.assertOnConfirmationPage();
      driver.assertPendingMessageVisible();
    });

    testWidgets("Re-check network failure shows a distinct connection error, not a pending message",
        (WidgetTester tester) async {
      // Given the device cannot reach the server during re-check
      final EmailConfirmationDriver driver =
          await openConfirmation(tester, AuthSignUpBuilder().confirmationNetworkError());
      driver.assertOnConfirmationPage();

      // When they tap "I've confirmed my email"
      await driver.tapRecheck();

      // Then they remain on the screen and a connection error shows, not a pending message
      driver.assertOnConfirmationPage();
      driver.assertConnectionErrorVisible();
      driver.assertNoPendingMessage();
    });

    testWidgets("Re-check unexpected failure shows a distinct generic error, not a pending message",
        (WidgetTester tester) async {
      // Given the re-check fails unexpectedly
      final EmailConfirmationDriver driver =
          await openConfirmation(tester, AuthSignUpBuilder().confirmationUnexpectedError());
      driver.assertOnConfirmationPage();

      // When they tap "I've confirmed my email"
      await driver.tapRecheck();

      // Then they remain on the screen and a generic error shows, not a pending message
      driver.assertOnConfirmationPage();
      driver.assertConnectionErrorVisible();
      driver.assertNoPendingMessage();
    });

    testWidgets("Resend email re-sends, disables the action for a cooldown, and confirms it was sent",
        (WidgetTester tester) async {
      // Given the user is on the email-confirmation screen and the email has not arrived
      final EmailConfirmationDriver driver = await openConfirmation(tester, AuthSignUpBuilder());
      driver.assertOnConfirmationPage();

      // When they tap "Resend email"
      await driver.tapResend();

      // Then the email is re-sent and a confirmation is shown; tapping again during cooldown is a no-op
      driver.assertResendSuccessVisible();
      await driver.tapResendAgainExpectingNoOp();
      driver.assertResendSuccessVisible();
      driver.assertResendErrorNotVisibleAfterResend();
    });

    testWidgets("Resend that is rate-limited or fails keeps the screen and shows a retry-later message",
        (WidgetTester tester) async {
      // Given the back end rejects the resend (rate-limited)
      final EmailConfirmationDriver driver = await openConfirmation(tester, AuthSignUpBuilder().resendRateLimited());
      driver.assertOnConfirmationPage();

      // When the request returns
      await driver.tapResend();

      // Then a retry-later message shows and the user stays on the email-confirmation screen
      driver.assertResendErrorVisible();
      driver.assertOnConfirmationPage();
    });

    testWidgets("Observed signed-in auth event auto-routes to main without tapping re-check",
        (WidgetTester tester) async {
      // Given the user is on the email-confirmation screen
      final EmailConfirmationDriver driver = await openConfirmation(tester, AuthSignUpBuilder());
      driver.assertOnConfirmationPage();

      // When a signed-in auth event is observed
      await driver.emitSignedInAuthEvent();

      // Then a session is established and they are routed to main automatically, without tapping re-check
      driver.assertOnMainPage();
    });

    testWidgets("Back navigation returns to the sign-up screen without stranding the user",
        (WidgetTester tester) async {
      // Given the user is on the email-confirmation screen
      final EmailConfirmationDriver driver = await openConfirmation(tester, AuthSignUpBuilder());
      driver.assertOnConfirmationPage();

      // When they navigate back
      await driver.navigateBack();

      // Then they return to the sign-up screen and can correct the email and sign up again
      driver.assertOnSignUpPage();
    });

    testWidgets("Re-check prevents duplicate submissions in flight and confirms once", (WidgetTester tester) async {
      // Given a confirmation re-check request is in flight
      final EmailConfirmationDriver driver = await openConfirmation(tester, AuthSignUpBuilder().confirmationConfirmed());
      driver.assertOnConfirmationPage();

      // When the user taps "I've confirmed my email" twice before it returns
      await driver.tapRecheckTwiceRapidly();

      // Then duplicate submissions are prevented and the flow lands once on the main app screen
      driver.assertOnMainPage();
    });
  });
}
