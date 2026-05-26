import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'i_driver.dart';

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

  Future<void> tap(Key key) async {
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }
}
