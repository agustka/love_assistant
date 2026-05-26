import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:la/presentation/core/ui_components/molecules/la_feature_heading_molecule.dart';

import '../../../../_core/test_rig.dart';

void main() {
  tearDown(() async {
    await closeApp();
  });

  Widget harness() {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: LaFeatureHeadingMolecule(
            title: "Welcome to BetterHalf",
            subtitle: "Set up your partner profile to get started",
          ),
        ),
      ),
    );
  }

  group("LaFeatureHeadingMolecule", () {
    testGoldens("Light mode", (WidgetTester tester) async {
      await launchApp(tester, home: harness(), size: const Size(400, 240));

      await screenMatchesGolden(tester, "la_feature_heading_molecule_light");
    });

    testGoldens("Dark mode", (WidgetTester tester) async {
      await launchApp(tester, home: harness(), brightness: Brightness.dark, size: const Size(400, 240));

      await screenMatchesGolden(tester, "la_feature_heading_molecule_dark");
    });
  });
}
