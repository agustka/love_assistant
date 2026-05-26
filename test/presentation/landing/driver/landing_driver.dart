import 'package:la/presentation/landing/landing_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class LandingDriver extends BaseDriver {
  const LandingDriver({
    required super.tester,
    super.brightness,
    super.accessibilityMode,
    super.goldenTest,
    super.size,
  });

  Future<void> openPage() async {
    await launchApplication(home: const LandingPage());
  }
}
