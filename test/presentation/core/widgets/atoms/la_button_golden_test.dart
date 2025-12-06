import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:la/presentation/core/ui_components/atoms/la_button.dart';

import '../../../../_core/test_setup/test_rig.dart';

void main() {
  group("Golden tests", () {
    setUpAll(() async {
      await setupAppDependencies();
    });

    testGoldens("LaButton golden test - accessibility", (WidgetTester tester) async {
      final LabelGoldenBuilder builder = LabelGoldenBuilder.column(
        wrap: (Widget button) => MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3.0)),
          child: button,
        ),
      );
      builder.addScenario(
        "Standard",
        LaButton(text: "Standard", onTap: () {}),
      );
      builder.addScenario(
        "Loading",
        LaButton(text: "Loading", loading: true, onTap: () {}),
      );

      await tester.runAsync(() async {
        await tester.pumpUiComponentWidgetBuilder(
          builder.build(),
        );
      });

      await screenMatchesGolden(tester, "isb_card_mini_light_mode");
    });

    testGoldens("LaButton - normal", (WidgetTester tester) async {
      final LabelGoldenBuilder builder = LabelGoldenBuilder.column();
      builder.addScenario(
        "Default",
        LaButton(text: "Standard", onTap: () {}),
      );
      builder.addScenario(
        "Loading",
        LaButton(text: "Loading", loading: true, onTap: () {}),
      );

      await tester.runAsync(() async {
        await tester.pumpUiComponentWidgetBuilder(
          builder.build(),
        );
      });

      await screenMatchesGolden(tester, "isb_card_mini_light_mode_2");
    });
  });
}
