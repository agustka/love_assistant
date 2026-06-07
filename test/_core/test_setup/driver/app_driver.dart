import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:la/presentation/core/app.dart";

import "i_driver.dart";

/// Cross-cutting driver for assertions and interactions that are not tied to a
/// single feature (presence of a widget on the current screen, generic taps).
///
/// Feature-specific finders and assertions belong on the feature driver.
class AppDriver extends BaseDriver {
  const AppDriver({required super.tester});

  void assertWidgetExists(Key key) {
    expect(find.byKey(key), findsOneWidget);
  }

  void assertWidgetDoesNotExist(Key key) {
    expect(find.byKey(key), findsNothing);
  }

  void assertIsOnPage(PageName pageName) {
    expect(AppPages.navigationObserver.currentPage, AppPages.descriptorForName(pageName));
  }

  void assertPageExists(PageName pageName) {
    assertIsOnPage(pageName);
  }

  void assertPageDoesNotExist(PageName pageName) {
    expect(AppPages.navigationObserver.stack, isNot(contains(AppPages.descriptorForName(pageName))));
  }

  Future<void> tap(Key key) async {
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  Future<void> popRoute() async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }
}
