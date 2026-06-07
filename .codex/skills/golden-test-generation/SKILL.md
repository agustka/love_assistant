---
name: golden-test-generation
description: >-
  Generate page-level golden (screenshot) tests for visual regression.
  Covers light mode, dark mode, accessibility mode, landscape mode,
  and dark landscape mode using existing drivers and builders.
tools: []
---

## Purpose

Use this skill to generate page-level golden tests that capture pixel-perfect screenshots of pages in multiple visual modes. These tests catch visual regressions across theme changes, accessibility scaling, and orientation changes.

> **Project status:** This project does not yet have a UAT driver/builder framework. The driver-based golden setup below is aspirational — it is what should be built once that framework lands. For now, write goldens against the page widget directly: wrap it in a `MaterialApp` with the project theme and pump.

Golden tests differ from UI component goldens (which test individual atoms/molecules/organisms in isolation).

---

## Input

- UI handoff (agents/handoff/ui.handoff.md) — pages and their visual states
- Once a UAT framework exists: any existing page drivers/builders. Until then, instantiate the page widget directly inside a `MaterialApp` with the project theme.

---

## File Location

```
test/presentation/<feature>/<page>/
├── <page>_test.dart              ← golden test file
└── ui_modes_test/                ← generated golden images (auto-created by flutter)
    ├── light_mode.png
    ├── dark_mode.png
    ├── accessibility_mode.png
    ├── landscape_mode.png
    └── dark_landscape_mode.png
```

Golden tests live under `test/presentation/`, **not** under `test/user_acceptance_tests/`. They import drivers from the UAT directory.

---

## Canonical Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../../../_core/test_rig.dart';
import '../../../../_core/test_setup/builders/<domain>/<builder>_builder.dart';
import '../../../../user_acceptance_tests/<feature>/<page>/driver/<page>_driver.dart';

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("<Page name>", () {
    testGoldens("<Page name> light mode", (WidgetTester tester) async {
      await _setup(tester);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile("ui_modes_test/light_mode.png"),
      );
    });

    testGoldens("<Page name> dark mode", (WidgetTester tester) async {
      await _setup(tester, theme: ThemeMode.dark);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile("ui_modes_test/dark_mode.png"),
      );
    });

    testGoldens("<Page name> accessibility mode", (WidgetTester tester) async {
      await _setup(tester, accessibilityMode: true);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile("ui_modes_test/accessibility_mode.png"),
      );
    });

    testGoldens("<Page name> landscape mode", (WidgetTester tester) async {
      await _setup(tester, landscape: true);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile("ui_modes_test/landscape_mode.png"),
      );
    });

    testGoldens("<Page name> dark landscape mode", (WidgetTester tester) async {
      await _setup(tester, landscape: true, theme: ThemeMode.dark);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile("ui_modes_test/dark_landscape_mode.png"),
      );
    });
  });
}

Future<void> _setup(
  WidgetTester tester, {
  ThemeMode theme = ThemeMode.light,
  bool landscape = false,
  bool accessibilityMode = false,
}) async {
  final <Page>Driver driver = <Page>Driver(
    tester: tester,
    goldenTest: true,
    theme: theme,
    landscape: landscape,
    accessibilityMode: accessibilityMode,
    builders: [
      // Builders that put the page in its representative state
      <Builder>().<config>(),
    ],
  );
  await driver.openPage();
  // Optional: navigate or interact to reach the desired visual state
}
```

---

## Rules

### Required Visual Modes

Every page golden test must include **all five** modes:

| Mode | Driver flags | Golden file name |
|------|-------------|-----------------|
| Light | (defaults) | `ui_modes_test/light_mode.png` |
| Dark | `theme: ThemeMode.dark` | `ui_modes_test/dark_mode.png` |
| Accessibility | `accessibilityMode: true` | `ui_modes_test/accessibility_mode.png` |
| Landscape | `landscape: true` | `ui_modes_test/landscape_mode.png` |
| Dark Landscape | `landscape: true, theme: ThemeMode.dark` | `ui_modes_test/dark_landscape_mode.png` |

### testGoldens

- Use `testGoldens` from `golden_toolkit` (not `testWidgets`)
- `testGoldens` automatically tags the test with `golden` for selective test runs

### Golden Capture

Always capture the full `MaterialApp`:

```dart
await expectLater(
  find.byType(MaterialApp),
  matchesGoldenFile("ui_modes_test/<mode>.png"),
);
```

Rules:
- Always use `find.byType(MaterialApp)` as the subject
- Golden file path is relative to the test file location
- All golden images go under the `ui_modes_test/` subdirectory
- File names follow the exact naming convention above

### Setup Function

Extract a shared `_setup` function to avoid duplication across modes:

```dart
Future<void> _setup(
  WidgetTester tester, {
  ThemeMode theme = ThemeMode.light,
  bool landscape = false,
  bool accessibilityMode = false,
}) async {
  final <Page>Driver driver = <Page>Driver(
    tester: tester,
    goldenTest: true,        // Always true for golden tests
    theme: theme,
    landscape: landscape,
    accessibilityMode: accessibilityMode,
    builders: [ ... ],
  );
  await driver.openPage();
}
```

Rules:
- `goldenTest: true` is always set — this adjusts the view size and DPR for golden capture
- The `_setup` function accepts `theme`, `landscape`, and `accessibilityMode` parameters
- Builders are shared across all modes — they set up the data, not the visual mode
- If the page has multiple visual states worth capturing (e.g. empty, loaded, error), create separate setup helpers or multiple golden groups

### Driver Reuse

Golden tests import drivers from the UAT test tree:

```dart
import '../../../../user_acceptance_tests/<feature>/<page>/driver/<page>_driver.dart';
```

- Do NOT create separate drivers for golden tests
- The same driver works for both UATs and golden tests
- The `goldenTest: true` flag on the driver adjusts sizing

### Landscape Overflow

Some pages may have RenderFlex overflow in landscape mode. Suppress these known layout issues:

```dart
void suppressOverflowErrors() {
  final FlutterExceptionHandler? originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final Object exception = details.exception;
    if (exception is FlutterError) {
      final bool isOverflowError = exception.diagnostics.any(
        (DiagnosticsNode e) => e.value.toString().contains("A RenderFlex overflowed by"),
      );
      if (isOverflowError) return;
    }
    originalOnError?.call(details);
  };
  addTearDown(() => FlutterError.onError = originalOnError);
}
```

Use it before landscape golden tests that overflow:

```dart
testGoldens("Landscape mode", (WidgetTester tester) async {
  suppressOverflowErrors();
  await _setup(tester, landscape: true);
  // ...
});
```

### Multi-State Goldens

When a page has multiple important visual states (e.g. with a notification, error state, empty state), add additional golden captures:

```dart
testGoldens("Edit mode with notification", (WidgetTester tester) async {
  final <Page>Driver driver = <Page>Driver(
    tester: tester,
    goldenTest: true,
    builders: [
      <Builder>().withNotification(),
    ],
  );
  await driver.openPage(editMode: true);
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile("ui_modes_test/notification_mode.png"),
  );
});
```

### Interaction Before Capture

If the page needs user interaction to reach the desired visual state (e.g. filling form fields, scrolling), do it between `openPage()` and `expectLater`:

```dart
Future<void> _setup(WidgetTester tester, { ... }) async {
  // ...
  await driver.openPage();
  await driver.enterName("Johan Müller");
  await driver.enterEmail("some@email.com");
  await driver.tapSubmit();
}
```

### Test Configuration

The project uses:
- `golden_toolkit` package for `testGoldens` and `loadAppFonts`
- `GoldenToleranceComparator` with 0.05% tolerance (configured in `flutter_test_config.dart`)
- `dart_test.yaml` tags golden tests for selective CI runs

---

## Generating / Updating Golden Images

To generate or update golden images:

```bash
flutter test --update-goldens test/presentation/<feature>/<page>/
```

To run golden tests for comparison:

```bash
flutter test --tags golden test/presentation/<feature>/<page>/
```

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Using `testWidgets` instead of `testGoldens` | Bypasses golden tagging and toolkit config |
| Capturing `find.byType(<PageWidget>)` | Always capture `MaterialApp` for full-screen including app bar, nav, etc. |
| Skipping landscape mode | Landscape is now required for all page goldens |
| Skipping dark landscape mode | Both landscape variants must be covered |
| Creating separate drivers for goldens | Reuse UAT drivers with `goldenTest: true` |
| Putting golden tests in `user_acceptance_tests/` | Golden tests live under `test/presentation/` |
| Hardcoding view sizes in golden tests | The driver handles sizing via `goldenTest: true` flag |
| Different builders per visual mode | All modes share the same data — only theme/orientation changes |

---

## Output

For each page, produce:

1. **Golden test file**: `test/presentation/<feature>/<page>/<page>_test.dart`
2. **Golden images**: generated by running `flutter test --update-goldens`

After generating the test file, run:

```bash
flutter test --update-goldens test/presentation/<feature>/<page>/<page>_test.dart
```

Then verify the generated images visually before committing.

 