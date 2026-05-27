import "package:flutter_test/flutter_test.dart";
import "package:la/presentation/core/app.dart";

import "base_driver.dart";

/// Cross-cutting driver for navigation and page-existence assertions.
///
/// Use this from every UAT test that needs to assert which page is visible or
/// assert that navigation has occurred.  Feature-specific interactions live on
/// their own drivers.
class AppDriver extends BaseDriver {
  AppDriver({required super.tester});

  Future<void> assertIsOnPage(PageName page) async {
    // scaffold — assert that [page] is the current route
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertPageExists(PageName page) async {
    // scaffold — assert that [page] exists somewhere in the tree
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> assertPageDoesNotExist(PageName page) async {
    // scaffold — assert that [page] is absent from the tree
    markTestSkipped("scaffold — implement after layers complete");
  }

  Future<void> pop() async {
    // scaffold — trigger back navigation
    markTestSkipped("scaffold — implement after layers complete");
  }
}
