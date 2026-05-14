---
name: test-driver-generation
description: >-
  Generate test drivers and builders for user acceptance tests.
  Drivers encapsulate page interactions and assertions.
  Builders configure offline test data via fluent APIs.
tools: []
---

## Purpose

Use this skill to generate test drivers and test data builders for user acceptance tests (UATs). Together, drivers and builders form the test infrastructure that enables BDD-style widget tests.

- **Drivers** encapsulate all interactions and assertions for a specific page or flow. They abstract away widget finder details and expose a readable, intent-based API.
- **Builders** configure the offline test data that backs each scenario. They provide a fluent, chainable API to construct the exact data shape a test requires.

---

## Input

- BDD scenarios (specs/bdd.md)
- UI handoff (handoff/ui.handoff.md) — pages, keys, widgets used
- Application handoff (handoff/application.handoff.md) — cubits and their states
- Infrastructure handoff (handoff/infrastructure.handoff.md) — offline clients, services, models

---

## Architecture Overview

```
test/
├── _core/
│   └── test_setup/
│       ├── test_setup.dart           ← TestSetupConstructor base class
│       ├── driver/
│       │   ├── i_driver.dart         ← BaseDriver (base class for all drivers)
│       │   └── app_driver.dart       ← AppDriver (shared app-level driver)
│       └── builders/
│           ├── base_builder.dart     ← BaseBuilder (base class for all builders)
│           └── <domain>/
│               └── <name>_builder.dart
└── user_acceptance_tests/
    └── <feature>/
        └── <page>/
            ├── driver/
            │   └── <page>_driver.dart
            └── <page>_test.dart
```

---

## Driver Generation

### File Location

```
test/user_acceptance_tests/<feature>/<page>/driver/<page>_driver.dart
```

### Base Class

All drivers extend `BaseDriver` from `test/_core/test_setup/driver/i_driver.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../_core/test_rig.dart';
import '../../../../_core/test_setup/driver/i_driver.dart';

class <PageName>Driver extends BaseDriver {
  const <PageName>Driver({
    required super.tester,
    super.builders,
    super.theme = ThemeMode.light,
    super.accessibilityMode = false,
    super.goldenTest = false,
  });
}
```

### Constructor

| Parameter | Type | Required | Default | Purpose |
|---|---|---|---|---|
| `tester` | `WidgetTester` | Yes | — | Flutter test widget tester |
| `builders` | `List<BaseBuilder>` | No | `const []` | Data builders for test scenarios |
| `theme` | `ThemeMode` | No | `ThemeMode.light` | Theme mode for the test |
| `accessibilityMode` | `bool` | No | `false` | Accessibility testing mode |
| `goldenTest` | `bool` | No | `false` | Golden image testing mode |

The constructor must be `const`.

### Finders

Declare all widget finders as private getters at the top of the class. Use widget keys from the page's keys class or from widget constructors.

```dart
Finder get _submitButtonFinder => find.byKey(<PageName>Keys.submitButtonKey);
Finder get _titleFinder => find.byKey(<PageName>Keys.titleKey);
Finder get _errorMessageFinder => find.byKey(<PageName>Keys.errorMessageKey);
```

Rules:
- Finders are private (`_` prefix)
- Finders use `find.byKey(...)` referencing static keys defined on page/widget classes
- Finders use `find.byType(...)` only when key-based lookup is not possible
- Finders are getters, not fields
- Every `find.byKey(...)` used by the driver must live in a finder getter/helper (including parameterized helpers)
- Interaction/assertion methods must consume finder getters/helpers and must not declare inline `find.byKey(...)`

### openPage Method

Every driver must have an `openPage` method that launches the app and navigates to the page under test.

```dart
Future openPage() async {
  await launchApp(
    tester: tester,
    builders: builders,
    theme: theme,
    accessibilityMode: accessibilityMode,
    goldenTest: goldenTest,
  );

  await navigate(
    tester: tester,
    route: RouteLink.<pageName>(),
    expectToLandOn: <PageName>Page,
  );
}
```

- `launchApp` and `navigate` are imported from `test/_core/test_rig.dart`
- Some drivers open via tab bar navigation instead of direct routing — use `tapToNavigate` in that case

### Interaction Methods

Expose one method per user interaction described in BDD scenarios. Methods are `Future` (async).

```dart
Finder get _textFieldFinder => find.byKey(<PageName>Keys.textFieldKey);

Future tapSubmitButton() async {
  await tapToNavigate(tester: tester, buttonFinder: _submitButtonFinder);
}

Future enterText(String text) async {
  expect(_textFieldFinder, findsOneWidget);
  await tester.enterText(_textFieldFinder, text);
  await tester.pump(const Duration(milliseconds: 250));
}
```

Rules:
- Use `tapToNavigate(tester:, buttonFinder:, expectToLandOn:)` for taps that trigger navigation
- Use `tester.tap(finder)` + `tester.pumpAndSettle()` for non-navigation taps
- Use `tester.enterText(finder, text)` + `tester.pump(...)` for text entry
- Use `scroll(tester:, seeking:, scrollView:, direction:)` for scrolling
- Keep raw `tester.*` usage inside drivers (or `AppDriver`) only; acceptance test files must interact through driver APIs
- For dynamic lookups, add parameterized finder helpers (for example `Finder _itemFinder(int index) => find.byKey(...)`) instead of inline `find.byKey(...)` in methods

### Assertion Methods

Expose one method per assertion needed by BDD scenarios. Assertions are `void` (synchronous).

```dart
void assertTitleVisible({required bool visible}) {
  expect(_titleFinder, visible ? findsOneWidget : findsNothing);
}

void assertSubmitButtonEnabled({required bool enabled}) {
  final IsbMainButtonMolecule button = tester.widget(_submitButtonFinder);
  expect(button.enabled, enabled);
}

void assertErrorMessageShown({required String message}) {
  expect(_errorMessageFinder, findsOneWidget);
  final IsbTextAtom text = tester.widget(_errorMessageFinder);
  expect(text.data, message);
}

void assertItemCount({required int count}) {
  final List<IsbListTileMolecule> items = List<IsbListTileMolecule>.from(
    tester.widgetList(find.byType(IsbListTileMolecule)).toList(),
  );
  expect(items.length, count);
}
```

Rules:
- Assertion method names start with `assert`
- Use `expect(...)` from `flutter_test`
- Use `tester.widget<T>(finder)` to get a widget instance and inspect its properties
- Use `tester.widgetList(finder)` for lists of widgets
- Use `findsOneWidget`, `findsNothing`, `findsOne`, `findsAtLeastNWidgets(n)` matchers
- Visibility checks use `findsOneWidget` / `findsNothing` pattern with a `visible` parameter
- Assertion methods should cover page-specific content/state, not global route-stack assertions that already belong to `AppDriver`

### Composing Drivers

A driver can instantiate other drivers for cross-page flows:

```dart
Future performFullFlow() async {
  await openPage();
  await tapSubmitButton();

  final OtherPageDriver otherDriver = OtherPageDriver(tester: tester);
  await otherDriver.enterDetails("value");
  await otherDriver.tapConfirm();
}
```

### Using AppDriver

For shared app-level interactions (dialogs, navigation, toasts), instantiate `AppDriver`:

```dart
final AppDriver appDriver = AppDriver(tester: tester);
appDriver.assertIsOnPage(NamedRoute.<pageName>());
```

Rules:
- Do not generate feature-driver wrapper methods whose only job is to call `AppDriver.assertIsOnPage`, `assertPageExists`, or `assertPageDoesNotExist`
- Methods like `assertIsOnAmountPage()`, `assertTransferSuccessPageVisible()`, or `assertAmountPageDoesNotExist()` must stay out of feature drivers when the global `AppDriver` API already covers the assertion
- Use `AppDriver` directly from the test when asserting navigation/page existence; keep feature-driver assertions focused on widgets and state within that page

---

## Builder Generation

### File Location

```
test/_core/test_setup/builders/<domain>/<name>_builder.dart
```

### Base Class

All builders extend `BaseBuilder` from `test/_core/test_setup/builders/base_builder.dart`.

```dart
import '../../test_setup.dart';
import '../base_builder.dart';

class <Name>Builder extends BaseBuilder {
  // Private mutable state for building test data
  final List<Map<String, dynamic>> _items = [];

  <Name>Builder();

  @override
  TestSetupConstructor build() {
    return _<Name>BuilderConstructor(
      itemsJson: json.encode(_items),
    );
  }
}
```

### Fluent API

Builders expose chainable methods that configure the test data. Each method returns the builder instance (`this`).

```dart
<Name>Builder item({String? name, int? id}) {
  final Map<String, dynamic> entry = json.decode(_defaultItemJson) as Map<String, dynamic>;
  if (name != null) {
    entry["name"] = name;
  }
  if (id != null) {
    entry["id"] = id;
  }
  _items.add(entry);
  return this;
}

<Name>Builder error() {
  _failure = const Failure.serverError(message: "Server error");
  return this;
}

<Name>Builder reset() {
  _reset = true;
  return this;
}
```

Rules:
- All configuration methods return the builder itself for chaining
- Use optional named parameters with defaults from JSON templates
- Keep JSON templates as `const String` at the bottom of the file
- Parse JSON templates with `json.decode(...)` and modify as needed

### TestSetupConstructor (Inner Class)

Each builder has a private `TestSetupConstructor` implementation that applies the configuration to the offline clients:

```dart
class _<Name>BuilderConstructor extends TestSetupConstructor {
  final String itemsJson;

  _<Name>BuilderConstructor({required this.itemsJson});

  @override
  Future<void> setup() async {
    final OfflineClient client = getIt<IClientProvider>().getClient() as OfflineClient;
    client.itemsJson = itemsJson;
  }

  @override
  Future<void> tearDown() async {
    final OfflineClient client = getIt<IClientProvider>().getClient() as OfflineClient;
    client.itemsJson = null;
    super.tearDown();
  }
}
```

Rules:
- The constructor class is private (prefixed with `_`)
- `setup()` writes test data into offline client/adapter properties
- `tearDown()` resets all modified properties to `null` or defaults
- Always call `super.tearDown()` in tearDown
- Use `getIt<Interface>() as OfflineImplementation` pattern to access offline clients

### JSON Templates

Place default JSON response shapes as `const String` at the bottom of the file:

```dart
const String _defaultItemJson = """
{
  "id": 1,
  "name": "Default Item",
  "status": "active"
}
""";

const String _itemsWrapperJson = """
{
  "data": {
    "items": []
  }
}
""";
```

Rules:
- Use triple-quoted strings for readability
- One template per response shape
- Templates represent a single entry or a wrapper — never combine both
- Names are prefixed with `_` (private to the file)

---

## Test File Structure

The test file ties drivers and builders together:

```dart
import "package:flutter_test/flutter_test.dart";

import "../../../_core/test_rig.dart";
import "driver/<page>_driver.dart";

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("<Feature description>", () {
    testWidgets("<BDD scenario name>", (WidgetTester tester) async {
      // Given <precondition from BDD>
      final AppDriver appDriver = AppDriver(tester: tester);
      final <AuxiliaryPage>Driver auxiliaryDriver = <AuxiliaryPage>Driver(tester: tester);
      final <Page>Driver driver = <Page>Driver(
        tester: tester,
        builders: [
          <DomainBuilder>().<config1>().<config2>(),
        ],
      );

      // When <action from BDD>
      await driver.openPage();
      await driver.tapSomeButton();

      // Then <assertion from BDD>
      driver.assertExpectedState();
    });
  });
}
```

Rules:
- Always call `closeApp()` in `tearDown`
- Comment BDD Given/When/Then steps inline
- Name the launching page driver `driver` (the one that calls `openPage()` first)
- Pass builders only to the launching `driver`; auxiliary drivers must not receive `builders`
- Declare drivers in order: `AppDriver` first, auxiliary drivers next, `driver` last
- The test file must not call `tester.*` directly; if extra pumping or interaction is needed, expose a driver or `AppDriver` method instead
- Keep test titles concise while preserving BDD intent; avoid long verbatim scenario text
- Prefer title length that keeps `testWidgets("<title>", (WidgetTester tester) async {` on one line
- Pass builders that set up the exact scenario data
- Drivers are instantiated per test (no shared driver instances)
- Group tests by feature or flow
- Keep lines formatter-friendly and at most 120 characters

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Exposing raw finders as public | Breaks encapsulation — tests should use driver methods |
| Hardcoding widget text for finding | Use keys instead — text changes with localization |
| Business logic in drivers | Drivers are interaction wrappers, not logic containers |
| Creating builders that don't tearDown | Causes test pollution across scenarios |
| Skipping `const` on driver constructors | Unnecessary object allocation |
| Putting test data JSON in the test file | JSON belongs in builders as private const templates |
| Mocking domain objects in drivers | Drivers work with the real app; builders configure offline data |
| Using `find.text()` for assertions about visibility | Use `find.byKey()` — text may duplicate across widgets |
| Giving builders to non-launch drivers in test files | Builders configure initial launch state only |
| Naming the launch driver `amountDriver`, `pageDriver`, etc. | Launch driver must be named `driver` |
| Generating feature-driver methods that only proxy `AppDriver.assertIsOnPage()` / `assertPageExists()` / `assertPageDoesNotExist()` | Route assertions are global app concerns and should use `AppDriver` directly |
| Letting tests reach for `tester.pumpAndSettle()` or other `tester.*` calls because the driver API is incomplete | Add the missing driver/AppDriver method instead of leaking widget-tester details into tests |
| Writing `find.byKey(...)` inline inside driver interaction/assertion methods | Define a finder getter/helper and reuse it so locator definitions stay centralized |

---

## Output

For each page under test, produce:

1. **Driver**: `test/user_acceptance_tests/<feature>/<page>/driver/<page>_driver.dart`
2. **Builder** (if new data setup is needed): `test/_core/test_setup/builders/<domain>/<name>_builder.dart`
3. **Test file**: `test/user_acceptance_tests/<feature>/<page>/<page>_test.dart`

After generating, verify compilation with:

```bash
flutter analyze test/user_acceptance_tests/<feature>/<page>/
```

