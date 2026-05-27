import "package:flutter_test/flutter_test.dart";

/// Base class for all feature drivers.
///
/// Provides a shared [WidgetTester] reference and a common settle helper.
/// Feature drivers extend this class and never interact with [tester] directly
/// inside test files — all finders, assertions, and interactions live on the
/// driver.
abstract class BaseDriver {
  final WidgetTester tester;

  BaseDriver({required this.tester});

  Future<void> settle() async {
    await tester.pumpAndSettle();
  }
}
