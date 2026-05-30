import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la/presentation/auth/email_confirmation_page.dart';
import 'package:la/presentation/auth/sign_up_page.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/ui_components/molecules/la_password_strength_molecule.dart';
import 'package:la/presentation/main/main_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class SignUpDriver extends BaseDriver {
  Finder get _pageFinder => find.byKey(SignUpPage.pageKey);
  Finder get _emailFieldFinder =>
      find.descendant(of: find.byKey(SignUpPage.emailFieldKey), matching: find.byType(EditableText));
  Finder get _passwordFieldFinder =>
      find.descendant(of: find.byKey(SignUpPage.passwordFieldKey), matching: find.byType(EditableText));
  Finder get _submitButtonFinder => find.byKey(SignUpPage.submitButtonKey);
  Finder get _emailErrorFinder => find.byKey(SignUpPage.emailErrorKey);
  Finder get _passwordErrorFinder => find.byKey(SignUpPage.passwordErrorKey);
  Finder get _formErrorFinder => find.byKey(SignUpPage.formErrorKey);
  Finder get _strengthMeterFinder => find.byKey(LaPasswordStrengthMolecule.meterKey);
  Finder get _confirmationPageFinder => find.byKey(EmailConfirmationPage.pageKey);

  SignUpDriver({required super.tester, super.builders});

  Future<void> openPage() async {
    await launchApplication(
      home: const SignUpPage(),
      routes: {
        PageName.signUp.route: (BuildContext context) => const SignUpPage(),
        PageName.emailConfirmation.route: (BuildContext context) => const EmailConfirmationPage(),
        PageName.main.route: (BuildContext context) => const MainPage(),
      },
    );
  }

  void assertOnSignUpPage() {
    expect(_pageFinder, findsOneWidget);
  }

  void assertEmailFieldFocused() {
    expect(tester.widget<EditableText>(_emailFieldFinder).focusNode.hasFocus, isTrue);
  }

  void assertPasswordFieldFocused() {
    expect(tester.widget<EditableText>(_passwordFieldFinder).focusNode.hasFocus, isTrue);
  }

  Future<void> triggerEmailNextAction() async {
    await tester.showKeyboard(_emailFieldFinder);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();
  }

  void assertOnConfirmationPage() {
    expect(_confirmationPageFinder, findsOneWidget);
  }

  void assertNotOnConfirmationPage() {
    expect(_confirmationPageFinder, findsNothing);
  }

  void assertStrengthMeterVisible() {
    expect(_strengthMeterFinder, findsOneWidget);
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

  Future<void> tapSignUp() async {
    await tester.tap(_submitButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapSignUpWithoutSettling() async {
    await tester.tap(_submitButtonFinder);
    await tester.pump();
  }

  Future<void> tapSignUpAgainWhileBusy() async {
    await tester.tap(_submitButtonFinder, warnIfMissed: false);
    await tester.pump();
  }
}
