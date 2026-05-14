# Skill: use-case-generation

## Purpose

Use cases are domain-layer orchestrators. They coordinate repositories and domain logic to fulfill a single business intent. They are stateless, injectable, and return results through domain wrappers (`Payload`, `StreamPayload`).

---

## File Location

```
lib/domain/<feature>/use_cases/<verb>_<intent>_use_case.dart
```

---

## Contracts

Every use case implements exactly one contract from `domain/core/use_cases/use_case.dart`:

```dart
abstract interface class IStreamUseCase<Output> {
  Stream<StreamPayload<Output>> subscribe();
  Future<void> reload();
  Future<void> refresh({required bool forceGet});
}

abstract interface class IStreamUseCaseWith<Input, Output> {
  Stream<StreamPayload<Output>> subscribe(Input input);
  Future<void> reload();
  Future<void> refresh({required bool forceGet});
}

abstract interface class IUseCase<Output> {
  Future<Payload<Output>> execute();
}

abstract interface class IUseCaseWith<Input, Output> {
  Future<Payload<Output>> execute(Input input);
}
```

---

## Stream Use Case (no input)

Delegates to a single repository's streaming interface:

```dart
import 'package:injectable/injectable.dart';
import 'package:isbapp/domain/<feature>/entities/<entity>.dart';
import 'package:isbapp/domain/core/use_cases/use_case.dart';
import 'package:isbapp/domain/core/value_objects/stream_payload.dart';
import 'package:isbapp/infrastructure/<feature>/repository/i_<feature>_repository.dart';

@injectable
class Watch<Feature>UseCase implements IStreamUseCase<<Entity>> {
  final I<Feature>Repository _repository;

  const Watch<Feature>UseCase(this._repository);

  @override
  Stream<StreamPayload<<Entity>>> subscribe() {
    return _repository.subscribe();
  }

  @override
  Future<void> refresh({required bool forceGet}) {
    return _repository.refresh(forceGet: forceGet);
  }

  @override
  Future<void> reload() {
    return _repository.reload();
  }
}
```

---

## One-shot Use Case (with input)

Executes a single operation and returns a `Payload`:

```dart
import 'package:injectable/injectable.dart';
import 'package:isbapp/domain/core/use_cases/use_case.dart';
import 'package:isbapp/domain/core/value_objects/payload.dart';
import 'package:isbapp/domain/<feature>/entities/<entity>.dart';
import 'package:isbapp/infrastructure/<feature>/repository/i_<feature>_repository.dart';

@injectable
class Get<Feature>UseCase implements IUseCaseWith<({<ValueObject> id, bool forceGet}), <Entity>> {
  final I<Feature>Repository _repository;

  const Get<Feature>UseCase(this._repository);

  @override
  Future<Payload<<Entity>>> execute(({<ValueObject> id, bool forceGet}) input) async {
    return _repository.getById(id: input.id, forceGet: input.forceGet);
  }
}
```

---

## Composing Stream Use Case

When a use case combines multiple streams:

```dart
import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:isbapp/core/streams/wrappers.dart';
import 'package:isbapp/domain/core/use_cases/use_case.dart';
import 'package:isbapp/domain/core/value_objects/stream_payload.dart';

@injectable
class Watch<Combined>UseCase implements IStreamUseCase<<CombinedEntity>> {
  final Watch<A>UseCase _watchA;
  final Watch<B>UseCase _watchB;

  Watch<Combined>UseCase(this._watchA, this._watchB);

  @override
  Stream<StreamPayload<<CombinedEntity>>> subscribe() {
    return combineLatestStreams(
      streamA: _watchA.subscribe(),
      streamB: _watchB.subscribe(),
      combiner: _combiner,
    );
  }

  StreamPayload<<CombinedEntity>> _combiner(
    StreamPayload<<A>> payloadA,
    StreamPayload<<B>> payloadB,
  ) {
    // Combine and return the appropriate StreamPayload state
  }

  @override
  Future<void> refresh({required bool forceGet}) async {
    await Future.wait([
      _watchA.refresh(forceGet: forceGet),
      _watchB.refresh(forceGet: forceGet),
    ]);
  }

  @override
  Future<void> reload() async {
    await Future.wait([
      _watchA.reload(),
      _watchB.reload(),
    ]);
  }
}
```

---

## Naming Convention

| Pattern | Contract | When to use |
|---------|----------|-------------|
| `Watch<X>UseCase` | `IStreamUseCase` / `IStreamUseCaseWith` | Reactive streaming data |
| `Get<X>UseCase` | `IUseCase` / `IUseCaseWith` | One-shot data retrieval |
| `Create<X>UseCase` | `IUseCaseWith` | Creating a resource |
| `Update<X>UseCase` | `IUseCaseWith` | Updating a resource |
| `Delete<X>UseCase` | `IUseCaseWith` | Deleting a resource |
| `Set<X>UseCase` | `IUseCaseWith` | Setting a preference/flag |
| `Validate<X>UseCase` | `IUseCaseWith` | Domain validation |
| `Refresh<X>UseCase` | `IUseCase` | Coordinated refresh across repos |

The verb expresses **business intent**, not implementation details.

---

## Input Modeling

| Scenario | Input type |
|----------|------------|
| Single primitive | Pass directly: `IUseCaseWith<bool, Output>` |
| Multiple parameters | Named Dart record: `IUseCaseWith<({TypeA a, TypeB b}), Output>` |
| No input | Use `IUseCase<Output>` or `IStreamUseCase<Output>` |

```dart
// Named record input
class GetBankLookupUseCase
    implements IUseCaseWith<({InternationalIbanValueObject iban, bool forceGet}), ForeignBankLookup> {
  @override
  Future<Payload<ForeignBankLookup>> execute(({InternationalIbanValueObject iban, bool forceGet}) input) async {
    return _repository.searchByIban(iban: input.iban, forceGet: input.forceGet);
  }
}
```

---

## Structural Rules

| Rule | Detail |
|------|--------|
| `@injectable` | Always — DI registration via get_it/injectable. See dependency-injection skill |
| Single contract | Implement exactly one of the four interfaces |
| Constructor injection | Dependencies via constructor — never resolved via `getIt<T>()` inside the body |
| Stateless | No mutable fields that change behavior across calls |
| Domain types only | Accept and return entities, value objects, `Payload<T>`, `StreamPayload<T>` |
| No infrastructure leakage | Never expose models, HTTP responses, or raw JSON |
| `const` constructor | When possible (no mutable state) |
| Validation boundary | Do not put UI submit-time required checks ("must select before save") into create/update persistence use cases |

### Comment Discipline

- Generated use case files must be lean and self-documenting.
- Do not add method/property/function doc comments (`///`).
- Do not add section headers, banner comments, or obvious explanatory inline comments.
- Use comments only for rare, non-obvious business rationale that cannot be expressed via naming.

---

## What NOT to Do

- Do not implement more than one contract interface
- Do not introduce UI or state management concerns (cubits, widgets)
- Do not instantiate dependencies — inject via constructor
- Do not return raw `Future<T>` or nullable data — use `Payload<T>` / `StreamPayload<T>`
- Do not expose infrastructure models through use case interfaces
- Do not use `Get*UseCase` naming for new stream-based use cases — use `Watch*`
- Do not use `Map` or `dynamic` bundles as input — use records or value objects
- Do not add mutable flags that change behavior across calls
- Do not add comment-heavy scaffolding around straightforward orchestration code
- Do not duplicate validation logic — extract to shared domain validators and compose
- Do not reject persistence operations only because a UI flow expects a field during submit; enforce those checks in application cubits/orchestration

