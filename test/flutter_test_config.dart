import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:logger/logger.dart';

import '_core/golden_tolerance_comparator.dart';

const bool _verboseTestLogs = bool.fromEnvironment("VERBOSE_TEST_LOGS");

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Offline fakes throw simulated failures on purpose, and repositories log
  // them via err() before returning a Payload.failure. Silence that expected
  // noise by default; run with --dart-define=VERBOSE_TEST_LOGS=true to see it.
  Logger.level = _verboseTestLogs ? Level.trace : Level.off;

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
