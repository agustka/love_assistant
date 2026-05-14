 ---
name: bdd-ac-testing
description: >-
  Write BDD-driven user acceptance tests from acceptance criteria.
  Translates Given/When/Then scenarios into widget tests using
  drivers for interactions and builders for test data.
tools: []
---

## Purpose

Use this skill to write user acceptance test files from BDD acceptance criteria. Each acceptance criterion becomes one `testWidgets` call. The test body follows the Given/When/Then structure using drivers (for interactions and assertions) and builders (for test data configuration).

This skill assumes drivers and builders already exist (see `test-driver-generation`). It focuses on **composing** them into test scenarios.

---

## Input

- BDD acceptance criteria (specs/bdd.md or equivalent)
- Available drivers (from handoff/testing artifacts or existing code)
- Available builders (from handoff/testing artifacts or existing code)

---

## File Location

```
test/user_acceptance_tests/<feature>/<page>/<page>_test.dart
```

One test file per page or flow. Multiple test files per page are acceptable when scenarios fall into distinct groups (e.g. `<page>_test.dart`, `<page>_error_test.dart`, `<page>_navigation_test.dart`).

---

## Canonical Template

```dart
import "package:flutter_test/flutter_test.dart";

import "../../../_core/test_rig.dart";
import "../../../_core/test_setup/builders/<domain>/<builder>_builder.dart";
import "../../../_core/test_setup/driver/app_driver.dart";
import "driver/<page>_driver.dart";

void main() {
  tearDown(() async {
    await closeApp();
  });

  group("<Feature or scenario group>", () {
    testWidgets("<Acceptance criterion title>", (WidgetTester tester) async {
      // Given <precondition>
      final AppDriver appDriver = AppDriver(tester: tester);
      final <OtherPage>Driver <otherPage>Driver = <OtherPage>Driver(tester: tester);
      final <Page>Driver driver = <Page>Driver(tester: tester, builders: [<Builder>().<config>()]);

      // When <action>
      await driver.openPage();
      await driver.<interaction>();

      // Then <expected outcome>
      driver.<assertion>();
    });
  });
}
```

---

## Rules

### File Structure

| Rule | Detail |
|------|--------|
| `tearDown` | Always call `await closeApp()` in `tearDown` — cleans up builders, resets state |
| `group` | Group related scenarios under a descriptive name matching the feature or user story |
| `testWidgets` | One `testWidgets` per acceptance criterion — test name is a concise AC paraphrase that preserves intent |
| Imports | Import from `_core/test_rig.dart`, builders, drivers, `app_driver.dart` as needed |
| No direct widget imports | Tests must not import page widgets or use `find.*` directly — use driver methods |
| No raw tester calls | Test files must not call `tester.*` directly; only pass `tester` into `AppDriver`/driver constructors |
| No low-level assertions in test files | Test files must not use `expect(...)`, `tester.widget(...)`, or any direct widget inspection; assertions must be exposed on drivers/AppDriver |

### Given / When / Then Comments

Prefer concise test code with descriptive driver methods and test names.

Given/When/Then comments are optional by default and should be added only when they improve readability for longer multi-phase scenarios:

```dart
testWidgets("User sees error when amount is too low", (WidgetTester tester) async {
  // Given I have a loan with a balance of 5000
  final AppDriver appDriver = AppDriver(tester: tester);
  final LoanPrepaymentDriver driver = LoanPrepaymentDriver(
    tester: tester,
    builders: [
      LoansBuilder().loan(id: 1).balance(5000),
      FeatureToggleBuilder().loans(enableAll: true),
    ],
  );

  // When I enter a repayment amount below the minimum
  await driver.openPage(loanId: 1);
  await driver.enterRepaymentAmount("500");

  // Then I see a validation error
  await driver.assertErrorMessageShown(PrepaymentContinueStatus.loanRepaymentMinimumNotMet);

  // And I cannot proceed
  await driver.payNow();
  appDriver.assertIsOnPage(NamedRoute.loanPrepayment());
});
```

Rules:
- Use comments sparingly; do not repeat what method names already communicate
- If used, `// Given`, `// When`, `// Then`, and `// And` should stay concise and aligned to AC wording

### Driver Instantiation

Drivers are instantiated in the **Given** section. The launching page driver is always named `driver`:

```dart
// Given the foreign transfers feature toggle is enabled
// And known foreign recipients exist
final AppDriver appDriver = AppDriver(tester: tester);
final TransferSuccessDriver successDriver = TransferSuccessDriver(tester: tester);
final TransferRecipientsDriver driver = TransferRecipientsDriver(
  tester: tester,
  builders: [
    KnownRecipientsBuilder().recipient().foreignRecipientListItem(id: 123),
    FeatureToggleBuilder().on(NamedRoute.foreignTransfers()),
  ],
);
```

Rules:
- The launching page driver must be named exactly `driver`
- `tester` is always the first parameter — it comes from the `testWidgets` callback and is only forwarded into `AppDriver`/driver constructors inside the test file
- `builders` configures the exact test data for this scenario and is passed only to `driver`
- Multiple builders are composed as a list — one per data domain
- Builder methods are chained fluently to describe the scenario data
- Driver declaration order is: `AppDriver` first, auxiliary feature drivers next, `driver` last
- Keep lines formatter-friendly and at most 120 characters

### Using AppDriver

Instantiate `AppDriver` for shared app-level assertions (dialogs, navigation, toasts, page existence):

```dart
final AppDriver appDriver = AppDriver(tester: tester);

// Assert navigation
appDriver.assertIsOnPage(NamedRoute.transferAmount());
appDriver.assertPageDoesNotExist(NamedRoute.alertDialog());

// Dialog interaction
await appDriver.tapFirstDialogButton();
await appDriver.tapSecondDialogButton();

// Toast assertion
appDriver.assertToastWasShown(text: S.current.generic_success);

// Rebuild with new builders (mid-test data change)
await appDriver.rerunWithBuilders([
  OffersBuilder().offersError(),
]);
```

Rules:
- Use `AppDriver` for route-stack/page-existence assertions such as `assertIsOnPage`, `assertPageExists`, and `assertPageDoesNotExist`
- Do not add or use feature-driver wrappers like `assertIsOnTransferAmountPage()` when `AppDriver` already expresses the assertion
- If a scenario seems to need a raw `tester.*` call in the test file, move that behavior into a driver or `AppDriver` method first

### Mid-Test Data Changes

When a scenario requires data to change during the test (e.g. simulating a server error after initial load), use `AppDriver.rerunWithBuilders`:

```dart
// Given offers are loaded
await driver.openPage();
driver.assertOffersListShown();

// When a service error occurs on refresh
await AppDriver(tester: tester).rerunWithBuilders([
  OffersBuilder().offersError(),
]);
await AppDriver(tester: tester).pullToRefresh(key: OffersOverviewPage.offersPullToRefreshKey);

// Then cached data is still shown
driver.assertOffersListShown();
driver.assertStaleOffersBannerVisible(visible: true);
```

### Composing Drivers

When a flow spans multiple pages, instantiate additional drivers as needed:

```dart
// Given I am on the recipients page
final AppDriver appDriver = AppDriver(tester: tester);
await driver.openPage();
await driver.tapTransferToNewRecipientButton();

// When I fill in the new recipient form
final TransfersNewRecipientDriver newRecipientDriver = TransfersNewRecipientDriver(tester: tester);
await newRecipientDriver.enterKennitala("1108814879");
await newRecipientDriver.enterAccountNumber("0512-26-110881");
await newRecipientDriver.tapContinue();

// And I enter the amount and submit
final TransferAmountDriver amountDriver = TransferAmountDriver(tester: tester);
await amountDriver.enterAmountAndSubmit(amount: "1", shouldOpenPageFirst: false);

// Then I see the success page
appDriver.assertIsOnPage(NamedRoute.transferSuccess());
```

Rules:
- Each additional driver is instantiated without builders (the app is already running)
- The `tester` is shared across all drivers
- Only the launching `driver` receives builders (the one that calls `openPage` first)
- Cross-page route assertions still belong to `AppDriver`, not to feature-driver convenience methods

### Scenario Categories

Structure tests into these common categories:

| Category | What to test | Example |
|---|---|---|
| **Visibility** | Elements shown/hidden based on state | `assertFabVisible(visible: true)` |
| **Navigation** | User taps lead to correct pages | `appDriver.assertIsOnPage(NamedRoute.x())` |
| **Data display** | Correct data rendered on screen | `assertRecipientsAreSortedByDate()` |
| **Input validation** | Invalid input shows errors, blocks progress | `assertErrorMessageShown(...)` |
| **Success flows** | Happy path from start to completion | Multi-step with composed drivers |
| **Error handling** | Service errors show feedback, preserve state | `rerunWithBuilders` + error builder |
| **Feature toggles** | Feature on/off changes behavior | `FeatureToggleBuilder().on(...)` / `.off(...)` |
| **Empty states** | No data shows appropriate messaging | Builder with no items |
| **Authentication** | Step-up auth flows in transactions | `TransactionAuthBuilder` + auth driver |

### Test Naming

Test names should be descriptive and concise while preserving the AC intent:

```dart
// Good
testWidgets("Display recent transfer recipients list", ...);
testWidgets("Confirming deletion removes recipient from the list", ...);
testWidgets("Error message persists if the input is empty after deleting the amount", ...);
testWidgets("Saved reference text is prefilled on next transfer", ...);

// Bad
testWidgets("test1", ...);
testWidgets("should work", ...);
testWidgets("recipients", ...);
testWidgets("When user who has previously persisted a reference text for this recipient opens transfer amount page again then reference text is pre-populated", ...);
```

Rules:
- Keep titles concise and avoid copying long AC sentences verbatim
- Prefer titles that keep `testWidgets("<title>", (WidgetTester tester) async {` on one line after formatting
- Preserve behavior traceability by keeping wording aligned to AC intent

### Grouping

Use `group` to organize tests by feature area or user story:

```dart
group("Transfer Recipients V2 visibility", () { ... });
group("User initiates deletion of a recipient", () { ... });
group("Offers overview - Adobe ad", () { ... });
group("Offers overview - Redemptions tab", () { ... });
group("Loan prepayment - Partial payment", () { ... });
```

Rules:
- One `group` per logical feature area
- Multiple groups in one file are acceptable
- Group name should reflect the user story or feature area
- Shared constants (IDs, account numbers) can be declared at group level

---

## Mapping ACs to Tests

Each acceptance criterion produces exactly one `testWidgets`. The mapping is:

| AC Element | Test Element |
|---|---|
| AC title | concise `testWidgets` description string preserving AC intent |
| Precondition | `// Given` + driver with builders |
| Trigger/action | `// When` + driver interaction methods |
| Expected result | `// Then` + driver/appDriver assertion methods |
| Error condition | Builder configured with error (e.g. `.error()`, `.offersError()`) |
| Feature toggle state | `FeatureToggleBuilder().on(...)` or `.off(...)` |
| Multiple items | Builder chained multiple times (e.g. `.offer().offer().offer()`) |
| Empty state | Builder with no items (e.g. `OffersBuilder()`) |

### Example: AC → Test

**AC:** "When IBAN lookup fails, system reveals the bank number field for alternative lookup"

```dart
testWidgets("IBAN lookup failure reveals bank number field", (WidgetTester tester) async {
  // Given I am on the new foreign recipient page
  // And the IBAN lookup will fail
  final NewForeignRecipientDriver driver = NewForeignRecipientDriver(
    tester: tester,
    builders: [
      TransfersBuilder().ibanLookup(error: const Failure.serverError(message: "Not found")),
      FeatureToggleBuilder().on(NamedRoute.foreignTransfers()),
    ],
  );

  // When I enter a valid IBAN and submit
  await driver.openPage();
  await driver.enterAccountNumber("NL91ABNA0417164300");
  await driver.tapNext();

  // Then the bank number field is revealed
  driver.assertBankNumberFieldVisible(visible: true);

  // And an error message is shown
  driver.assertLookupErrorShown();
});
```

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Using `find.*` directly in test files | Use driver methods — tests must not know about widget internals |
| Importing page/widget classes in tests | Only import drivers, builders, and `test_rig.dart` |
| Testing implementation details | Test behavior (what the user sees), not how it's implemented |
| Creating tests for behavior not in ACs | Tests must trace back to acceptance criteria |
| Over-commenting straightforward tests | Creates noise; prefer descriptive test and driver method names |
| Hardcoding localized strings | Use `S.current.<key>` for localized text assertions |
| Repeating obvious comments before every line | Adds noise without improving behavior traceability |
| Sharing driver instances across tests | Each `testWidgets` gets its own driver instance |
| Forgetting `await` on async driver methods | Interaction methods are `Future` — always `await` them |
| Missing `tearDown` with `closeApp()` | Causes test pollution between scenarios |
| Passing builders to multiple drivers | Builders are launch-time setup and belong only to `driver` |
| Naming launching driver anything other than `driver` | Breaks repository-wide UAT convention |
| Declaring `driver` before other drivers | Use order: `AppDriver`, auxiliary drivers, then `driver` |
| Calling `tester.pump()`, `tester.pumpAndSettle()`, `tester.tap()`, or similar in the test file | Move the interaction into a driver or `AppDriver`; tests must stay at the behavior level |
| Calling `expect(...)`, `find.*`, or `tester.widget(...)` in a UAT test file | Move the check into a driver assertion method; keep `*_test.dart` files at scenario level only |
| Adding feature-driver methods like `assertIsOnAmountPage()` or `assertAmountPageDoesNotExist()` | Use the global `AppDriver` page assertions instead |

---

## Output

For each set of acceptance criteria, produce:

- One or more test files: `test/user_acceptance_tests/<feature>/<page>/<page>_test.dart`
- Each AC maps to exactly one `testWidgets`
- Tests grouped by feature area

After generating, verify with:

```bash
flutter test test/user_acceptance_tests/<feature>/<page>/
```

