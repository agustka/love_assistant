import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:la/domain/core/entities/email_password_credentials.dart";
import "package:la/infrastructure/core/auth/service/i_auth_service.dart";
import "package:la/presentation/auth/email_confirmation_page.dart";
import "package:la/presentation/auth/login_page.dart";
import "package:la/presentation/core/app.dart";
import "package:la/presentation/core/ui_components/atoms/la_button_atom.dart";
import "package:la/presentation/main/main_page.dart";
import "package:la/setup.dart";

import "../../../_core/test_setup/builders/auth/auth_login_builder.dart";
import "../../../_core/test_setup/driver/i_driver.dart";

class LoginDriver extends BaseDriver {
  Finder get _emailFieldFinder => find.byKey(LoginPage.emailEditableKey);
  Finder get _passwordFieldFinder => find.byKey(LoginPage.passwordEditableKey);
  Finder get _submitButtonFinder => find.byKey(LoginPage.submitButtonKey);
  Finder get _emailErrorFinder => find.byKey(LoginPage.emailErrorKey);
  Finder get _passwordErrorFinder => find.byKey(LoginPage.passwordErrorKey);
  Finder get _formErrorFinder => find.byKey(LoginPage.formErrorKey);
  Finder get _confirmationRecheckButtonFinder => find.byKey(EmailConfirmationPage.confirmButtonKey);
  Finder get _confirmationResendButtonFinder => find.byKey(EmailConfirmationPage.resendButtonKey);
  AuthLoginServiceSpy get _authService => getIt<IAuthService>() as AuthLoginServiceSpy;

  LoginDriver({required super.tester, super.builders});

  Future<void> openPage() async {
    await launchApplication(
      home: const LoginPage(),
      routes: {
        PageName.login.route: (BuildContext context) => const LoginPage(),
        PageName.emailConfirmation.route: (BuildContext context) => const EmailConfirmationPage(),
        PageName.main.route: (BuildContext context) => const MainPage(),
      },
    );
  }

  void assertEmailErrorVisible() {
    expect(_emailErrorFinder, findsOneWidget);
  }

  void assertPasswordErrorVisible() {
    expect(_passwordErrorFinder, findsOneWidget);
  }

  void assertFormErrorVisible() {
    expect(_formErrorFinder, findsOneWidget);
  }

  void assertFormFieldsVisible() {
    expect(_emailFieldFinder, findsOneWidget);
    expect(_passwordFieldFinder, findsOneWidget);
    expect(_submitButtonFinder, findsOneWidget);
  }

  void assertNoSignInRequestSent() {
    expect(_authService.lastSignInCredentials, isNull);
  }

  void assertSignInRequestSent() {
    expect(_authService.lastSignInCredentials, isNotNull);
  }

  void assertOneSignInAttemptProcessed() {
    expect(_authService.signInAttemptCount, 1);
  }

  void assertLoginActionSubmitting() {
    final LaButtonAtom submitButton = tester.widget<LaButtonAtom>(_submitButtonFinder);
    expect(submitButton.busy, isTrue);
    expect(submitButton.enabled, isFalse);
  }

  void assertConfirmationCredentialsAvailable({required String email, required String password}) {
    final EmailPasswordCredentials expectedCredentials = EmailPasswordCredentials.fromInput(
      email: email,
      password: password,
    );
    expect(_authService.lastRecheckCredentials, expectedCredentials);
    expect(_authService.lastResendCredentials, expectedCredentials);
  }

  Future<void> enterEmail(String email) async {
    await tester.enterText(_emailFieldFinder, email);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    await tester.enterText(_passwordFieldFinder, password);
    await tester.pump();
  }

  Future<void> tapLogin() async {
    await tester.tap(_submitButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginWithoutSettling() async {
    await tester.tap(_submitButtonFinder);
    await tester.pump();
  }

  Future<void> tapLoginAgainWhileBusy() async {
    await tester.tap(_submitButtonFinder, warnIfMissed: false);
    await tester.pump();
  }

  Future<void> waitForLoginToComplete() async {
    await tester.pumpAndSettle();
  }

  Future<void> tapConfirmationRecheck() async {
    await tester.tap(_confirmationRecheckButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapConfirmationResend() async {
    await tester.tap(_confirmationResendButtonFinder);
    await tester.pump();
    await tester.pump();
  }
}
