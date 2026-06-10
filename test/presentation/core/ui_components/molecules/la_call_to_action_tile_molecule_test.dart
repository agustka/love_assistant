import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:golden_toolkit/golden_toolkit.dart";
import "package:la/presentation/core/ui_components/molecules/la_call_to_action_tile_molecule.dart";

import "../../../../_core/test_rig.dart";

void main() {
  tearDown(() async {
    await closeApp();
  });

  Widget harness({
    VoidCallback? onActionTap,
    VoidCallback? onDismissTap,
    bool actionEnabled = true,
    bool actionBusy = false,
  }) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: LaCallToActionTileMolecule(
            title: "Finish your partner profile",
            message: "Add a few more details so BetterHalf can prepare options that fit them.",
            actionText: "Finish profile",
            dismissSemanticLabel: "Dismiss profile prompt",
            actionKey: const Key("ctaAction"),
            dismissKey: const Key("ctaDismiss"),
            actionEnabled: actionEnabled,
            actionBusy: actionBusy,
            onActionTap: onActionTap ?? () {},
            onDismissTap: onDismissTap ?? () {},
          ),
        ),
      ),
    );
  }

  group("LaCallToActionTileMolecule", () {
    testWidgets("renders copy and invokes callbacks once", (WidgetTester tester) async {
      int actionTapCount = 0;
      int dismissTapCount = 0;

      await launchApp(
        tester,
        home: harness(
          onActionTap: () {
            actionTapCount += 1;
          },
          onDismissTap: () {
            dismissTapCount += 1;
          },
        ),
      );

      expect(find.text("Finish your partner profile"), findsOneWidget);
      expect(find.text("Add a few more details so BetterHalf can prepare options that fit them."), findsOneWidget);
      expect(find.text("Finish profile"), findsOneWidget);
      expect(find.bySemanticsLabel("Dismiss profile prompt"), findsOneWidget);

      await tester.tap(find.text("Finish profile"));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key("ctaDismiss")));
      await tester.pumpAndSettle();

      expect(actionTapCount, 1);
      expect(dismissTapCount, 1);
    });

    testWidgets("disabled action does not invoke its callback", (WidgetTester tester) async {
      int actionTapCount = 0;

      await launchApp(
        tester,
        home: harness(
          actionEnabled: false,
          onActionTap: () {
            actionTapCount += 1;
          },
        ),
      );

      await tester.tap(find.text("Finish profile"), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(actionTapCount, 0);
    });

    testGoldens("Light mode", (WidgetTester tester) async {
      await launchApp(tester, home: harness(), size: const Size(400, 280));

      await screenMatchesGolden(tester, "la_call_to_action_tile_molecule_light");
    });

    testGoldens("Dark mode", (WidgetTester tester) async {
      await launchApp(
        tester,
        home: harness(),
        brightness: Brightness.dark,
        size: const Size(400, 280),
      );

      await screenMatchesGolden(tester, "la_call_to_action_tile_molecule_dark");
    });

    testGoldens("Disabled action", (WidgetTester tester) async {
      await launchApp(
        tester,
        home: harness(actionEnabled: false),
        size: const Size(400, 280),
      );

      await screenMatchesGolden(tester, "la_call_to_action_tile_molecule_disabled");
    });
  });
}
