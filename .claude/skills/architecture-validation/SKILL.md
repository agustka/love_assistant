---
name: architecture-validation
description: >-
  Validate that code changes respect the project architecture: layer
  boundaries, dependency direction, DI/navigation patterns, and the
  presentation conventions defined in the layer CLAUDE.md files.
tools: []
---

## Purpose

Use this skill to validate architectural correctness of changes in this repository.

Focus on:

- layer boundaries (`presentation`, `application`, `domain`, `infrastructure`)
- dependency direction and cross-layer imports
- DI and environment wiring consistency
- navigation and state-management patterns

---

## Quick Architecture Survey (Project-Specific)

### Layer structure (feature-sliced)

Primary folders under `lib/`:

- `lib/presentation/` — UI, routing integration, atomic design components (atoms/molecules/organisms/templates live under `lib/presentation/core/ui_components/`)
- `lib/application/` — Cubits (extend `BaseCubit`), orchestration, app flow
- `lib/domain/` — entities, value objects, repository interfaces, shared domain abstractions
- `lib/infrastructure/` — repositories, services, models, cache, external integrations, **and** use case interfaces (`lib/infrastructure/core/use_cases/use_case.dart` — see note below)

Key references:

- `lib/presentation/core/app.dart` — `App` widget + `PageName` enum + `MaterialApp.routes` map
- `lib/application/core/base_cubit.dart` — `BaseCubit<T>` base class
- `lib/setup.dart` / `lib/setup.config.dart` — DI setup
- `CLAUDE.md` files under `lib/application/`, `lib/domain/`, `lib/infrastructure/`, `lib/presentation/`, and `test/`

### Intended dependency direction

`Presentation → Application → Domain ← Infrastructure`

### Known existing exceptions

- `IUseCase`/`IUseCaseWith`/`IStreamUseCase`/`IStreamUseCaseWith` are declared at `lib/infrastructure/core/use_cases/use_case.dart` even though they belong to the domain conceptually. The interfaces themselves only depend on `Payload`/`StreamPayload` from `lib/domain/`, so usage is fine, but the path is a code smell worth flagging if changed.

Treat these as existing debt unless the change makes the coupling worse.

### DI and environment model

- DI is based on `get_it` + `injectable`
- Setup entrypoint: `lib/setup.dart` — `appSetup()` calls `await getIt.init()` (async because `SharedPreferencesModule` uses `@preResolve`)
- Generated registrations: `lib/setup.config.dart`
- Environments: `InjectableEnv.offline`, `InjectableEnv.online`
- Modules: `EventBusModule`, `SupabaseModule`, `SharedPreferencesModule`

### Navigation model

- Plain `MaterialApp.routes` map keyed by `PageName.x.route`
- `PageName` enum lives in `lib/presentation/core/app.dart`
- Navigation is done via `App.navigatorKey.currentState?.pushNamed(...)` / `pushReplacementNamed(...)` directly
- There is **no** `Navigation` cubit/service, `RouteLink`, `NamedRoute`, or `RouteArguments` in this codebase

### Enforced architecture conventions

Source of truth lives in `CLAUDE.md` per layer:

- `lib/application/CLAUDE.md`
- `lib/domain/CLAUDE.md`
- `lib/infrastructure/CLAUDE.md`
- `lib/presentation/CLAUDE.md`
- `test/CLAUDE.md`
- Top-level `CLAUDE.md` for Effective Dart conventions

There is no static analysis script enforcing atomic-design rules in this project (no equivalent of `AtomicDesignRule`).

---

## Validation Procedure

### 1. Scope only changed files

Identify files touched by the change and classify by layer.

### 2. Validate layer placement

For each new/modified symbol, confirm it belongs to the folder/layer responsibilities described in the CLAUDE.md files. Flag violations such as:

- UI widgets or route definitions outside `presentation`
- Supabase / HTTP / platform details outside `infrastructure`
- business invariants moved out of `domain`
- Cubit logic placed in `presentation`

### 3. Validate dependency direction and coupling

Check imports in changed files for new cross-layer dependencies:

- if a new dependency follows the intended direction, accept
- if it adds cross-layer coupling, classify as:
  - **violation** when it breaks explicit layer rules
  - **risk** when it extends existing legacy coupling

### 4. Validate presentation atomic-design constraints

For `lib/presentation/**` changes:

- pages must use at least one atomic design template; templates accept only definitions, organisms, and molecules (never atoms or raw Flutter widgets)
- pages build definitions/organisms/molecules from state and pass them into the template — no atoms or raw layout widgets composed directly at page level
- design tokens from `LaTheme` / `LaPadding` etc. instead of hardcoded values
- no `EdgeInsets`/`SizedBox` at page level — that's a template/organism concern

Source: `lib/presentation/CLAUDE.md`.

### 5. Validate Cubit and DI patterns

For `lib/application/**` changes:

- Cubits extend `BaseCubit`
- Dependencies are constructor-injected (except `getIt<EventBus>()` and `getIt<IPollAndDebounce>()`)
- Stream subscriptions are cleaned up in `close()`
- Cubits emit immutable state via `copyWith`

### 6. Validate infrastructure boundaries

For `lib/infrastructure/**` changes:

- Model/repository/service separation
- External API / persistence stays in infrastructure
- No UI/application workflow logic leaks in
- All model (`*Model`) fields are nullable, and the type is JSON-serializable (`@JsonSerializable`)
- `@InjectableEnv.online`/`.offline` appears ONLY on boundary classes (services, client providers, stores). A repository carrying an env annotation, or any `Offline*Repository` file, is a violation — flag it. The online/offline split belongs at the boundary; the real repository must run on top of the offline boundary
- Every `@InjectableEnv.online` class has a paired `.offline` implementation for the same interface (and vice versa)

### 7. Validate domain integrity

For `lib/domain/**` changes:

- Entities composed of value objects or other entities, never raw primitives and never nullable fields
- Value objects extend `ValueObject<T>`
- No imports from `presentation`/`application`/`infrastructure` (other than the known use-case-interface path exception above)

---

## Decision Rules

Classify findings as:

- **violation** — change contradicts an explicit layer rule from a CLAUDE.md file
- **risk** — change increases existing cross-layer coupling
- **ok** — change is consistent with current project conventions

---

## Output Contract

Return findings as:

- `violations`: []
- `risks`: []
- `accepted_deviations`: []

Each finding must include:

- description
- changed file reference
- violated/related rule reference
- recommended action

If no issues are found, state:

- `No architecture violations found in changed scope.`
- `Residual risk:` (if any) due to legacy coupling patterns.
