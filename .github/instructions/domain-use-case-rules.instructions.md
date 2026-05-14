---
description: "Use when creating or editing Domain use cases (*_use_case.dart). Enforces standardized use-case contracts, Watch/Get naming, and record-based input patterns."
applyTo: "lib/domain/**/*_use_case.dart"
---
# Domain Use Case Rules

- A use case is an orchestrator: coordinate repositories and domain transformations and validators, not UI or infrastructure details.

## Contract Selection (required)

- Implement exactly one contract from `domain/core/use_cases/use_case.dart`.
- Use `IStreamUseCase<Output>` for stream-based workflows without input.
- Use `IStreamUseCaseWith<Input, Output>` for stream-based workflows with input.
- Use `IUseCase<Output>` for one-shot `Future` workflows without input.
- Use `IUseCaseWith<Input, Output>` for one-shot `Future` workflows with input.

## Method Signatures

- For stream use cases, expose `subscribe(...)` as the read entrypoint and keep `reload()` and `refresh({required bool forceGet})` for refresh lifecycle.
- For one-shot use cases, expose `execute(...)` and return `Future<Payload<Output>>`.
- For `IUseCaseWith<Input, Output>` and `IStreamUseCaseWith<Input, Output>`, make input required and strongly typed; do not use optional wrapper arguments like `execute([Input? input])`.

## Naming Convention

- The use case name must express intent first (what business outcome or behavior it provides), not implementation details.
- Stream-based use cases must use `Watch*UseCase` names to signal reactive behavior.
- One-shot use cases should keep `Get*UseCase` naming when the intent is data retrieval.
- Do not introduce new stream-based retrieval use cases with `Get*UseCase` names.
- Similar-intent use cases should follow consistent verb patterns so intent is recognizable across features.

## Reuse by Intent

- Similar-intent use cases may share the same validator or reusable domain logic to avoid duplication.
- Extract repeated validation/decision logic into shared domain validators/helpers and compose them into use cases.
- Keep shared logic pure and domain-focused; avoid inheritance-heavy use-case hierarchies.
- Use cases remain orchestration entry points even when they reuse common validators/logic.

## Input Modeling

- For multi-parameter input, use a named Dart record as the `Input` type instead of creating dedicated wrapper classes.
- For single primitive/simple inputs (for example `bool`, `String`, `int`), pass the primitive directly as `Input`.
- Avoid `Map` or dynamic bundles as input.

## Output and Dependency Rules

- Return only `Payload<T>` or `StreamPayload<T>`; never expose raw `Future<T>`, nullable data, or transport DTOs. Returning void is allowed.
- Accept and return domain-level types wherever possible (Entities/Value Objects and validated primitives).
- Inject repository interfaces through constructor + `@injectable`; never instantiate dependencies inside the use case.
- Keep use cases stateless and deterministic; avoid mutable flags that change behavior across calls.
- Preserve failure information and fallback data through payload wrappers so Application layer can render reliable states.

## Validation Boundary Rules

- Do not enforce screen-flow required-field validation in create/update persistence use cases.
- Treat checks like "selection is required before Continue/Save" as Application-layer orchestration.
- Domain use cases may still perform domain-invariant validation that is globally true outside any single UI flow.

