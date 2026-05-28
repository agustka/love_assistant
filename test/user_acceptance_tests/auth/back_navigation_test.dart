import 'package:flutter_test/flutter_test.dart';

import '../../_core/test_rig.dart';
import 'driver/back_navigation_driver.dart';

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("Sign-up back navigation", () {
    testWidgets("Back arrow on sign-up returns to the landing page", (WidgetTester tester) async {
      // Given the user is on the sign-up page, having arrived from the landing page
      final BackNavigationDriver driver = BackNavigationDriver(tester: tester);
      await driver.openPage();
      await driver.goToSignUp();
      driver.assertOnSignUpPage();

      // When they tap the back arrow in the app bar
      await driver.tapBackArrow();

      // Then they return to the landing page
      driver.assertOnLandingPage();
    });
  });
}
