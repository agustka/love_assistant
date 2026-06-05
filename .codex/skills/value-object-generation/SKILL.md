---
name: value-object-generation
description: >-
  Generate domain value objects that wrap primitive values with validation,
  parsing, formatting, failure handling, equality, and focused tests.
tools: []
---

# Skill: value-object-generation

## Purpose

Value objects wrap a single primitive value with validation, parsing, and formatting logic. They are the first line of defense — rejecting invalid data eagerly at construction time via `Failure`.

---

## File Location

```
lib/domain/<feature>/value_objects/<name>_value_object.dart
```

Core/shared value objects live under `lib/domain/core/value_objects/`.

---

## Base Class

All value objects extend `ValueObject<T>` from `domain/core/value_objects/value_object.dart`:

```dart
@immutable
abstract class ValueObject<T> extends Equatable {
  final T? _value;
  final Failure? _failure;

  Failure? get failure => _failure;
  T? get value => _value;
  bool get valid => _failure == null;
  bool get isInvalid => _failure != null;

  const ValueObject(this._value, this._failure);

  T getOr(T errorValue);
  T? getOrNull();
  S fold<S>(S Function(Failure) failure, S Function(T) value);
}
```

---

## Simple Value Object (String-based)

For value objects that wrap a simple string with basic validation:

```dart
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';

class <Name>ValueObject extends ValueObject<String> {
  String get get => getOr("");

  factory <Name>ValueObject(String? input) {
    return <Name>ValueObject._(input ?? "", _validate(input));
  }

  const factory <Name>ValueObject.invalid() = _$Invalid<Name>;

  const <Name>ValueObject._(String super.input, Failure<String>? super.failure);

  static Failure<String>? _validate(String? input) {
    if (input == null) {
      return const Failure.invalidValue(message: "<Name> must not be null.");
    }
    // Add additional validation rules here
    return null;
  }
}

class _$Invalid<Name> extends <Name>ValueObject {
  const _$Invalid<Name>() : super._("", const Failure.invalidValue(message: "Null/invalid instance"));
}
```

---

## Enum-based Value Object

For value objects that parse a string into a typed enum:

```dart
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/value_object.dart';
import 'package:la/infrastructure/core/error_handling/error_handler.dart';

class <Name>ValueObject extends ValueObject<<Name>> {
  <Name> get get => getOr(<Name>.invalid);

  factory <Name>ValueObject(String? input) {
    return <Name>ValueObject._(<Name>._parse(input), _validate(input));
  }

  const factory <Name>ValueObject.invalid() = _$Invalid<Name>ValueObject;

  const <Name>ValueObject._(<Name> super.input, Failure<String>? super.failure);

  static Failure<String>? _validate(String? input) {
    final <Name> parsed = <Name>._parse(input);
    if (input == null) {
      return const Failure.invalidValue(message: "<Name> must not be null.");
    } else if (parsed == <Name>.invalid) {
      return Failure.invalidValue(failedValue: input, message: "Unknown <Name> $input.");
    }
    return null;
  }
}

class _$Invalid<Name>ValueObject extends <Name>ValueObject {
  const _$Invalid<Name>ValueObject()
    : super._(<Name>.invalid, const Failure.invalidValue(message: "Null/invalid instance"));
}

enum <Name> {
  valueA,
  valueB,
  invalid;

  static <Name> _parse(String? input) {
    try {
      return <Name>.values.byName(input?.trim() ?? "");
    } catch (_) {
      errEnum(type: "<Name>", input: input);
      return <Name>.invalid;
    }
  }
}

extension <Name>Extension on <Name> {
  // Add business logic extensions here
}
```

---

## Structural Rules

| Rule | Detail |
|------|--------|
| Extend `ValueObject<T>` | Always — provides `valid`, `failure`, `fold`, `getOr` |
| Private constructor | `const <Name>ValueObject._(T super.input, Failure<T>? super.failure)` |
| Factory constructor | `factory <Name>ValueObject(String? input)` — parses and validates |
| `.invalid()` factory | `const factory <Name>ValueObject.invalid()` — private subclass with const Failure |
| `get` accessor | `T get get => getOr(defaultValue)` — never returns null |
| `_validate()` static | Returns `Failure?` — null means valid |
| `_parse()` on enum | For enum-based VOs — static method on the enum using `values.byName()` with try/catch |
| `errEnum()` | Use for logging unrecognized enum values: `errEnum(type: "TypeName", input: input)` |
| `logError` parameter | Older VOs accept `{bool logError = true}`; newer VOs omit it and always log via `errEnum` |

---

## Companion Enums

When a value object wraps an enum:

- Define the enum in the **same file** as the value object
- Always include an `invalid` case as the last value
- Add an `extension` on the enum for business logic (localized names, sorting, computed properties)

---

## Comment Discipline

- Keep generated value-object files self-documenting through naming.
- Do not add method/property/function doc comments (`///`).
- Do not add banner/section comments (for example: `// Validation`, `// Parsing`, `// Getters`).
- Use comments only for rare, non-obvious rationale that cannot be expressed in code.

---

## What NOT to Do

- Do not use raw primitives where a value object should exist — wrap them
- Do not make value objects mutable — they are always `const`-constructable
- Do not skip the `_validate` method — all validation happens at construction
- Do not return nullable types from `get` — use `getOr(fallback)` with a safe default
- Do not put infrastructure concerns (HTTP, JSON, caching) in value objects
- Do not extend `Equatable` directly — extend `ValueObject<T>` (which extends `Equatable`)
