---
description: "Use when creating or editing Domain use cases (*_use_case.dart). Enforces standardized use-case contracts, Watch/Get naming, and record-based input patterns."
applyTo: "lib/domain/**/*_use_case.dart"
---
# Domain Use Case Rules

A use case is an orchestrator: coordinate repositories and domain transformations, not UI or infrastructure details.

## Contract Selection (required)

Implement exactly one contract from `lib/domain/core/use_cases/use_case.dart`:

| Interface | Use when |
|---|---|
| `IUseCase<Output>` | One-shot, no input |
| `IUseCaseWith<Input, Output>` | One-shot, with input |
| `IStreamUseCase<Output>` | Live stream, no input |
| `IStreamUseCaseWith<Input, Output>` | Live stream, with input |

## Method Signatures

- Stream use cases: `subscribe(...)` as the read entry point; `reload()` and `refresh({required bool forceGet})` for refresh lifecycle.
- One-shot use cases: `execute(...)` returning `Future<Payload<Output>>`.
- Input must be strongly typed — no optional wrapper arguments like `execute([Input? input])`.

## Naming Convention

| Prefix | Meaning | Interface |
|---|---|---|
| `Watch` | Live stream | `IStreamUseCase` / `IStreamUseCaseWith` |
| `Get` | Single fetch (read) | `IUseCase` / `IUseCaseWith` |
| `Create` | POST / create | `IUseCaseWith` |
| `Update` | PUT / update | `IUseCaseWith` |
| `Delete` | DELETE | `IUseCaseWith` |
| `Set` | Write a preference/config | `IUseCaseWith` |
| `Accept` | Accept terms / confirm action | `IUseCaseWith` |
| `RefreshDataAfter` | Orchestrate cache invalidation post-mutation | `IUseCaseWith` |

Do not introduce new stream-based retrieval use cases with `Get*UseCase` names.

## Input Modeling

- Multi-parameter input: use a named Dart record (`typedef FooInput = ({TypeA a, TypeB b})`).
- Single primitive input: pass directly (`IUseCaseWith<bool, Output>`).
- No input: use `IUseCase<Output>` or `IStreamUseCase<Output>`.
- Never use `Map` or `dynamic` bundles as input.

## Combined Streams

- Inject repositories directly — **not** other use cases.
- Use `combineTwoLatestStreams` or `combineThreeLatestStreams` from `lib/domain/core/streams/wrapper.dart`.
- Write a `_combiner` method: iterate payloads in priority order — **first non-success state wins**.
- Only return `StreamPayload.success(combined)` when all sources delivered successfully.
- `refresh` and `reload` must fan out to all injected repositories via `Future.wait`.

## Composite Use Cases (mutable state)

When a use case must own mutable state (subscriptions, `BehaviorSubject`):
- Add a `dispose()` method that cancels subscriptions and closes subjects.
- The cubit that owns the use case calls `dispose()`.
- Do not use `const` constructor.
- Prefer composing at the cubit level over injecting use cases into other use cases.

## Output and Dependency Rules

- Return only `Payload<T>` or `StreamPayload<T>` — never expose raw `Future<T>`, nullable data, or transport DTOs. Returning `void` is allowed.
- Inject repository interfaces through constructor + `@injectable`; use `const` constructor when no mutable state.
- Never instantiate dependencies inside the use case body.
- Catch exceptions and return `Payload.failure(...)` — never throw.
- Accept and return domain-level types (entities, value objects, validated primitives).

## Validation Boundary Rules

- Do not enforce screen-flow required-field validation in create/update persistence use cases.
- Treat checks like "selection is required before Continue/Save" as Application-layer orchestration (cubit).
- Domain use cases may still perform domain-invariant validation that is globally true outside any single UI flow.
