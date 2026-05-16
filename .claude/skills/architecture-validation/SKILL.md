---
name: architecture-validation
description: >-
  Validate that code changes in Channels.Flutter.Components respect the project
  architecture: layer boundaries, dependency direction, DI/navigation patterns,
  and enforced presentation conventions.
tools: []
---

## Purpose

Use this skill to validate architectural correctness of changes in this repository.

Focus on:

- layer boundaries (`presentation`, `application`, `domain`, `infrastructure`)
- dependency direction and cross-layer imports
- DI and environment wiring consistency
- navigation and state-management patterns
- architecture rules enforced by repository instructions and static checks

---

## Quick Architecture Survey (Project-Specific)

### Layer structure (feature-sliced)

Primary folders under `lib/`:

- `lib/presentation/` - UI, routing integration, atomic design components
- `lib/application/` - Cubits (`IsbCubit`-based), orchestration, app flow
- `lib/domain/` - entities/value objects/use cases and shared domain abstractions
- `lib/infrastructure/` - repositories/services/models/cache and external integrations
- `lib/core/` - cross-cutting utilities

Key references:

- `lib/presentation/core/app.dart`
- `lib/application/core/cubit/isb_cubit.dart`
- `lib/domain/core/navigation/named_route.dart`
- `lib/infrastructure/**`

### Intended dependency direction (guideline)

Expected direction used by project guidance:

`Presentation -> Application -> Domain <- Infrastructure`

Reference:

- `.claude/skills/know-the-code/SKILL.md`

### Actual architecture reality in this codebase

The codebase contains deliberate and legacy exceptions to strict clean layering.

Observed examples:

- `domain` imports `presentation` (`lib/domain/core/navigation/named_route.dart`)
- `domain` imports `application` (`lib/domain/core/navigation/route_link.dart`)
- `domain` imports `infrastructure` in multiple use cases/entities
- `application` imports `presentation` and `infrastructure` in many cubits

Treat these as **existing architecture debt / established exceptions** unless the change introduces new or wider coupling.

New violations must only be flagged if they introduce new or expanded coupling.

Existing patterns must not be flagged unless they are made worse.

### DI and environment model

- DI is based on `get_it` + `injectable`
- setup entrypoint: `lib/setup.dart`
- generated registrations: `lib/setup.config.dart`
- environments: `InjectableEnv.offline`, `InjectableEnv.online`

### Navigation model

- route registry and creators live in `lib/domain/core/navigation/named_route.dart`
- route intents are represented by `RouteLink` in `lib/domain/core/navigation/route_link.dart`
- runtime route generation and navigator wiring happen in `lib/presentation/core/app.dart`

### Enforced architecture conventions

Repository guidance and checks:

- `.claude/instructions/presentation-and-atomic-design.instructions.md`
- `.claude/instructions/application-layer-rules.instructions.md`
- `.claude/instructions/domain-layer-rules.instructions.md`
- `.claude/instructions/infrastructure-layer-rules.instructions.md`
- `scripts/static_code_analysis/static_code_analysis.py`
- `scripts/static_code_analysis/rules/atomic_design_rule.py`
- `scripts/static_code_analysis/rules/no_direct_event_bus_usage_rule.py`

---

## Validation Procedure

### 1. Scope only changed files

Identify files touched by the change and classify by layer.

### 2. Validate layer placement

Only validate placement for new or modified code, not untouched existing structures.

For each changed symbol/class, confirm it belongs to the folder/layer responsibilities.

Flag violations such as:

- UI widgets or route builders outside `presentation`
- HTTP/database/platform details outside `infrastructure`
- business invariants moved out of `domain`
- Cubit/application flow logic placed in `presentation`

### 3. Validate dependency direction and coupling

Check imports in changed files for new cross-layer dependencies.

Rules:

- if a new dependency follows the intended direction, accept
- if it adds cross-layer coupling, classify as:
  - **violation** when it breaks explicit layer rules
  - **risk** when it extends existing legacy coupling without clear need

### 4. Validate presentation atomic design constraints

For `lib/presentation/**` changes, confirm compliance with atomic composition constraints and avoid direct low-level widget composition where disallowed.

Use repository rule behavior as source of truth:

- `scripts/static_code_analysis/rules/atomic_design_rule.py`

### 5. Validate Cubit and DI patterns

For `lib/application/**` changes:

- Cubits extend `IsbCubit`
- dependencies are constructor-injected (with project exceptions for approved cross-cutting singletons)
- lifecycle/subscription cleanup patterns are preserved

### 6. Validate infrastructure boundaries

For `lib/infrastructure/**` changes:

- model/repository/service separation remains intact
- external API and persistence concerns stay in infrastructure
- no UI/application workflow logic leaks in

### 7. Validate domain integrity

For `lib/domain/**` changes:

- domain types keep invariant-oriented logic
- avoid introducing new unnecessary dependencies on presentation/application/infrastructure
- if unavoidable, explicitly mark as architecture risk with rationale

---

## Decision Rules

Classify findings as:

- **violation**
  - change contradicts declared layer rules in `.claude/instructions/*_layer_rules.instructions.md`
  - change introduces clearly avoidable architectural boundary break
- **risk**
  - change increases existing cross-layer coupling in already mixed areas
  - change is technically valid but increases complexity, fragility, or test burden
- **ok**
  - change is consistent with current project conventions and does not worsen boundaries

---

## Output Contract

Return findings in a structured form:

- `violations`: []
- `risks`: []
- `accepted_deviations`: []

accepted_deviations should only include:
- cases where deviation is intentional and justified
- cases where fixing would cause disproportionate impact

Do not use accepted_deviations to hide violations.

Each finding must include:

- description
- changed file reference
- violated/related rule reference
- recommended action (fix now / follow-up / accept with rationale)

If no issues are found, explicitly state:

- `No architecture violations found in changed scope.`
- `Residual risk:` (if any) due to legacy coupling patterns.

