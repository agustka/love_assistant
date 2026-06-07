import 'package:flutter_test/flutter_test.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/landing/landing_page.dart';
import 'package:la/presentation/main/main_page.dart';
import 'package:la/presentation/wizard/wizard_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

/// Boots the real [App] (root navigator + named-route table) so cold-start
/// routing performed by `SplashCubit` through `App.navigatorKey` is observable.
class SplashDriver extends BaseDriver {
  Finder get _wizardGreetingsFinder => find.byKey(WizardPage.greetingsStepKey);

  SplashDriver({required super.tester, super.builders});

  Future<void> openApp() async {
    await launchApplication(home: const App());
  }

  Future<void> waitForStartupRouting() async {
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
  }

  Future<void> navigateBack() async {
    App.navigatorKey.currentState?.pop();
    await tester.pumpAndSettle();
  }

  void assertOnWizard() {
    expect(_wizardGreetingsFinder, findsOneWidget);
  }

  void assertOnLanding() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForIdentityKey(LandingPage.pageKey));
  }

  void assertNotOnLanding() {
    expect(
      AppPages.navigationObserver.stack,
      isNot(contains(AppPages.descriptorForIdentityKey(LandingPage.pageKey))),
    );
  }

  void assertOnMain() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForIdentityKey(MainPage.pageKey));
  }

  void assertNotOnWizard() {
    expect(_wizardGreetingsFinder, findsNothing);
  }
}
