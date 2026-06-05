---
name: entity-generation
description: >-
  Generate immutable domain entities composed of value objects, with identity,
  validity, behavior, model conversion, equality, and focused tests.
tools: []
---

# Skill: entity-generation

## Purpose

Entities are rich, immutable domain models composed entirely of value objects. They represent business concepts with identity, validity, and behavior. An entity instance is always in a meaningful state by construction.

---

## File Location

```
lib/domain/<feature>/entities/<entity_name>.dart
```

Multiple related entities (e.g. a collection and its item) may live in the same file.

---

## Canonical Template

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:la/domain/core/value_objects/text_value_object.dart';
import 'package:la/infrastructure/<feature>/models/<feature>_model.dart';

@immutable
class <Entity> extends Equatable {
  final TextValueObject name;
  final <SomeValueObject> status;
  final bool valid;

  bool get isInvalid => !valid;

  const <Entity>({
    required this.name,
    required this.status,
    this.valid = true,
  });

  // ── Invalid factory ──

  const <Entity>.invalid()
    : name = const TextValueObject.invalid(),
      status = const <SomeValueObject>.invalid(),
      valid = false;

  // ── fromModel factory ──

  factory <Entity>.fromModel(<Feature>Model model) {
    return <Entity>(
      name: TextValueObject(model.name),
      status: <SomeValueObject>(model.status),
    );
  }

  // ── Domain logic ──

  bool get isActive => status.get == <SomeStatus>.active;

  @override
  List<Object?> get props => [
    name,
    status,
    valid,
  ];
}
```

---

## Collection Entity

When the API returns a list, create a wrapper entity:

```dart
@immutable
class <Entities> extends Equatable {
  final List<<Entity>> items;
  final bool valid;

  const <Entities>({required this.items, this.valid = true});

  const <Entities>.invalid() : items = const [], valid = false;

  factory <Entities>.fromModel(<EntitiesModel> model) {
    return <Entities>(
      items: (model.data ?? []).map(<Entity>.fromModel).toList(),
    );
  }

  <Entity> findById(String id) {
    try {
      return items.firstWhere((<Entity> e) => e.id.get == id);
    } catch (_) {
      return const <Entity>.invalid();
    }
  }

  @override
  List<Object?> get props => [items, valid];
}
```

---

## fromModel Pattern

The `fromModel` factory maps infrastructure models to domain entities. The domain entity **owns** this mapping — never put `toDomain()` on the model.

```dart
factory Insurance.fromModel(InsuranceModel model) {
  return Insurance(
    name: TextValueObject(model.name),
    categoryCode: InsuranceCategoryCodeValueObject(model.categoryCode),
    totalPrice: MoneyValueObject.fromAmountAndCurrency(
      amount: model.totalPrice?.toDouble(),
      currency: const CurrencyValueObject.isk(),
    ),
    policyObjects: model.policyObjects?.map(InsurancePolicyObject.fromModel).toList() ?? [],
  );
}
```

Key rules:
- Wrap every raw field in its value object — `TextValueObject(model.name)`, not `model.name`
- Handle nulls: use `?? []` for lists, use value object factories that accept nullable input
- Map nested models recursively: `model.children?.map(ChildEntity.fromModel).toList() ?? []`
- Named constructor form is also valid: `Country.fromModel(CountryModel model) : name = TextValueObject(model.name), ...`

---

## toModel Pattern

The reverse of `fromModel`: when an entity needs to be serialized or sent outward, the entity **owns** the conversion to its infrastructure model via a `toModel()` method. The entity never carries `toJson()` itself — serialization lives on the model. This keeps the entity as the single place that knows the value-object ↔ primitive mapping in both directions, and keeps serialization (`toJson`/`fromJson`) on the DTO where it belongs.

```dart
UserPartnerProfileModel toModel() {
  return UserPartnerProfileModel(
    partnerName: partnerName,
    partnerPronoun: partnerPronoun.name,
    partnerBirthday: partnerBirthday?.toIso8601String(),
    partnerLoveLanguages: partnerLoveLanguages.map((LoveLanguage e) => e.name).toList(),
  );
}
```

Key rules:
- The entity unwraps value objects to the primitives the model holds (`pronoun.name`, `date?.toIso8601String()`), mirroring how `fromModel` wraps them back.
- The model is a plain DTO of primitives annotated `@JsonSerializable()`; it owns `toJson()`/`fromJson()` (generated into `<model>.g.dart`). The entity owns `toModel()`/`fromModel()`.
- Never place `toJson()` (or any JSON map building) on the entity. If an infrastructure class is hand-rolling a `Map<String, dynamic>` from an entity, that logic is misplaced — move it to a model `toJson()` reached via `entity.toModel()`.
- Only add `toModel()` when an entity is actually serialized/persisted/sent outward — do not add it speculatively.

---

## Structural Rules

| Rule | Detail |
|------|--------|
| `@immutable` | Always — from `package:flutter/foundation.dart` |
| Extend `Equatable` | Always — for value equality |
| Value object properties | Never raw primitives (`String`, `int`, `double`) — always value objects |
| `valid` property | `bool valid` (defaults to `true`) — indicates entity validity |
| `isInvalid` getter | `bool get isInvalid => !valid;` |
| `.invalid()` factory | Const named constructor — all fields set to their `.invalid()` defaults, `valid = false`. This is how absence travels through the system: stores/use cases return `Payload.success(const Entity.invalid())` for "not found", never `Payload<Entity?>`. See **repository-pattern** / **use-case-generation**. |
| `.empty()` factory | Optional — for valid-but-empty state (e.g. empty list entity) |
| `fromModel` factory | Required — constructs domain entity from infrastructure model |
| `toModel()` method | Required **only when the entity is serialized/persisted/sent outward** — converts the entity to its infrastructure model (which owns `toJson`). Never put `toJson` on the entity. |
| `props` override | List all fields including `valid` for correct equality |
| Single responsibility | One entity per business concept |
| Domain logic in entity | Computed properties, business methods, eligibility checks, filtering |

---

## Domain Logic Examples

Entities contain domain behavior — not just data:

```dart
// Computed properties
MoneyValueObject get totalMonthlyPayment {
  final int monthly = (totalPrice.amount / 12).round();
  return MoneyValueObject.isk(monthly);
}

// Business queries
bool get hasHomeInsurance {
  return policyObjects.any((po) => po.products.any(
    (p) => p.productNumber.get == InsuranceProductNumber.homeInsurance,
  ));
}

// Lookup methods
Country findCountry(String isoCode) {
  try {
    return countries.firstWhere((c) => c.code.get.toLowerCase() == isoCode.toLowerCase());
  } catch (_) {
    return const Country.invalid();
  }
}
```

---

## Comment Discipline

- Keep entity files self-documenting with clear names and small methods.
- Do not add method/property/function doc comments (`///`).
- Do not add section banners or explanatory comments for obvious code.
- Add a short comment only when non-obvious business rationale would otherwise be unclear.

---

## What NOT to Do

- Do not use raw primitives as entity properties — always wrap in value objects
- Do not put `toDomain()` on infrastructure models — use `Entity.fromModel(model)` instead
- Do not include infrastructure concerns (HTTP, caching, JSON serialization)
- Do not include UI concerns (widgets, localization keys)
- Do not make entities mutable — they are `@immutable`
- Do not skip the `valid` property — every entity needs validity tracking
- Do not create a separate class just to hold a `List<Entity>` without behavior — use a collection entity only when it adds domain logic (e.g. `findById`, filtering, computed aggregates). If no behavior is needed, use `List<Entity>` directly on a parent entity
