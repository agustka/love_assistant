import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la/infrastructure/core/auth/auth_event_type.dart';
import 'package:la/infrastructure/core/auth/service/i_auth_service.dart';
import 'package:la/infrastructure/core/auth/service/offline/offline_auth_service.dart';
import 'package:la/presentation/auth/email_confirmation_page.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/setup.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class EmailConfirmationDriver extends BaseDriver {
  Finder get _confirmButtonFinder => find.byKey(EmailConfirmationPage.confirmButtonKey);
  Finder get _resendButtonFinder => find.byKey(EmailConfirmationPage.resendButtonKey);
  Finder get _pendingErrorFinder => find.byKey(EmailConfirmationPage.pendingErrorKey);
  Finder get _networkErrorFinder => find.byKey(EmailConfirmationPage.networkErrorKey);
  Finder get _resendSuccessFinder => find.byKey(EmailConfirmationPage.resendSuccessKey);
  Finder get _resendErrorFinder => find.byKey(EmailConfirmationPage.resendErrorKey);

  EmailConfirmationDriver({required super.tester});

  void assertOnConfirmationPage() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForName(PageName.emailConfirmation));
  }

  void assertOnSignUpPage() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForName(PageName.signUp));
  }

  void assertOnMainPage() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForName(PageName.main));
  }

  void assertPendingMessageVisible() {
    expect(_pendingErrorFinder, findsOneWidget);
  }

  void assertNoPendingMessage() {
    expect(_pendingErrorFinder, findsNothing);
  }

  void assertConnectionErrorVisible() {
    expect(_networkErrorFinder, findsOneWidget);
  }

  void assertResendSuccessVisible() {
    expect(_resendSuccessFinder, findsOneWidget);
  }

  void assertResendErrorVisible() {
    expect(_resendErrorFinder, findsOneWidget);
  }

  void assertResendErrorNotVisibleAfterResend() {
    expect(_resendErrorFinder, findsNothing);
  }

  Future<void> tapRecheck() async {
    await tester.tap(_confirmButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapRecheckTwiceRapidly() async {
    await tester.tap(_confirmButtonFinder);
    await tester.tap(_confirmButtonFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  Future<void> tapResend() async {
    await tester.tap(_resendButtonFinder);
    await tester.pump();
    await tester.pump();
  }

  Future<void> tapResendAgainExpectingNoOp() async {
    await tester.tap(_resendButtonFinder, warnIfMissed: false);
    await tester.pump();
    await tester.pump();
  }

  Future<void> emitSignedInAuthEvent() async {
    final OfflineAuthService service = getIt<IAuthService>() as OfflineAuthService;
    service.emitAuthEvent(AuthEventType.login);
    await tester.pumpAndSettle();
  }

  Future<void> navigateBack() async {
    final NavigatorState navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.pop();
    await tester.pumpAndSettle();
  }
}
