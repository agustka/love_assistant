import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la/presentation/auth/email_confirmation_page.dart';
import 'package:la/presentation/auth/sign_up_page.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart';
import 'package:la/presentation/landing/landing_page.dart';
import 'package:la/presentation/main/main_page.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class BackNavigationDriver extends BaseDriver {
  Finder get _backButtonFinder => find.byKey(LaAppBarOrganism.backButtonKey);

  BackNavigationDriver({required super.tester, super.builders});

  Future<void> openPage() async {
    await launchApplication(
      home: const LandingPage(),
      routes: {
        PageName.landing.route: (BuildContext context) => const LandingPage(),
        PageName.signUp.route: (BuildContext context) => const SignUpPage(),
        PageName.emailConfirmation.route: (BuildContext context) => const EmailConfirmationPage(),
        PageName.main.route: (BuildContext context) => const MainPage(),
      },
    );
  }

  Future<void> goToSignUp() async {
    final NavigatorState navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
    unawaited(navigator.pushNamed(PageName.signUp.route));
    await tester.pumpAndSettle();
  }

  Future<void> tapBackArrow() async {
    await tester.tap(_backButtonFinder);
    await tester.pumpAndSettle();
  }

  void assertOnLandingPage() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForName(PageName.landing));
  }

  void assertOnSignUpPage() {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForName(PageName.signUp));
  }
}
