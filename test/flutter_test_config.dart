import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_core/golden_tolerance_comparator.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // 1. Fonts - eliminates 80% of golden flakiness + churn
  await loadAppFonts();

  // 2. Golden toolkit global config (devices, DPR, surface behavior)
  GoldenToolkit.runWithConfiguration(
    () {},
    config: GoldenToolkitConfiguration(
      defaultDevices: const [Device.phone],
    ),
  );

  // 3. Your tolerant comparator (still great to keep)
  if (goldenFileComparator is LocalFileComparator) {
    final Uri baseUri = (goldenFileComparator as LocalFileComparator).basedir;

    const double tolerance = 0.0005;

    goldenFileComparator = GoldenToleranceComparator(
      baseUri,
      toleranceFraction: tolerance,
    );
  }

  await testMain();
}
