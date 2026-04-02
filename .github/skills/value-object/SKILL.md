---
name: value-object
description: Guide for creating or editing Value Objects in the Domain layer. Use this when asked to create or edit a value object or domain primitive that parses/validates/formats data.
---

# Value Objects

Value Objects are immutable domain primitives that encapsulate validation, parsing, and formatting logic. They live in `lib/domain/<feature>/value_objects/` or `lib/domain/<feature>/{sub_feature}/value_objects/`

The patterns and conventions described below apply equally when editing existing value objects — modifications should remain consistent with the structure described here to ensure uniformity across the codebase.

**Key purposes of Value Objects:**
- **Input sanitization** - Normalize and clean user input (trim whitespace, remove invalid characters, standardize formats)
- **Validation** - Ensure data meets business rules before it enters the domain
- **Type safety** - Prevent primitive obsession by wrapping raw types
- **Encapsulation** - Keep parsing/formatting logic in a single location

## Value Object Identification Guide

Create a value object when a field requires any of the following:

- **Validation**: Data that must be validated before use (for example, email addresses, phone numbers, account numbers)
- **Parsing**: String values that map to typed enums or structured data (for example, status codes like "PENDING" → `PaymentRequestStatus.pending`)
- **Formatting**: Values needing display formatting (for example, currency amounts, dates, percentages)
- **Constrained values**: Values with a known set of valid options, typically backed by an enum
- **Business logic encapsulation**: When the primitive needs associated computed properties or methods
- **Reuse of existing value objects**: Prefer existing value objects where applicable to maintain consistency and reduce duplication.

## Step-by-Step Process

### 1. Create the File

Place in appropriate domain feature folder:
- Core value objects: `lib/domain/core/value_objects/`
- Feature-specific: `lib/domain/<feature>/value_objects/` or `lib/domain/<feature>/{sub_feature}/value_objects/`

File naming: `<name>_value_object.dart` (e.g., `email_value_object.dart`)

### 2. Implement the Value Object

Follow this exact template structure:

```dart
import 'package:isbapp/domain/core/value_objects/failures/failure.dart';
import 'package:isbapp/domain/core/value_objects/value_object.dart';
import 'package:isbapp/infrastructure/core/error_handling/error_handler.dart';

class MyExampleValueObject extends ValueObject<MyExampleType> {
  // 1. Provide a get accessor with default fallback
  MyExampleType get get => getOr(MyExampleType.invalid);

  // 2. Factory constructor for parsing/validation
  factory MyExampleValueObject(String? input, {bool logError = true}) {
    return MyExampleValueObject._(
      _parse(input, logError: logError),
      _validate(input, logError: logError),
    );
  }

  // 3. Private const constructor
  const MyExampleValueObject._(MyExampleType super.input, Failure<String>? super.failure);

  // 4. Named factory for invalid instances (use const)
  const factory MyExampleValueObject.invalid() = _$InvalidMyExampleValueObject;

  // 5. Static validation method returning Failure?
  static Failure<String>? _validate(String? input, {required bool logError}) {
    if (input == null) {
      return const Failure.invalidValue(message: "Value must not be null.");
    }
    final MyExampleType parsed = _parse(input, logError: logError);
    if (parsed == MyExampleType.invalid) {
      return Failure.invalidValue(failedValue: input, message: "Unknown value '$input'.");
    }
    return null;
  }

  // 6. Static parse method returning the typed value
  // Uses enum.values.byName for clean, readable parsing
  static MyExampleType _parse(String? input, {required bool logError}) {
    try {
      return MyExampleType.values.byName(input?.trim() ?? "");
    } catch (_) {
      if (logError) {
        errEnum(type: "MyExampleType", input: input);
      }
      return MyExampleType.invalid;
    }
  }
}

// 7. Private invalid instance class
class _$InvalidMyExampleValueObject extends MyExampleValueObject {
  const _$InvalidMyExampleValueObject()
    : super._(MyExampleType.invalid, const Failure.invalidValue(message: "Null/Invalid instance"));
}

// 8. Associated enum (if applicable)
enum MyExampleType {
  optionA,
  optionB,
  invalid,
}
```

### 5. Testing Value Objects

Create test file at: `test/domain/<feature>/value_objects/<name>_value_object_test.dart`

```dart
void main() {
  group("MyExampleValueObject", () {
    test("when input is null, failure is set", () {
      final valueObject = MyExampleValueObject(null, logError: false);
      
      expect(valueObject.valid, isFalse);
      expect(valueObject.failure, isA<Failure>());
      expect(valueObject.get, MyExampleType.invalid);
    });
    
    test("when input is invalid, failure is set", () {
      final valueObject = MyExampleValueObject("unknown", logError: false);
      
      expect(valueObject.valid, isFalse);
      expect(valueObject.get, MyExampleType.invalid);
    });
    
    test("when input is valid, value is parsed correctly", () {
      final valueObject = MyExampleValueObject("option_a");
      
      expect(valueObject.valid, isTrue);
      expect(valueObject.failure, isNull);
      expect(valueObject.get, MyExampleType.optionA);
    });
  });
}
```