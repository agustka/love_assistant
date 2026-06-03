import 'package:la/presentation/auth/login_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class LoginGoldenDriver extends BaseDriver {
  const LoginGoldenDriver({
    required super.tester,
    super.brightness,
    super.accessibilityMode,
    super.goldenTest,
    super.size,
  });

  Future<void> openPage() async {
    await launchApplication(home: const LoginPage());
  }
}
