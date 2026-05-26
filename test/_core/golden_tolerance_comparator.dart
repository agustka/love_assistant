import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class GoldenToleranceComparator extends LocalFileComparator {
  final Uri testFileLocation;
  final double toleranceFraction;

  Uri get _testDir => testFileLocation.resolve(".");

  GoldenToleranceComparator(
    this.testFileLocation, {
    required this.toleranceFraction,
  }) : super(testFileLocation);

  String? findTestFile() {
    final Directory dir = Directory(_testDir.toString().replaceAll("file:///", "/"));
    for (final FileSystemEntity entity in dir.listSync()) {
      if (entity is File && entity.path.endsWith("_test.dart")) {
        return entity.path;
      }
    }
    return null;
  }

  Future<Uint8List> _readGoldenBytes(Uri resolvedGolden) async {
    final File file = File.fromUri(resolvedGolden);
    if (!file.existsSync()) {
      throw FlutterError("Could not find golden: $resolvedGolden");
    }
    return Uint8List.fromList(await file.readAsBytes());
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {
    final Uri resolved = _testDir.resolve(golden.toString());
    final File goldenFile = File.fromUri(resolved);
    await goldenFile.parent.create(recursive: true);
    await goldenFile.writeAsBytes(imageBytes);
  }

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final Uri resolved = _testDir.resolve(golden.toString());

    final Uint8List goldenBytes = await _readGoldenBytes(resolved);

    // Fast path: identical PNG bytes
    if (listEquals(imageBytes, goldenBytes)) {
      return true;
    }

    final ComparisonResult result = await GoldenFileComparator.compareLists(imageBytes, goldenBytes);

    if (result.passed) {
      result.dispose();
      return true;
    }

    final double diff = result.diffPercent;
    final bool pass = diff <= toleranceFraction;

    if (!pass) {
      await generateFailureOutput(result, resolved, _testDir);

      final String tolerance = "${(toleranceFraction * 100).toStringAsFixed(2)}%";
      final String difference = "${(diff * 100).toStringAsFixed(3)}%";

      result.dispose();
      throw FlutterError(
        "Golden file differs by $difference (max is $tolerance)\n"
        "Test: file://${findTestFile()} \n"
        "Golden: ${resolved}1:1",
      );
    }

    result.dispose();
    return true;
  }
}
