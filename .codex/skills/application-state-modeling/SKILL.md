---
name: application-state-modeling
description: >-
  Model cubit state classes for the application layer. Produces immutable,
  Equatable state classes with copyWith, status enums, and value-object fields
  that represent the current UI-facing snapshot of a feature.
tools: []
---

## Purpose

Use this skill to generate state classes that accompany cubits. A state is the single, immutable snapshot of everything the UI needs to render a feature screen.

State classes live as `part` files alongside their cubit.

---

## File Location

```
lib/application/<feature>/<cubit_name>/<cubit_name>_state.dart
```

The file begins with `part of '<cubit_name>_cubit.dart';`.

---

## Canonical Template

```dart
part of '<cubit_name>_cubit.dart';

enum <CubitName>Status {
  loading,
  loaded,
  error,
}

@immutable
class <CubitName>State extends Equatable {
  final <CubitName>Status status;
  final SomeEntity data;
  final MoneyValueObject amount;
  final bool amountError;

  bool get isLoading => status == <CubitName>Status.loading;

  const <CubitName>State({
    required this.status,
    required this.data,
    required this.amount,
    required this.amountError,
  });

  factory <CubitName>State.initial() {
    return const <CubitName>State(
      status: <CubitName>Status.loading,
      data: SomeEntity.invalid(),
      amount: MoneyValueObject.invalid(),
      amountError: false,
    );
  }

  <CubitName>State copyWith({
    <CubitName>Status? status,
    SomeEntity? data,
    MoneyValueObject? amount,
    bool? amountError,
  }) {
    return <CubitName>State(
      status: status ?? this.status,
      data: data ?? this.data,
      amount: amount ?? this.amount,
      amountError: amountError ?? this.amountError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    amount,
    amountError,
  ];
}
```

---

## Rules

### Structure

| Rule | Detail |
|------|--------|
| `part of` | Always — state file is a `part` of the cubit file |
| `@immutable` | Always — from `package:flutter/foundation.dart` or `package:freezed_annotation/freezed_annotation.dart` |
| Extend `Equatable` | Always — for value equality and efficient `BlocBuilder` rebuilds |
| `const` constructor | Always — all fields `required` and named |
| `.initial()` factory | Always — provides the starting state with safe defaults |
| `copyWith` method | Always — every field is an optional named parameter, defaults to `this.<field>` |
| `props` override | Always — list every field for correct equality comparison |

### Nullability (CRITICAL)

**Never use nullable entity or value-object fields on a state class.** Domain types are designed to express absence through their own `.empty()` / `.invalid()` factories — that is the whole point of having value objects and entities. Using `EntityType?` re-introduces the null-vs-absent ambiguity the domain layer was built to eliminate, and forces every reader (cubit, page, builder) to write a `== null` guard instead of trusting the type.

- A state field that holds a domain entity → `final SomeEntity field` (non-nullable). Initial value: `SomeEntity.empty()` or `SomeEntity.invalid()`.
- A state field that holds a value object → `final SomeValueObject field` (non-nullable). Initial value: `SomeValueObject.invalid()`.
- A state field that holds a list of entities → `final List<SomeEntity> field` (non-nullable). Initial value: `const []`.
- Guard "not yet provided" cases in the cubit via `field.isInvalid` / `field.valid`, never `field == null`.
- The `copyWith` parameter for that field stays nullable (`SomeEntity? field`) — that nullable is the standard "did the caller pass this argument?" sentinel and is `?? this.field`-folded. It is NOT the field's type.

If the entity does not already expose `.empty()` / `.invalid()`, add one to the entity (per the domain layer rule) — do not paper over the gap with a nullable in state.

The same rule applies to status enums and helper enums declared in the state file: provide an explicit `none` / `idle` / `unknown` variant rather than making the enum field nullable.

### Status Enum

Every state has a status enum that models the page lifecycle:

```dart
enum <CubitName>Status {
  loading,    // data is being fetched
  loaded,     // data is available
  error,      // a fatal load error occurred
  // feature-specific statuses:
  accepting,  // an action is in progress
  rejecting,
}
```

- The enum is defined in the state file, above the state class
- The first value should represent the initial/loading state
- Use feature-specific values for in-progress actions (e.g. `submitting`, `accepting`, `rejecting`)
- Avoid generic names like `success` — prefer `loaded`

### Field Types

| Field type | When to use |
|---|---|
| Domain entities | Primary data: `PaymentRequest`, `AccountV2` |
| Value objects | User input, validated amounts: `MoneyValueObject`, `TextValueObject`, `EmailValueObject` |
| Status enums | Page lifecycle, sub-component status |
| `BoolValueObject` | Tri-state flags (invalid/yes/no) where the distinction between "not yet set" and "no" matters: `isBusinessUser`, `hasAcceptedTerms` |
| `bool` | Simple binary flags, including per-field error flags: `processingOffer`, `nameError`, `amountError` |
| `List<T>` | Collections of selectable items |
| Raw primitives | Only for simple counters/indices: `int selectedTabIndex` |

**Prefer value objects over raw primitives** for any field that represents user input or domain data.

### Initial State Defaults

- Entities: `SomeEntity.invalid()` or `SomeEntity.empty()` — **never `null`**
- Value objects: `SomeValueObject.invalid()` — **never `null`**
- Status: the `loading` (or other appropriate) enum value — **never `null`**
- Booleans: `false`
- Lists: `const []`
- Indices: `0`

If the domain type's `.empty()` / `.invalid()` factory is `const`, the whole `.initial()` constructor can stay `const`. If the factory has runtime validation (so it cannot be `const`), drop `const` from `.initial()` — that is the correct trade-off, not a nullable field.

### Computed Getters

State classes may contain computed getters that derive from fields — **not** business logic:

```dart
bool get hasFilledInContactForm => email.valid && phoneNumber.valid;
bool get hasPreselectedCategory => preselectedType != CategoryCode.invalid;
bool get isLoading => status == <CubitName>Status.loading;
```

- Getters must be pure derivations from state fields
- They must not call external services or modify state
- Use for UI convenience (e.g. disabling buttons, showing/hiding sections)

### Additional Enums

Define additional helper enums in the state file when needed:

```dart
enum PaymentRequestAmountChange {
  increased,
  decreased,
  unchanged,
}
```

These are co-located with the state class they serve.

---

## What NOT to Do

| Anti-pattern | Why |
|---|---|
| Mutable fields | State must be `@immutable` with `final` fields |
| Missing field in `props` | Breaks equality — `BlocBuilder` may not rebuild |
| Missing field in `copyWith` | Makes the field impossible to update after creation |
| Raw `String`/`int` for user input | Use value objects for validation and domain alignment |
| Nullable entity / value-object fields (`SomeEntity?`, `SomeValueObject?`) | The domain layer already expresses absence via `.empty()` / `.invalid()`. Nullable re-introduces the ambiguity those factories were designed to remove and forces `== null` guards in every reader. See "Nullability (CRITICAL)" above. |
| Nullable status or helper enums | Add an explicit `none` / `idle` / `unknown` variant instead of making the enum field nullable. |
| Business logic methods on state | State is a data snapshot; logic belongs in the cubit or domain |
| Multiple state subclasses (sealed state) | Use a single state class with a status enum and `copyWith` |
| Default constructor without `.initial()` factory | The cubit needs a well-defined starting state |
| Global `showValidationMessages` or `didSubmit` flag | Legacy pattern — use per-field `bool` error flags instead (see `application-input-handling` skill) |

---

## Output

For each cubit state, produce:

- One `<cubit_name>_state.dart` file as a `part` of the cubit
- A status enum
- The state class with constructor, `.initial()`, `copyWith`, and `props`

