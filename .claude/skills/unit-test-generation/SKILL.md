---
name: unit-test-generation
description: >-
  Generate unit tests for domain value objects and entities.
  Tests validate construction, validation, equality, formatting,
  and domain logic. Does not test use cases.
tools: []
---

## Purpose

Use this skill to generate unit tests for domain-layer value objects and entities. Unit tests verify that domain primitives behave correctly in isolation — validation rules, parsing, formatting, equality, computed properties, and domain logic methods.

---

## Scope

### In Scope

- **Value objects** — validation, parsing, formatting, `get` accessor, `.invalid()` factory, equality, edge cases
- **Entities (business logic only)** — tests only when entity adds domain logic methods/computed properties/lookup behavior

### Out of Scope

- **Use cases** — use case behavior is covered by user acceptance tests (BDD). Unit-testing use cases introduces coupling to orchestration details and produces fragile tests. Do not generate tests for use cases.
- **Entity boilerplate-only coverage** — if an entity only contains construction/props/invalid wiring and no business logic, do not generate an entity test file.

---

## File Location

```
test/domain/<feature>/value_objects/<name>_value_object_test.dart
test/domain/<feature>/entities/<entity_name>_test.dart
```

Core/shared tests live under `test/domain/core/value_objects/` and `test/domain/core/entities/`.

Mirror the production source path: if the source is `lib/domain/wizard/value_objects/pronoun_value_object.dart`, the test is `test/domain/wizard/value_objects/pronoun_value_object_test.dart`.

> Note: `test/domain/` does not exist yet in this project. The current `test/` tree has `_core/`, `application/`, and `presentation/` only — the first time this skill is used, create the `test/domain/<feature>/` folders as needed.

---

## Value Object Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/<feature>/value_objects/<name>_value_object.dart';

void main() {
  group("<Name>ValueObject", () {
    test("accepts valid input", () {
      final <Name>ValueObject valueObject = <Name>ValueObject("<valid_input>");

      expect(valueObject.valid, isTrue);
      expect(valueObject.get, "<expected_output>");
    });

    test("rejects null input", () {
      final <Name>ValueObject valueObject = <Name>ValueObject(null);

      expect(valueObject.valid, isFalse);
      expect(
        valueObject.failure,
        const Failure<String>.invalidValue(message: "<null error message>"),
      );
    });

    test("rejects invalid input", () {
      final <Name>ValueObject valueObject = <Name>ValueObject("<invalid_input>");

      expect(valueObject.valid, isFalse);
      expect(
        valueObject.failure,
        const Failure<String>.invalidValue(
          failedValue: "<invalid_input>",
          message: "<validation error message>",
        ),
      );
    });

    test(".invalid() creates an invalid instance", () {
      const <Name>ValueObject valueObject = <Name>ValueObject.invalid();

      expect(valueObject.valid, isFalse);
      expect(valueObject.get, <default_value>);
    });

    test("supports value equality", () {
      final <Name>ValueObject a = <Name>ValueObject("<valid_input>");
      final <Name>ValueObject b = <Name>ValueObject("<valid_input>");

      expect(a, equals(b));
    });
  });
}
```

---

## Entity Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:la/domain/<feature>/entities/<entity_name>.dart';

void main() {
  group("<EntityName>", () {
    test("constructs a valid entity", () {
      final <EntityName> entity = _getEntity();

      expect(entity.valid, isTrue);
    });

    test(".invalid() creates an invalid instance", () {
      const <EntityName> entity = <EntityName>.invalid();

      expect(entity.valid, isFalse);
      expect(entity.isInvalid, isTrue);
    });

    test("supports value equality", () {
      final <EntityName> a = _getEntity();
      final <EntityName> b = _getEntity();

      expect(a, equals(b));
    });

    // Domain logic tests — one test per method/computed property
    test("<methodName> returns expected result", () {
      final <EntityName> entity = _getEntity(<specific_args>);

      expect(entity.<methodName>(), <expected>);
    });
  });
}

/// Helper factory — centralizes entity construction with sensible defaults.
/// Override individual fields per test scenario.
<EntityName> _getEntity({<override parameters>}) {
  return <EntityName>(
    <field>: <DefaultValueObject>("<default>"),
    // ...all required fields with valid defaults
  );
}
```

---

## Test Categories

Generate tests for each applicable category:

### Value Objects

| Category | What to test | Example |
|---|---|---|
| **Valid input** | Accepts well-formed values, `get` returns expected output | `expect(vo.valid, isTrue)` |
| **Null input** | Rejects null with correct `Failure` message | `expect(vo.failure, Failure.invalidValue(...))` |
| **Invalid input** | Rejects malformed values with correct `Failure` | `expect(vo.valid, isFalse)` |
| **Edge cases** | Boundary values, empty strings, whitespace, special characters | `<Name>ValueObject("")` |
| **Normalization** | Input trimming, case conversion, formatting | `expect(vo.get, "NORMALIZED")` |
| **`.invalid()` factory** | Creates consistently invalid instance with safe defaults | `expect(vo.get, defaultValue)` |
| **Equality** | Two instances with same input are equal | `expect(a, equals(b))` |
| **Formatting** | `.format()`, `.toAmountString()`, or similar display methods | `expect(vo.format(), "110881-4879")` |
| **Enum parsing** | String maps to correct enum value (for enum-based VOs) | `expect(vo.get, SomeEnum.active)` |
| **Computed properties** | `.isNegative`, `.isPositive`, `.is18OrOver`, etc. | `expect(vo.isNegative, true)` |

### Entities

| Category | What to test | Example |
|---|---|---|
| **Construction** | Valid entity from value objects | `expect(entity.valid, isTrue)` |
| **`.invalid()` factory** | Invalid entity with safe defaults | `expect(entity.isInvalid, isTrue)` |
| **Equality** | Two entities with same data are equal | `expect(a, equals(b))` |
| **Domain logic methods** | Business methods return correct results | `expect(entity.isActive(), true)` |
| **Computed properties** | Derived getters return correct values | `expect(entity.totalAmount, ...)` |
| **Lookup methods** | `findById`, `findByCode` return correct item or `.invalid()` | `expect(entities.findById("x"), ...)` |
| **Edge cases** | Empty lists, missing delimiters, legacy data formats | `expect(entity.getCity().get, "")` |

---

## Rules

### Allowed output paths (strict)

- `test/domain/<feature>/value_objects/<name>_value_object_test.dart`
- `test/domain/<feature>/entities/<entity_name>_test.dart` (only when entity business logic exists)

Forbidden:

- `test/domain/**/use_cases/*_test.dart`
- `test/application/**`
- `test/infrastructure/**`
- Hard failure policy: if a generated test is placed under `test/domain/**/use_cases/`, stop and report a policy violation instead of producing the file.

### Structure

| Rule | Detail |
|------|--------|
| One test file per source file | Mirror the production path with `_test.dart` suffix |
| `group` wraps all tests | Group name matches the class name being tested |
| `test` per scenario | One `test()` per distinct behavior — descriptive name |
| Helper factory for entities | Private `_getEntity()` function with default values — override per test |
| No test interdependence | Each test is self-contained — no shared mutable state |

### Assertions

| Rule | Detail |
|------|--------|
| Use `valid` / `isInvalid` | Check validity via the value object/entity API |
| Use `failure` for error details | Assert specific `Failure` type and message |
| Use `get` for output | Assert the safe accessor, not internal `_value` |
| Use `fold` when testing both paths | `data.fold((f) => f, (v) => null)` to extract failure |
| Use `equals` for equality | `expect(a, equals(b))` — relies on `Equatable` |

### Comments

Prefer descriptive test names and helper method names over inline comments.

Use `// given`, `// when`, `// then` comments only when a test has multiple non-trivial phases and comments materially improve readability:

```dart
test("rejects invalid structure", () {
  // given
  final SwiftBicValueObject valueObject = SwiftBicValueObject("DEUT12");

  // when / then
  expect(valueObject.valid, isFalse);
  expect(
    valueObject.failure,
    const Failure<String>.invalidValue(
      failedValue: "DEUT12",
      message: "SWIFT/BIC must be 8 or 11 characters with a valid structure.",
    ),
  );
});
```

For simple tests, omit comments.

### Clock

When testing time-dependent logic, use the test clock:

```dart
setUp(() {
  Clock.testClock = DateTime(2025, 6, 15, 12);
});

tearDown(() {
  Clock.testClock = null;
});
```

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Testing use cases | Use cases are orchestration — test them via BDD acceptance tests, not unit tests. Unit-testing use cases creates coupling and fragile tests. |
| Generating entity tests without business logic | Adds low-value boilerplate tests and noise. Only test entities with real domain behavior. |
| Testing infrastructure models | Models are data containers — test the entity `fromModel` mapping instead |
| Mocking value objects | Value objects are pure — construct them directly, never mock |
| Testing private methods | Test through the public API (`valid`, `get`, `failure`, domain methods) |
| Hardcoding locale-dependent output without setting locale | Set `App.userLocale` or pass `locale:` parameter when testing formatted output |
| Sharing state between tests | Each `test()` must be independent — use `setUp`/`tearDown` for shared setup |
| Testing Equatable props list | Equality is verified via `expect(a, equals(b))` — don't assert `props` directly |

---

## Output

For each value object or entity, produce:

- One test file at the mirrored test path
- Tests covering all applicable categories from the tables above
- Each test with a descriptive name

After generating, verify with:

```bash
flutter test test/domain/<feature>/value_objects/<name>_value_object_test.dart
flutter test test/domain/<feature>/entities/<entity_name>_test.dart
```

