import 'package:flutter_test/flutter_test.dart';
import 'package:la/presentation/auth/reset_password_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class ResetPasswordDriver extends BaseDriver {
  Finder get _pageFinder => find.byKey(ResetPasswordPage.pageKey);
  Finder get _emailFieldFinder => find.byKey(ResetPasswordPage.emailFieldKey);
  Finder get _submitButtonFinder => find.byKey(ResetPasswordPage.submitButtonKey);
  Finder get _emailErrorFinder => find.byKey(ResetPasswordPage.emailErrorKey);
  Finder get _formErrorFinder => find.byKey(ResetPasswordPage.formErrorKey);
  Finder get _confirmationMessageFinder => find.byKey(ResetPasswordPage.confirmationMessageKey);

  ResetPasswordDriver({required super.tester});

  void assertOnResetPasswordPage() {
    expect(_pageFinder, findsOneWidget);
  }

  void assertConfirmationMessageVisible() {
    expect(_confirmationMessageFinder, findsOneWidget);
  }

  void assertEmailErrorVisible() {
    expect(_emailErrorFinder, findsOneWidget);
  }

  void assertFormErrorVisible() {
    expect(_formErrorFinder, findsOneWidget);
  }

  Future<void> enterEmail(String email) async {
    await tester.enterText(_emailFieldFinder, email);
    await tester.pump();
  }

  Future<void> tapSendResetLink() async {
    await tester.tap(_submitButtonFinder);
    await tester.pumpAndSettle();
  }
}
