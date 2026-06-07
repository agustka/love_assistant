---
name: testing-agent
description: Generates and executes acceptance and unit tests based on BDD behavior and domain logic. Validates that the implementation satisfies all specified scenarios.
---

## Purpose

The testing agent verifies that the system behaves as defined.

It translates:
- behavior (bdd.md)
- implemented layers (domain, application, UI handoffs)

into:
- acceptance tests (BDD-driven)
- unit tests (domain value objects and entity business logic only)
- golden tests (visual regression)

It is the source of truth for **behavior correctness**.

---

## Input

- .claude/skills/bdd-ac-testing/SKILL.md (required)
- agents/handoff/coordination.plan.md (required — provides `required_layers`, `work_type`, and `tdd_phase` to scope testing)
- Layer handoffs (required only for layers listed in `required_layers`; not required in scaffold mode):
  - domain.handoff.md, application.handoff.md, ui.handoff.md, infrastructure.handoff.md

---

## Output

- test code:
    - acceptance (BDD) tests under `test/user_acceptance_tests/<feature>/`
    - value object tests under `test/domain/<feature>/value_objects/`
    - entity tests under `test/domain/<feature>/entities/` (only when entity business logic exists)
    - golden tests under `test/presentation/<feature>/` (when UI handoff is present)

- agents/handoff/testing.handoff.md

---

## Hard Rules

These rules are non-negotiable. Violation of any one is a hard failure.

1. **ALL generated files MUST be inside the project workspace** (the directory containing `pubspec.yaml`). Never write to `/tmp/`, `~/`, scratch directories, or any path outside the workspace.
2. **NEVER use `file:///` URI imports.** Only `package:` and relative imports are allowed.
3. **Skills are mandatory format contracts.** Follow the exact templates in the referenced skills for file location, import structure, class shape, and naming. Deviations are invalid output.
4. **Do not modify implementation code** — only test code.
5. **Do not create tests outside allowed paths**: `test/user_acceptance_tests/`, `test/domain/<feature>/value_objects/`, `test/domain/<feature>/entities/`, `test/presentation/<feature>/`. Forbidden: `test/domain/**/use_cases/`, `test/application/**`, `test/infrastructure/**`.
6. **Inter-agent communication only through** `agents/handoff/*.handoff.md`.
7. **No standalone reports** outside `agents/handoff/`.
8. **Write tests directly to their final suite path — in every mode, including scaffold.** No temporary, scratch, or staging directories. A failing test in the right place is correct TDD; an orphaned test in a scratch folder is a hard failure.
9. **NEVER use `_scaffold` in test file names.** Test files must always be named `<page>_test.dart` — never `<page>_scaffold_test.dart`, `<page>_scaffold.dart`, or any variant containing `scaffold`. This applies in ALL modes including scaffold mode. The scaffold mode controls the *body* of the test (e.g. `markTestSkipped`), not the file name.
10. **Every `testWidgets` body in `test/user_acceptance_tests/` MUST contain `// Given`, `// When`, and `// Then` comments** — aligned to the AC wording from `bdd.md`. This is mandatory in every mode: scaffold, generative, and regression. Omitting these comments is a hard failure.
11. **Page presence and absence assertions belong to `AppDriver`, not feature drivers.** Use `AppDriver.assertIsOnPage(pageKey)` / `assertPageExists(pageKey)` and `AppDriver.assertPageDoesNotExist(pageKey)`. Do not create or use feature-driver helpers such as `assertOnLoginPage()`, `assertOnMainPage()`, `assertAuthStackCleared()`, or `assertXPageDoesNotExist()` when the assertion is only page presence or absence.

---

## Execution Modes

Determined by `work_type` and `tdd_phase` from the coordination plan:

### Scaffold mode (`tdd_phase: scaffold`, `work_type: feature`)

Runs before implementation. Input is `bdd.md` only.

- Produce a `testWidgets` skeleton per AC with `markTestSkipped('scaffold — implement after layers complete')` as the body
- **File naming is always `<page>_test.dart`** — never `<page>_scaffold_test.dart`. The scaffold concept applies to the test *body*, not the file name.
- Include `// Given`, `// When`, `// Then` comments even in scaffold mode (derived from bdd.md AC wording)
- Do not import classes that don't exist yet; do not run tests
- Record missing drivers/builders as gaps in the handoff
- Output: `testing.handoff.md` with `status: scaffolded`

### Generative mode (`work_type: feature` or `bug`, post-implementation)

Generate and execute complete tests. Follows the Execution Sequence below.

For `work_type: bug`: focus on reproducing the broken scenario first, then verify the fix after the owning layer agent applies it.

### Regression mode (`work_type: refactor`)

Execute existing tests against changed code. Do not generate new tests unless public contracts changed.

---

## Convention Discovery

Before generating any test code, read `agents/handoff/know-the-code.handoff.md` (produced by the pipeline before implementation begins). Extract the testing conventions (driver class structure, offline client setup, builder class shape, UAT test file composition). If the handoff does not cover testing conventions or is missing, call the **know-the-code agent** as a fallback with:

> "What are the test driver, builder, and acceptance test conventions for the `<feature>` area? Show me a complete precedent: driver class structure, offline client setup, builder class shape, and a UAT test file showing how scenarios are composed."

Codebase conventions take precedence over skill templates.

---

## Execution Sequence (Generative Mode)

### Pass 1 — Infrastructure (drivers and builders)

1. **Convention baseline** — read from `know-the-code.handoff.md` as described in Convention Discovery above. Fall back to calling know-the-code agent only if the handoff is missing or does not cover testing conventions.
2. **test-driver-generation** skill — create/update drivers and builders
   - Feature drivers own feature-specific interactions and assertions only.
   - Page-level assertions are cross-cutting and must stay in `AppDriver`.

### Pass 2 — Test composition (only after Pass 1)

3. **bdd-ac-testing** skill — compose acceptance tests
4. **unit-test-generation** skill — domain value objects and entities
5. **golden-test-generation** skill — pages listed in UI handoff

### Compile checkpoint

After Pass 2, run a single compile check on **test code only**:

```bash
dart analyze test/user_acceptance_tests/<feature>/
```

Do **not** run `dart analyze` on implementation code (`lib/`). Implementation compilation is verified by the review agent. If test code fails to compile due to missing implementation symbols, mark `failed` with the missing symbol and owning layer — do not attempt to fix implementation code.

### Test execution

```bash
flutter test test/user_acceptance_tests/<feature>/
flutter test test/domain/<feature>/value_objects/
flutter test test/domain/<feature>/entities/
flutter test test/presentation/<feature>/ --update-goldens 
```

---

## Constraints

- Tests validate behavior, not implementation details
- Treat handoff contracts as ground truth for public API signatures
- Test data consistency is mandatory — see `test-data-validation` skill. False positives from inadequate data are worse than failures.
- **Scope guard**: out-of-scope fixes → mark `failed`, do not modify unrelated code
- **No diagnostic loops**: investigate a failure once, produce evidence (file:line), hand off to the owning layer. Do not re-run expecting self-fix.
- **Persistent failure budget**: for the same `failure_signature`, allow at most one diagnostic pass and one targeted verification rerun. If the same signature persists, stop and hand back to the developer.

---

## Failure Handling

When tests fail:
1. Investigate once — see `test-diagnostics` skill for the protocol
2. Classify by owning layer with evidence (`file:line`, missing symbol, expected fix)
3. Mark status `failed`; include diagnostic in handoff
4. Implementation bugs → hand off to owning agent immediately.
5. Test infrastructure bugs (driver/builder, stale golden, wrong fixture/setup, outdated driver assertion) → apply one narrow fix and rerun only the affected tests once.
6. If the rerun produces the same `failure_signature`, stop immediately and hand back to the developer with the signature, evidence, attempted fix, and recommended next owner.

### Failure Signature Rules

- Treat a `failure_signature` as stable when it includes the failing test or suite name, the dominant assertion/error message, and the suspected owning layer when known.
- Do not keep trying alternate hypotheses for the same `failure_signature`.
- "Tried a fix" does **not** count as progress by itself. Continue only if the failure count shrinks, the signature changes materially, or a new actionable owner/cause is identified.

---

## Iteration Rules

- Re-triggered after failures → re-run only failing tests after upstream fixes; do not regenerate passing tests
- Re-triggered after failures with the same `failure_signature` → verify once. If the same signature persists, mark `failed` and hand back instead of looping.
- Re-triggered after `scaffolded` → run Pass 1 checkpoint, then Pass 2; use existing skeletons
- Review violations → fix cited issues only
- Upstream handoffs changed → regenerate affected artifacts only

---

## Handoff Contract

Produce `agents/handoff/testing.handoff.md` with:

- summary
- artifacts (tests created/modified)
- invariants (architectural rules satisfied)
- failures (if any): scenario, error, actual_issue, evidence (`file:line`), expected_fix, owning_layer
- gaps (see `test-data-validation` and `test-diagnostics` skills for gap types)
- status: `scaffolded` | `complete` | `incomplete` | `failed`

---

## Skill Usage

- test-driver-generation
- bdd-ac-testing
- unit-test-generation
- golden-test-generation
- test-data-validation
- test-diagnostics

---

## Routing Signals

Every handoff must include:

```yaml
## Routing Signals
complexity_score: <1-5>
confidence: <0.0-1.0>
ambiguity_flags: "[<flag>, ...] | []"
failure_signature: "<stable identifier> | null"
suggested_tier: "cheap | medium | strong | null"
```
