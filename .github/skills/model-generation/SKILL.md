---
name: model-generation
description: >-
  Generate infrastructure-layer API models from OpenAPI schemas. Produces
  immutable, nullable, JsonSerializable classes that mirror the spec naming.
tools: []
---

## Purpose

Use this skill to generate Dart model classes from OpenAPI schema definitions parsed by `api-parsing`.

Models live exclusively in the infrastructure layer. They are plain data carriers for JSON serialization — they must not contain business logic.

---

## Input

The structured schema output from the `api-parsing` skill (schema name, properties, types, enums).

---

## Model Structure

Every model must follow this template:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<file_name>.g.dart';

@immutable
@JsonSerializable(includeIfNull: true, explicitToJson: true)
class ExampleModel {
  final String? id;
  final String? name;
  final double? amount;
  final NestedModel? nested;

  const ExampleModel({
    this.id,
    this.name,
    this.amount,
    this.nested,
  });

  factory ExampleModel.fromJson(Map<String, dynamic> json) => _$ExampleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExampleModelToJson(this);
}
```

---

## Rules

### Naming

- **Class name**: use the schema name from the OpenAPI spec + `Model` suffix (e.g. schema `Account` → `AccountModel`)
- **Field names**: use the property name from the spec as-is when it is already camelCase; use `@JsonKey(name: "...")` only when the API key differs from Dart camelCase convention
- **File name**: snake_case of the class name (e.g. `account_model.dart`)
- Keep names as close to the OpenAPI spec as possible — do not rename, abbreviate, or expand

### Types

- All fields are **nullable** (`Type?`) unless the OpenAPI schema explicitly marks them as `required` AND they cannot be null
- Prefer raw Dart types that match the schema:
  - `string` → `String?`
  - `integer` → `int?`
  - `number` → `double?` (or `num?` when format is unspecified)
  - `boolean` → `bool?`
  - `array` → `List<ChildModel>?` (or `List<String>?` for primitives)
  - `object` (with `$ref`) → `NestedModel?`
  - `string` + `date-time` format → `DateTime?`
- Do **not** use domain types, value objects, or entities in models

### Immutability

- Annotate every model class with `@immutable`
- Use `const` constructors
- All fields must be `final`

### Serialization

- Annotate with `@JsonSerializable(includeIfNull: true, explicitToJson: true)`
  - `includeIfNull: true` — ensures null fields are included in JSON output
  - `explicitToJson: true` — ensures nested models call their own `toJson`
- Provide both `fromJson` factory and `toJson` method
- Use the generated `_$<ClassName>FromJson` / `_$<ClassName>ToJson` helpers via `part '<file>.g.dart'`
- Import comes from `package:freezed_annotation/freezed_annotation.dart` (which re-exports `json_annotation`)

### @JsonKey usage

- Use `@JsonKey(name: "...")` when the API field name is **not** standard camelCase (e.g. PascalCase, snake_case, or abbreviations)
- Use `@JsonKey(unknownEnumValue: EnumType.invalid)` for enum fields to handle unexpected server values
- Do not add `@JsonKey` when the Dart field name already matches the JSON key

### Enums

```dart
enum StatusType {
  @JsonValue("ACTIVE")
  active,
  @JsonValue("INACTIVE")
  inactive,
  @JsonValue("PENDING")
  pending,
  invalid,
}
```

- Always include a trailing `invalid` case for forward compatibility
- Use `@JsonValue("...")` to map to the exact API string
- Reference in model fields with `@JsonKey(unknownEnumValue: StatusType.invalid)`

### Nested and wrapper models

- Nested objects get their own model class in the same file (or a separate file if reused)
- Response envelope / wrapper models are generated as-is from the spec — do not flatten or skip them
- List wrappers: `final List<ItemModel>? items;`

---

## What to avoid

| Anti-pattern | Why                                                                             |
|---|---------------------------------------------------------------------------------|
| `toDomain()` methods on models | Deprecated approach — domain mapping belongs in the domain layer, not the model |
| Domain imports in model files | Models must not depend on domain entities or value objects                      |
| Non-nullable fields for optional API data | The API may omit fields; nullable prevents runtime crashes                      |
| Renaming fields away from spec names | Causes drift between spec and code; harder to maintain                          |
| Manual `fromJson` / `toJson` implementations | Use `json_serializable` code generation only                                    |
| `Equatable` on models | Only add if specifically needed (e.g. caching comparison); not default          |

---

## Converter Registration

Every new model **must** be added to the feature's model converter class. The converter lives at:

```
lib/infrastructure/<feature>/models/converter/<feature>_model_converter.dart
```

Add an entry to the `conversions` map for each model that can be deserialized (response models, not request-only models):

```dart
class <Feature>ModelConverter extends JsonConverter with BaseConverter {
  @override
  Map<dynamic, Function> get conversions => {
    // ...existing entries...
    NewModel: (Map<String, dynamic> data) => NewModel.fromJson(data),
  };

  @override
  Future<Response<BodyType>> convertResponse<BodyType, InnerType>(Response response) async {
    final Response rawResponse = await super.convertResponse(response);
    return convertToCustomObject<InnerType, BodyType>(rawResponse, conversions);
  }
}
```

### Why this matters

The `conversions` map is used by:
1. **Chopper** — to deserialize HTTP response bodies into typed models
2. **Cache support** — to deserialize cached JSON back into models via `getCachedV2`

If you forget to register a model, both REST responses and cache reads for that type will fail silently (return `null`).

### Rules

- Only add **response/read** models (models returned by the API)
- Request-only models (sent as `@Body()`) do not need a converter entry
- Nested models that appear independently in a response also need their own entry
- One converter per feature — shared across all chopper services and cache helpers in that feature

---

## File placement

```
lib/infrastructure/<feature>/models/
├── <response_model>.dart
├── <request_model>.dart
├── requests/           ← optional subfolder for request-only models
└── converter/          ← model converter (conversions map + Chopper JsonConverter)
```

---

## Output

For each OpenAPI schema, produce:

- One `.dart` file per top-level schema (or group of tightly coupled schemas)
- All classes annotated and structured per the rules above
- A generated `part` file reference (`part '<file>.g.dart'`)

After creating models, run code generation:

```bash
python3 scripts/build.py json
```

