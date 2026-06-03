import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:la/application/core/language/language_cubit.dart";
import "package:la/presentation/auth/login_page.dart";
import "package:la/presentation/auth/sign_up_page.dart";
import "package:la/presentation/core/app.dart";
import "package:la/presentation/core/ui_components/organisms/la_app_bar_organism.dart";
import "package:la/presentation/landing/landing_page.dart";
import "package:la/presentation/wizard/wizard_page.dart";
import "package:la/setup.dart";

import "../../../_core/test_setup/driver/i_driver.dart";

class LoginEntryPointsDriver extends BaseDriver {
  Finder get _wizardPageFinder => find.byKey(WizardPage.greetingsStepKey);
  Finder get _wizardPrimaryActionFinder => find.byKey(WizardPage.nextButtonKey);
  Finder get _wizardLoginPromptFinder => find.byKey(WizardPage.loginPromptKey);
  Finder get _wizardLoginActionFinder => find.byKey(WizardPage.loginActionKey);
  Finder get _landingPageFinder => find.byKey(LandingPage.pageKey);
  Finder get _landingPrimaryActionFinder => find.byKey(LandingPage.signUpButtonKey);
  Finder get _landingLoginPromptFinder => find.byKey(LandingPage.loginPromptKey);
  Finder get _landingLoginActionFinder => find.byKey(LandingPage.loginActionKey);
  Finder get _loginPageFinder => find.byKey(LoginPage.pageKey);
  Finder get _loginUnderConstructionFinder => find.byKey(LoginPage.underConstructionKey);
  Finder get _backButtonFinder => find.byKey(LaAppBarOrganism.backButtonKey);

  LoginEntryPointsDriver({required super.tester, super.builders});

  Future<void> openWizardPage() async {
    await launchApplication(
      home: BlocProvider<LanguageCubit>(
        create: (_) => getIt<LanguageCubit>(),
        child: const WizardPage(),
      ),
      routes: _routes,
    );
  }

  Future<void> openLandingPage() async {
    await launchApplication(
      home: const LandingPage(),
      routes: _routes,
    );
  }

  void assertOnWizardPage() {
    expect(_wizardPageFinder, findsOneWidget);
  }

  void assertWizardLoginAffordanceVisible() {
    expect(_wizardLoginPromptFinder, findsOneWidget);
    expect(_wizardLoginActionFinder, findsOneWidget);
  }

  void assertWizardPrimaryActionVisible() {
    expect(_wizardPrimaryActionFinder, findsOneWidget);
  }

  void assertOnLandingPage() {
    expect(_landingPageFinder, findsOneWidget);
  }

  void assertLandingLoginAffordanceVisible() {
    expect(_landingLoginPromptFinder, findsOneWidget);
    expect(_landingLoginActionFinder, findsOneWidget);
  }

  void assertLandingPrimaryActionVisible() {
    expect(_landingPrimaryActionFinder, findsOneWidget);
  }

  void assertOnLoginPage() {
    expect(_loginPageFinder, findsOneWidget);
  }

  void assertLoginUnderConstructionVisible() {
    expect(_loginUnderConstructionFinder, findsOneWidget);
  }

  void assertBackButtonVisible() {
    expect(_backButtonFinder, findsOneWidget);
  }

  Future<void> tapWizardLogin() async {
    await tester.tap(_wizardLoginActionFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapLandingLogin() async {
    await tester.tap(_landingLoginActionFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapBack() async {
    await tester.tap(_backButtonFinder);
    await tester.pumpAndSettle();
  }

  Map<String, WidgetBuilder> get _routes {
    return {
      PageName.wizard.route: (BuildContext context) => const WizardPage(),
      PageName.landing.route: (BuildContext context) => const LandingPage(),
      PageName.login.route: (BuildContext context) => const LoginPage(),
      PageName.signUp.route: (BuildContext context) => const SignUpPage(),
    };
  }
}
