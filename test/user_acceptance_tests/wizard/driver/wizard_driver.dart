import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la/application/core/language/language_cubit.dart';
import 'package:la/presentation/core/app.dart';
import 'package:la/presentation/wizard/wizard_page.dart';
import 'package:la/setup.dart';

import '../../../_core/test_setup/driver/i_driver.dart';

class WizardDriver extends BaseDriver {
  Finder get _greetingsStepFinder => find.byKey(WizardPage.greetingsStepKey);
  Finder get _basicInfoStepFinder => find.byKey(WizardPage.basicInfoStepKey);
  Finder get _foodsAndGiftsStepFinder => find.byKey(WizardPage.foodsAndGiftsStepKey);
  Finder get _nextButtonFinder => find.byKey(WizardPage.nextButtonKey);

  WizardDriver({required super.tester, super.builders});

  Future<void> openPage() async {
    await launchApplication(
      home: BlocProvider<LanguageCubit>(
        create: (_) => getIt<LanguageCubit>(),
        child: const WizardPage(),
      ),
      initialPageName: PageName.wizard,
    );
  }

  void assertOnGreetingsStep() {
    expect(_greetingsStepFinder, findsOneWidget);
  }

  void assertOnBasicInfoStep() {
    expect(_basicInfoStepFinder, findsOneWidget);
  }

  void assertNotOnGreetingsStep() {
    expect(_greetingsStepFinder, findsNothing);
  }

  void assertNotOnBasicInfoStep() {
    expect(_basicInfoStepFinder, findsNothing);
  }

  void assertOnLastStep() {
    expect(_foodsAndGiftsStepFinder, findsOneWidget);
  }

  Future<void> tapNext() async {
    await tester.tap(_nextButtonFinder);
    await tester.pumpAndSettle();
  }
}
