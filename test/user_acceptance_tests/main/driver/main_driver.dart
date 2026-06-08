import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:la/presentation/core/app.dart";
import "package:la/presentation/core/ui_components/molecules/la_call_to_action_tile_molecule.dart";
import "package:la/presentation/main/main_page.dart";

import "../../../_core/test_rig.dart";
import "../../../_core/test_setup/driver/i_driver.dart";

class MainDriver extends BaseDriver {
  int _profileCompletionCtaActionTapCount = 0;
  int _profileCompletionCtaDismissTapCount = 0;

  Finder get _profileCompletionCtaFinder => find.byKey(MainPage.profileCompletionCtaKey);
  Finder get _profileCompletionCtaActionFinder => find.byKey(MainPage.profileCompletionCtaActionKey);
  Finder get _profileCompletionCtaDismissFinder => find.byKey(MainPage.profileCompletionCtaDismissKey);

  MainDriver({required super.tester, super.builders});

  Future<void> openPage() async {
    await launchApplication(
      home: const MainPage(),
      initialPageName: PageName.main,
    );
  }

  Future<void> openReusableCtaTileHarness() async {
    _profileCompletionCtaActionTapCount = 0;
    _profileCompletionCtaDismissTapCount = 0;

    await launchApplication(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: LaCallToActionTileMolecule(
            key: MainPage.profileCompletionCtaKey,
            title: "Finish your partner profile",
            message: "Add a few more details so BetterHalf can prepare options that fit them.",
            actionText: "Finish profile",
            dismissSemanticLabel: "Dismiss profile prompt",
            actionKey: MainPage.profileCompletionCtaActionKey,
            dismissKey: MainPage.profileCompletionCtaDismissKey,
            onActionTap: () {
              _profileCompletionCtaActionTapCount += 1;
            },
            onDismissTap: () {
              _profileCompletionCtaDismissTapCount += 1;
            },
          ),
        ),
      ),
    );
  }

  Future<void> restartPage() async {
    await closeApp();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await openPage();
  }

  void assertProfileCompletionCtaVisible() {
    expect(_profileCompletionCtaFinder, findsOneWidget);
  }

  void assertProfileCompletionCtaHidden() {
    expect(_profileCompletionCtaFinder, findsNothing);
  }

  void assertProfileCompletionCtaIsNearTop() {
    final Offset topLeft = tester.getTopLeft(_profileCompletionCtaFinder);

    expect(topLeft.dy, lessThan(120));
  }

  void assertProfileCompletionCtaCopy() {
    final LaCallToActionTileMolecule tile = tester.widget(_profileCompletionCtaFinder);

    expect(tile.title, "Finish your partner profile");
    expect(tile.message, "Add a few more details so BetterHalf can prepare options that fit them.");
    expect(tile.actionText, "Finish profile");
  }

  void assertProfileCompletionCtaCallbacksWereCalledOnce() {
    expect(_profileCompletionCtaActionTapCount, 1);
    expect(_profileCompletionCtaDismissTapCount, 1);
  }

  void assertDetailedWizardOpenedOnce() {
    final int wizardPageCount = AppPages.navigationObserver.stack
        .where((AppPageDescriptor descriptor) => descriptor.name == PageName.wizard)
        .length;

    expect(wizardPageCount, 1);
  }

  Future<void> tapProfileCompletionCtaAction() async {
    await tester.tap(_profileCompletionCtaActionFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapProfileCompletionCtaDismiss() async {
    await tester.tap(_profileCompletionCtaDismissFinder);
    await tester.pumpAndSettle();
  }
}
