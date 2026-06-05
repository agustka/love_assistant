---
name: know-the-code
description: >-
  Use this skill when investigating the love_assistant (package `la`) codebase —
  before making changes, answering architecture questions, tracing feature flows,
  or deciding where new code should live. Trigger whenever an agent needs to
  navigate the codebase, find a precedent, understand a convention, or trace how
  data moves through layers. Prefer this over general Flutter or Clean Architecture
  advice.
---

# Know the Code

A procedural guide for investigating this Flutter codebase before answering questions or making changes. Use the code as the source of truth.

## Handoff I/O Contract

- Primary input: the current caller prompt/request.
- Do not use `.codex/handoff/know-the-code.handoff.md` as implicit input for new investigations.
- Reuse prior handoff content only when continuation is explicitly requested and still in scope.
- Output mode is caller-selected: `direct` (default) or `handoff`.
- Write `.codex/handoff/know-the-code.handoff.md` only when the caller explicitly requests handoff output.
- For `direct` output, return findings in context and do not create/update handoff files.

---

## Investigation Steps

Follow these steps in order. Do not skip to an answer until you have concrete evidence.

### 1. Identify the feature area
Search for the most likely module, feature folder, or symbol name. Start broad, then narrow.

### 2. Find the concrete implementation
Locate the real file — not just a similarly named one. Read it and the surrounding files.

### 3. Trace the flow
For any feature question, trace through these layers in order (skip layers that are not relevant):

| Layer | Path pattern | What to look for |
|---|---|---|
| Presentation | `lib/presentation/<feature>/` | page, template (`La*Template`), organism (`La*Organism`), `BlocBuilder` wiring |
| Application | `lib/application/<feature>/` | Cubit (extends `BaseCubit`), state, action methods |
| Domain | `lib/domain/<feature>/` | repository interface, entity, value objects, (eventually) use cases |
| Infrastructure | `lib/infrastructure/<feature>/` | repository impl, service, DTO/model, caching, Supabase integration |
| Navigation/DI | `lib/presentation/core/app.dart`, `lib/setup.dart` | `PageName` enum, `MaterialApp.routes` map, `get_it` registrations |

### 4. Check usages
Before concluding how something is used, verify by searching for usages/references — not just reading the definition.

### 5. Compare with neighbors
Read a similar feature alongside the one you're investigating. If patterns differ, note which appears current or preferred. The wizard flow (`lib/application/wizard/` + `lib/presentation/wizard/`) is the most complete reference today.

### 6. State what is confirmed vs. inferred
Always distinguish between facts found in code and reasonable inferences from context.

---

## Architecture Quick Reference

**Dependency direction:** `Presentation → Application → Domain ← Infrastructure`

**Key conventions to verify in context:**
- DI: `get_it` + `injectable`; setup in `lib/setup.dart`; `getIt.init()` is async (`@preResolve` on `SharedPreferencesModule`)
- Cubits extend `BaseCubit` (`lib/application/core/base_cubit.dart`); states extend `Equatable`
- Domain wrappers: `Payload<T>`, `StreamPayload<T>`, `CacheWrapper<T>`, `Failure<T>` (all under `lib/domain/core/`)
- Value objects extend `ValueObject<T>` (`lib/domain/core/value_objects/value_object.dart`)
- Use-case interfaces live at `lib/infrastructure/core/use_cases/use_case.dart` (path is a code smell — they conceptually belong in domain)
- Navigation: plain `MaterialApp.routes` keyed by `PageName.<x>.route`; navigate with `App.navigatorKey.currentState?.pushNamed(...)`
- Design system lives under `lib/presentation/core/ui_components/` (Atomic Design: atoms → molecules → organisms → templates → pages), `La*` prefix
- Localization: generated `S` accessor and ARB files at `lib/presentation/core/localization/`
- One-shot events: `EventBus` (singleton) fired from cubits, consumed in UI via `LaEventBusListener<T>` (`lib/presentation/core/ui_components/la_event_bus_listener.dart`)
- Backend: Supabase via `supabase_flutter`; no Chopper, no GraphQL, no `json_serializable`/`freezed`

**Build environments:** `online`, `offline` (declared in `lib/setup.dart` as `InjectableEnv.online` / `InjectableEnv.offline`).

**Code generation:** `dart run build_runner build --delete-conflicting-outputs` for injectable/assets; `dart run intl_utils:generate` for localization. Do not edit `*.config.dart` or `messages_*.dart` directly.

---

## Answering Placement Questions

When asked where new code should go:

1. Identify which layer it belongs to (domain / application / infrastructure / presentation)
2. Identify which feature folder
3. Identify what type it should be (value object, entity, use case, Cubit, repository, service, model, page, organism, …)
4. Find the nearest existing implementation and use it as the template
5. Prefer consistency with local precedent over a cleaner but inconsistent structure

---

## Answering Format

If caller requests `direct` output (default), answer in context with:

- **Answer** — direct answer first
- **Evidence** — key files, classes, symbols, and what they prove
- **Project convention** — pattern used locally
- **Confirmed vs Inferred** — facts vs inference
- **Variations/Caveats** — uncertainty or competing patterns

If caller requests `handoff` output, write `.codex/handoff/know-the-code.handoff.md` using this structure:

- **Request/Question** — direct framing of what was asked
- **Findings** — key files, classes, symbols, and evidence
- **How it works** — concise flow through the layers
- **Project convention** — what pattern the codebase actually uses here
- **Confirmed vs Inferred** — clearly separate facts and inference
- **Variations/Caveats** — uncertainty, multiple patterns, generated code, missing evidence
- **Status** — `complete` or `needs-follow-up`
