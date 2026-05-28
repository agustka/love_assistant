import 'package:flutter/material.dart';
import 'package:la/presentation/auth/email_confirmation_page.dart';
import 'package:la/presentation/auth/sign_up_page.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/main/main_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class SignUpGoldenDriver extends BaseDriver {
  const SignUpGoldenDriver({
    required super.tester,
    super.brightness,
    super.accessibilityMode,
    super.goldenTest,
    super.size,
  });

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
}
