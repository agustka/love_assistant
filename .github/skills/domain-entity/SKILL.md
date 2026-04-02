---
name: domain-entity
description: Guide for creating or editing Domain Entities in the Domain layer. Use this when asked to create or edit an entity, domain model, or business object that represents a core business concept with multiple properties.
---

# Domain Entities

Domain Entities are rich domain models representing core business concepts. They contain multiple properties (Value Objects) and business logic methods. They live in `lib/domain/<feature>/entities/`.

The patterns and conventions described below apply equally when editing existing entities — modifications should remain consistent with the structure described here to ensure uniformity across the codebase.

**Entity vs Value Object distinction:**
- **Entity**: Composite object with multiple properties, identity, and business methods (Account, User, Transaction)
- **Value Object**: Single-value wrapper with validation/parsing logic (EmailValueObject, MoneyValueObject)

## Template

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class MyEntity extends Equatable {
  // Use Value Objects as properties (not raw primitives)
  final TextValueObject name;
  final BoolValueObject isActive;
  final bool valid;

  const MyEntity({
    required this.name,
    required this.isActive,
    this.valid = true,
  });

  // Invalid factory for error states
  const factory MyEntity.invalid() = _$InvalidMyEntity;

  // fromModel constructor for infrastructure layer
  factory MyEntity.fromModel({required MyModel model}) {
    return MyEntity(
      name: TextValueObject(model.name),
      isActive: BoolValueObject(model.isActive),
    );
  }

  bool get isInvalid => !valid;

  @override
  List<Object?> get props => [name, isActive, valid];
}

class _$InvalidMyEntity extends MyEntity {
  const _$InvalidMyEntity()
      : super(
          name: const TextValueObject.invalid(),
          isActive: const BoolValueObject.invalid(),
          valid: false,
        );
}

```

## Interface Implementation

For polymorphic entities:

```dart
abstract class ITransaction {
  DateValueObject get date;
  MoneyValueObject get amount;
}

@immutable
class BankTransaction extends Equatable implements ITransaction {
  @override
  final DateValueObject date;
  @override
  final MoneyValueObject amount;
  final AccountNumberValueObject accountNumber;
  final bool valid;

  const BankTransaction({
    required this.date,
    required this.amount,
    required this.accountNumber,
    this.valid = true,
  });
  // ... factories and methods
}
```

## Key Points

- Use `@immutable` annotation
- Extend `Equatable` for value equality ALWAYS
- Use Value Objects as properties, never raw primitives
- Has `valid` boolean property (defaults to `true`)
- Provides `.invalid()` const factory
- Has `fromModel` constructor, if encapsulating data from a model.
- Business logic lives in entity methods
- No infrastructure dependencies (no HTTP, caching, database)