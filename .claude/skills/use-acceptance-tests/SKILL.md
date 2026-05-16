# Skill: Writing User Acceptance Tests

This skill describes how to write UATs in this project. Tests use Flutter's `testWidgets` with a three-layer pattern:

- **Builders** — configure offline test data (fluent API, one builder per data domain)
- **Drivers** — encapsulate page interactions and assertions (Page Object Model)
- **Tests** — compose builders and drivers into BDD Given/When/Then scenarios

Before writing tests, read [`uat-framework.handoff.md`](uat-framework.handoff.md) if the framework is not yet set up.

---

## When to Use This Skill

- Writing a new UAT for a new page or flow
- Adding scenarios to an existing UAT file
- Writing access-control or visibility tests (`*_access_test.dart`)

For generating drivers and builders from scratch, use the `test-driver-generation` skill. For translating BDD acceptance criteria into test code, use the `bdd-ac-testing` skill.

---

## Step 1: Identify What to Test

Each test maps to a user-observable behaviour, not an implementation detail. Common categories:

| Category | Examples |
|---|---|
| Visibility | Element shown/hidden based on feature toggle, user type, or data state |
| Navigation | Tapping a button navigates to the correct page |
| Data display | Correct data is rendered on screen |
| Input validation | Invalid input shows an error and blocks progress |
| Happy path | Full user flow from start to success |
| Error handling | Service error shows feedback and preserves state |
| Feature toggles | Feature on/off changes app behaviour |
| Empty states | No data renders appropriate empty state messaging |
| Authentication | Step-up auth required before proceeding |

---

## Step 2: Choose or Create the Driver

Look for the driver in `test/user_acceptance_tests/<feature>/<page>/driver/<page>_driver.dart`.

If it doesn't exist, create it:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../_core/test_rig.dart';
import '../../../../_core/test_setup/driver/i_driver.dart';

class <PageName>Driver extends BaseDriver {
  // Private finder getters — one per UI element the tests need
  Finder get _submitButtonFinder => find.byKey(<PageName>Keys.submitButtonKey);

  const <PageName>Driver({
    required super.tester,
    super.builders,
    super.theme = ThemeMode.light,
    super.accessibilityMode = false,
    super.goldenTest = false,
  });

  // Launch the page
  Future openPage() async {
    await launchApp(tester: tester, builders: builders, theme: theme);
    await navigate(
      tester: tester,
      route: RouteLink.<pageName>(),
      expectToLandOn: <PageName>Page,
    );
  }

  // Interaction — always Future
  Future tapSubmitButton() async {
    await tapToNavigate(tester: tester, buttonFinder: _submitButtonFinder);
  }

  // Assertion — always void
  void assertSubmitButtonVisible({required bool visible}) {
    expect(_submitButtonFinder, visible ? findsOneWidget : findsNothing);
  }
}
```

Driver rules:
- Constructor is `const`.
- All `find.byKey(...)` calls are in private getter finders — never inline.
- Interaction methods are `Future` (async).
- Assertion methods are `void` (sync).
- Do NOT add route-stack assertions to feature drivers — use `AppDriver` for those.

---

## Step 3: Choose or Create Builders

Look in `test/_core/test_setup/builders/<domain>/`. Most domains already have a builder.

Common builders:

| Builder | Purpose |
|---|---|
| `AccountsBuilder` | Bank accounts, account lists, errors |
| `AuthBuilder` | User type (retail/business), auth scope |
| `CardsBuilder` | Debit/credit cards, card status |
| `FeatureToggleBuilder` | Enable/disable features by route |
| `LoansBuilder` | Loans and loan details |
| `TransfersBuilder` | Transfer recipients, IBAN lookup |
| `ProductsBuilder` | Product/account type metadata |

Create a new builder when the domain has no existing builder:

```dart
class <Name>Builder extends BaseBuilder {
  final List<Map<String, dynamic>> _items = [];
  Failure? _error;

  <Name>Builder item({int? id, String? name}) {
    final Map<String, dynamic> entry = json.decode(_itemTemplate) as Map<String, dynamic>;
    if (id != null) entry['id'] = id;
    if (name != null) entry['name'] = name;
    _items.add(entry);
    return this;
  }

  <Name>Builder error() {
    _error = const Failure.serverError(message: 'Server error');
    return this;
  }

  @override
  TestSetupConstructor build() => _<Name>Constructor(items: _items, error: _error);
}

class _<Name>Constructor extends TestSetupConstructor {
  final List<Map<String, dynamic>> items;
  final Failure? error;

  _<Name>Constructor({required this.items, this.error});

  @override
  Future<void> setup() async {
    final Offline<Name>Client client = getIt<I<Name>ClientProvider>().getClient() as Offline<Name>Client;
    client.itemsJson = json.encode(items);
    if (error != null) client.error = error;
  }

  @override
  Future<void> tearDown() async {
    final Offline<Name>Client client = getIt<I<Name>ClientProvider>().getClient() as Offline<Name>Client;
    client.itemsJson = null;
    client.error = null;
    super.tearDown();
  }
}

const String _itemTemplate = '{ "id": 1, "name": "Default" }';
```

---

## Step 4: Write the Test File

**File location:** `test/user_acceptance_tests/<feature>/<page>/<page>_test.dart`

Access-control / visibility scenarios go in a separate file: `<page>_access_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';

import '../../../_core/test_rig.dart';
import '../../../_core/test_setup/builders/<domain>/<name>_builder.dart';
import '../../../_core/test_setup/builders/feature_toggle/feature_toggle_builder.dart';
import '../../../_core/test_setup/driver/app_driver.dart';
import 'driver/<page>_driver.dart';

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("<Feature name or user story>", () {
    testWidgets("<Concise scenario title>", (WidgetTester tester) async {
      // Given <precondition>
      final AppDriver appDriver = AppDriver(tester: tester);
      final <Page>Driver driver = <Page>Driver(
        tester: tester,
        builders: [
          <Name>Builder().<config>(),
          FeatureToggleBuilder().on(NamedRoute.<feature>()),
        ],
      );

      // When <action>
      await driver.openPage();
      await driver.<interaction>();

      // Then <expected result>
      driver.<assertion>();
      appDriver.assertIsOnPage(NamedRoute.<expectedPage>());
    });
  });
}
```

### Declaration order inside a test

1. `AppDriver` first (if used)
2. Auxiliary feature drivers (if the flow crosses multiple pages)
3. `driver` — the launching driver — always last, always named `driver`

Only `driver` receives `builders`. Auxiliary drivers receive only `tester`.

---

## Step 5: Structural Checklist

Before marking a test complete, verify:

- [ ] `tearDown(() async { await closeApp(); })` is at the top of `main()`
- [ ] Every `testWidgets` body has `// Given`, `// When`, and `// Then` comments
- [ ] Test file never calls `tester.*`, `find.*`, or `expect(...)` directly
- [ ] Navigation assertions use `AppDriver.assertIsOnPage(...)`, not feature driver methods
- [ ] `driver` is the variable name for the launching driver
- [ ] Only `driver` (not auxiliary drivers) receives `builders`
- [ ] All async driver calls have `await`
- [ ] Builder `tearDown()` resets all written properties and calls `super.tearDown()`
- [ ] Test compiles: `flutter analyze test/user_acceptance_tests/<feature>/<page>/`
- [ ] Test passes: `flutter test test/user_acceptance_tests/<feature>/<page>/`

---

## Step 6: Mid-Test State Changes

When a scenario requires the data to change after the page loads (e.g. simulating a server error on refresh):

```dart
// Given offers are loaded successfully
await driver.openPage();
driver.assertOffersVisible();

// When the offers service returns an error on refresh
await AppDriver(tester: tester).rerunWithBuilders([
  OffersBuilder().error(),
]);
await AppDriver(tester: tester).pullToRefresh(key: OffersPage.pullToRefreshKey);

// Then an error banner is shown
driver.assertErrorBannerVisible(visible: true);
```

---

## Step 7: Multi-Page Flows

When a scenario spans multiple pages, instantiate additional drivers (without builders) after navigation:

```dart
// Given I am on the transfer recipients page
await driver.openPage();

// When I start a new transfer and fill in the amount
await driver.tapTransferToRecipient();

final TransferAmountDriver amountDriver = TransferAmountDriver(tester: tester);
await amountDriver.enterAmount('500');
await amountDriver.tapContinue();

// Then I am on the confirmation page
appDriver.assertIsOnPage(NamedRoute.transferConfirmation());
```

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| `find.byKey(...)` inline in a driver method | Move to a private getter finder |
| `expect(...)` in a `*_test.dart` file | Move assertion into a driver method |
| `tester.pumpAndSettle()` in a test file | Move pumping into the driver |
| Missing `await` on a Future driver call | Add `await` — without it the interaction silently skips |
| No `tearDown` with `closeApp()` | Add it — builder state leaks into subsequent tests |
| Builder `tearDown` not resetting a property | Always reset every property written in `setup()` |
| Calling `super.tearDown()` before resetting properties | Call resets first, then `super.tearDown()` |
| Naming the launch driver `pageDriver`, `accountsDriver`, etc. | It must be `driver` |
| Asserting route via a feature driver method | Use `AppDriver.assertIsOnPage(NamedRoute.x())` |
