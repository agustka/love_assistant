import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la/presentation/auth/login_page.dart';
import 'package:la/presentation/auth/email_confirmation_page.dart';
import 'package:la/presentation/auth/reset_password_page.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/main/main_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class LoginDriver extends BaseDriver {
  Finder get _pageFinder => find.byKey(LoginPage.pageKey);
  Finder get _emailFieldFinder => find.byKey(LoginPage.emailFieldKey);
  Finder get _passwordFieldFinder => find.byKey(LoginPage.passwordFieldKey);
  Finder get _submitButtonFinder => find.byKey(LoginPage.submitButtonKey);
  Finder get _emailErrorFinder => find.byKey(LoginPage.emailErrorKey);
  Finder get _passwordErrorFinder => find.byKey(LoginPage.passwordErrorKey);
  Finder get _formErrorFinder => find.byKey(LoginPage.formErrorKey);
  Finder get _forgotPasswordButtonFinder => find.byKey(LoginPage.forgotPasswordButtonKey);
  Finder get _mainPageFinder => find.byKey(MainPage.pageKey);
  Finder get _confirmationPageFinder => find.byKey(EmailConfirmationPage.pageKey);
  Finder get _resetPasswordPageFinder => find.byKey(ResetPasswordPage.pageKey);

  LoginDriver({required super.tester, super.builders});

  Future<void> openPage() async {
    await launchApplication(
      home: const LoginPage(),
      routes: {
        PageName.login.route: (BuildContext context) => const LoginPage(),
        PageName.emailConfirmation.route: (BuildContext context) => const EmailConfirmationPage(),
        PageName.resetPassword.route: (BuildContext context) => const ResetPasswordPage(),
        PageName.main.route: (BuildContext context) => const MainPage(),
      },
    );
  }

  void assertOnLoginPage() {
    expect(_pageFinder, findsOneWidget);
  }

  void assertOnMainPage() {
    expect(_mainPageFinder, findsOneWidget);
  }

  void assertOnConfirmationPage() {
    expect(_confirmationPageFinder, findsOneWidget);
  }

  void assertOnResetPasswordPage() {
    expect(_resetPasswordPageFinder, findsOneWidget);
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

  Future<void> tapForgotPassword() async {
    await tester.tap(_forgotPasswordButtonFinder);
    await tester.pumpAndSettle();
  }
}
