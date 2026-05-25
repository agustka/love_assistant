# Pipeline Reference Tables

Referenced by `pipeline.md`. Do not use independently.

---

## Pre-flight Validation

Before starting any iteration, validate inputs:

1. `bdd.md` must parse successfully and contain `Work Type`
2. If `api.yaml` is present and not a placeholder → it must contain at least one valid path or schema definition
3. If `layout.md` is present and not a placeholder → it must contain information about how to approach the UI work
4. If `AC Scope` is present → all listed directories must be syntactically valid glob patterns
5. If any input is malformed → stop immediately with `status: blocked` and describe the malformation

If validation fails, do not proceed to layer selection. Record the issue and stop.

---

## Complexity Estimation

Before starting the first iteration of a `feature`, estimate complexity to calibrate expectations:

| Signal | Low (1-2 ACs, single layer) | Medium (3-5 ACs, 2-3 layers) | High (6+ ACs, all layers, cross-feature) |
|---|---|---|---|
| Expected iterations | 3-4 | 5-7 | 7-10 |
| Starting tier | cheap | cheap (escalate early if ambiguity) | medium |
| Human checkpoint | At completion | After implementation, before testing | After scaffold, after implementation, after testing |

Record the estimated complexity in the first iteration's `Justification` section. This is informational — it does not override decision rules but helps the operator anticipate effort.

---

## Migration Guidance (refactor sub-type)

When `bdd.md` describes a migration (e.g., "migrate X repository to streaming pattern"):

1. Run the **know-the-code agent** first to understand the current implementation and the target pattern
2. Scope layer selection to the layer being migrated (typically infrastructure) plus direct dependents if public signatures change
3. Run generative agents in targeted mode — regenerate only the migrated component using the target pattern, not the full layer
4. Existing tests are the behavioral equivalence oracle — they must pass without modification (testing agent runs in regression mode)
5. If existing tests fail, classify: if the migration changed a public API, update dependent layers in dependency order
6. After regression passes, run review scoped to migrated files only

---

## Iterative AC Development (additions to existing features)

When adding ACs to a feature that already has implementation on the branch:

- Use `AC Scope` to limit staleness evaluation to the affected directories
- Existing layer handoffs are reused if valid and not stale within the AC Scope
- Only layers affected by the new ACs are re-run; unchanged layers are preserved
- If the new AC requires a new entity/use-case that interacts with existing ones, run the know-the-code agent first to understand the current state, then scope the domain agent to additive changes only

---

## Agent Output Validation

After every agent delegation, validate the output before proceeding:

1. **Handoff exists** — the expected `.claude/handoff/<agent>.handoff.md` file was created or updated
2. **Handoff structure** — contains all required sections: summary, artifacts, invariants, gaps, status, routing signals
3. **Status is recognized** — value is one of the agent's declared status values
4. **Artifacts are real** — at least one artifact file path listed in the handoff actually exists on disk
5. **No rogue artifacts** — no `.md`/`.txt` files were created outside `.claude/handoff/`

If validation fails:
- If handoff is missing entirely → count as agent timeout (see Agent Timeout Policy)
- If handoff is malformed → re-run agent once with a note citing the malformation
- If rogue artifacts exist → delete them and log a warning

---

## Context Window Management

For complex features where accumulated handoffs + specs may exceed context limits:

1. **Feed handoffs selectively** — when delegating to an agent, include only the handoffs listed in that agent's Input section, not all handoffs
2. **Summarize iteration history** — if `coordination.plan.md` exceeds 200 lines, compact completed iterations into a one-line summary each (preserve the last 2 iterations in full detail)
3. **Scope compilation errors** — when passing errors to an agent for fixing, include only the errors relevant to that agent's layer, not the full `dart analyze` output
4. **Prefer targeted searches** — when running blast radius analysis, use specific class names rather than broad queries

---

## Cross-Feature Dependencies

When a new feature depends on domain constructs from another existing feature (e.g., reusing an entity or value object from a different feature directory):

1. The depending feature must **import**, not duplicate, the existing construct
2. The pipeline must not modify the existing feature's code — treat it as a read-only dependency
3. If the existing construct's API is insufficient for the new feature → record as blocking gap: `"cross-feature dependency: <existing feature>/<construct> — <what's missing>"`
4. The human must decide whether to extend the existing construct (separate scope) or create a new one

This prevents the pipeline from making changes with unpredictable blast radius across features.

---

## Greenfield Bootstrapping

When `work_type` is `feature`, no diff exists, and no handoffs exist (first iteration of a new feature):

Derive required layers entirely from specification presence:

| Specification present | Required layers |
|---|---|
| `bdd.md` only | domain, application |
| `bdd.md` + `api.yaml` | infrastructure, domain, application |
| `bdd.md` + `layout.md` | domain, application, UI |
| `bdd.md` + `api.yaml` + `layout.md` | infrastructure, domain, application, UI |

Domain and application are required for a new feature unless an explicit layer opt-out excludes them and no contradiction exists (see Explicit Layer Opt-Out Detection). Infrastructure and UI are required only when their corresponding specifications are present and not explicitly opted out.

After the first iteration produces handoffs, subsequent iterations use normal Layer Selection Rules.

---

## Handoff Staleness

A handoff is considered **stale** when the specifications it was built from have changed since it was produced.

Detection:

- compare the modification timestamp of each spec file (`bdd.md`, `api.yaml`, `layout.md`) against the modification timestamp of each handoff file
- if any spec file is newer than a handoff that depends on it → that handoff is stale

Spec-to-handoff dependency map:

| Spec file | Handoffs that depend on it |
|---|---|
| `bdd.md` | domain, application, UI, testing |
| `api.yaml` | infrastructure |
| `layout.md` | UI |

`api.yaml` is the infrastructure contract source for both API/network integrations and non-API adapters (for example: local storage, platform channels, device services).

A stale handoff is treated as **invalid** — the corresponding agent must be re-run.

This applies to `work_type: feature` only. For `refactor` and `bug`, staleness is not evaluated because those work types do not derive layers from specs.

### Staleness and Iterative AC Development

When developing iteratively on a single branch (adding 1-2 ACs per iteration without committing between iterations), `bdd.md` changes trigger staleness for all dependent handoffs. To prevent unnecessary re-runs of completed features:

**Option 1: Add an AC Scope field to bdd.md** (recommended for active iteration)

Specify which feature directories the CURRENT ITERATION's ACs apply to. Update AC Scope when moving to a new feature:

Iteration 1 — Search feature:
```markdown
---
Work Type: feature
AC Scope: lib/domain/search/*, lib/application/search/*, lib/presentation/search/*
---

## Feature: Payment Search

### AC: User searches payments by amount
...
```

Iteration 2 — Filter feature (new ACs only, search is done):
```markdown
---
Work Type: feature
AC Scope: lib/domain/filter/*, lib/application/filter/*, lib/presentation/filter/*
---

## Feature: Payment Search

### AC: User searches payments by amount
[AC from iteration 1 — still in bdd.md but not being modified]

## Feature: Payment Filtering

### AC: User filters payments by status
[NEW AC for iteration 2]
...
```

The pipeline will mark handoffs as stale ONLY within the AC Scope directories. Search feature handoffs (outside scope) are reused; filtering handoffs (in scope) are regenerated.

**Critical constraint**: ACs in `bdd.md` that are OUTSIDE the AC Scope must have working, committed implementation. They will not be regenerated, but tests will still run against them. This supports regression testing of prior iterations. If an out-of-scope AC's implementation is broken, it must be fixed in a separate TDD cycle with that AC back in scope.

**Option 2: Commit between iterations** (simpler if changes are stable)

After each iteration completes and tests pass, commit the feature code. The next iteration's new `bdd.md` changes will not trigger staleness across the entire codebase — the diff will be isolated to new feature directories, and the pipeline's diff analysis will scope correctly.

---

## Incomplete Handoff Resumption

When a handoff has status `incomplete` with a recorded gap that depends on another agent's output:

- identify the blocking dependency from the gap description
- if the dependency is now satisfied (the required handoff exists and is valid) → re-run the incomplete agent to resume from where it stopped
- if the dependency is still unsatisfied → run the dependency agent first

Known resumption patterns:

| Incomplete handoff | Gap | Dependency | Action |
|---|---|---|---|
| infrastructure (`incomplete`) | `"repository pending domain entities"` | domain handoff `complete` | re-run infrastructure agent |
| infrastructure (`incomplete`) | `"migration: awaiting target pattern confirmation"` | know-the-code output available | re-run infrastructure agent with pattern context |
| domain (`incomplete`) | `"cross-feature dependency: <feature>/<construct>"` | human resolves dependency | re-run domain agent after resolution |

The pipeline must check for resumable incomplete handoffs at every iteration, after evaluating all other rules.

---

## Layer Selection Rules

Determine required agents in the following order:

### Step 0 — Work type gate

- if `work_type` is `refactor` → skip to Diff analysis; do not apply specification gates for generative work
- if `work_type` is `refactor` and migration is detected (see Migration Detection in `pipeline.md`) → apply Diff analysis, then allow targeted generative work for the migrated layer only
- if `work_type` is `bug` → skip to testing agent first (see Pipeline Loop for bug); layer selection is deferred until failure classification

### Step 1 — Specification gates (feature only)

- if `layout.md` is present and contains a valid layout structure → UI layer required
- if `api.yaml` is present and contains a valid infrastructure contract (API/network OpenAPI slice or non-API adapter contract) → infrastructure layer required
- if `api.yaml` is present but contains only a placeholder message (no contract content) → infrastructure NOT required; skip placeholder file

### Step 1a — Placeholder detection

A specification file is considered a **placeholder** if:
- it exists but contains only plain text explanation/message with no structured content
- examples: "This change does not require...", "No API work needed", etc.
- placeholders are ignored in layer selection; they do not trigger their respective layers

### Step 1b — Explicit layer opt-out detection

Collect explicit opt-outs from specs before diff analysis:

- `bdd.md` supports a dedicated section:

```md
### Layer Opt-Outs
- infrastructure
- domain
- application
- ui
```

- `bdd.md` may also use explicit statements (case-insensitive), for example:
  - "no infrastructure changes needed" / "no api changes needed"
  - "no domain changes needed"
  - "no application changes needed"
  - "no ui changes needed" / "no presentation changes needed"
- `api.yaml` may opt out infrastructure by either:
  - placeholder message indicating no infrastructure contract work (API or adapter), or
  - explicit extension key: `x-layer-opt-out: [infrastructure]`

Opt-out effect:

- opted-out layers are removed from the required set
- handoffs for opted-out layers are ignored
- corresponding layer agents are skipped

Contradiction safety checks (opt-out is ignored if any condition is true):

- AC-scoped diff analysis shows file changes in that layer
- testing/review failure classification maps to that layer
- a blocking gap is owned by that layer
- dependency closure requires that layer for another still-required layer
- a Precedence Rule declares blocked state for missing required spec

AC-scoped diff analysis source priority:

1. explicit scope paths in `bdd.md` (when provided)
2. file paths referenced in `bdd.md` supporting context
3. fallback to full branch diff when scope cannot be derived

### Step 2 — Greenfield check (feature only)

- if no diff exists and no handoffs exist → apply Greenfield Bootstrapping table
- otherwise proceed to Diff analysis

Apply explicit opt-outs both before and after Greenfield Bootstrapping; then run contradiction safety checks before finalizing required layers.

### Step 3 — Diff analysis

- map changed files to layers using AC-scoped diff first:
    - derive AC scope using Step 1b source priority
    - if scope derivation fails, use full branch diff as fallback
    - when fallback is used, mark layer evidence as low-confidence and do not override explicit opt-outs without an additional signal (failure classification, blocking gap, or dependency closure)
- map scoped changed files to layers:
    - `lib/infrastructure/**` → infrastructure
    - `lib/domain/**` → domain
    - `lib/application/**` → application
    - `lib/presentation/**` → UI
    - `test/**` → testing (does not trigger layer agents, but marks testing handoff as stale)

### Step 4 — Dependency closure (only when a layer has no valid handoff)

- if domain is required and infrastructure handoff is missing/invalid (when `api.yaml` is present) → infrastructure is required
- if application is required and domain handoff is missing/invalid → domain is required
- if UI is required and application handoff is missing/invalid → application is required
- do not pull in a dependency layer if its handoff is already valid

Dependency closure can reactivate a previously opted-out dependency layer when required by another non-opted-out layer.

### Step 5 — Handoff gaps

- missing, invalid, or stale handoff for a required layer → agent required
- non-required layers are skipped

### Step 6 — Failures

- review/test failures override previous steps

Always select the minimal set of agents after applying all rules.

---

## Handoff Validity

A handoff is **valid** when: the file exists, contains summary/artifacts/invariants/gaps/status, has `status: complete`, and has no blocking gaps.

Special rules for `testing.handoff.md`:
- `status: scaffolded` is valid only before implementation layers complete. Once all required implementation handoffs are `complete`, treat `scaffolded` as incomplete → run testing agent in generative mode.
- `status: scaffolded` with blocking gaps (untestable ACs) → pipeline blocked; require spec update before proceeding to implementation.

| Condition | Action |
|---|---|
| Missing or invalid for a required layer | Trigger that agent |
| Malformed | Treat as invalid; trigger agent with a note |
| Non-required layer | Ignore |
| Opted-out layer with valid opt-out | Skip; do not enforce |

---

## Stop Conditions and Agent Timeout Policy

### Stop Conditions

Stop and escalate (mark `blocked`, require human intervention) when:
- Maximum iterations reached (5)
- Same failure signature (source + rule/test ID + file path) occurs in 2 consecutive iterations
- Total blocking issue count does not decrease over 2 consecutive iterations

### Agent Timeout Policy

- After 1 failed attempt (no handoff produced) → retry once
- After 2 failed attempts → mark blocked: `"agent timeout: <agent name>"`; do not retry further

---

## Delivery Efficiency Policy

When implementation is complete and there are no blocking failures, prefer fast delivery over agent self-audit:

- do not schedule additional review-style analysis passes only to re-check code generated in the same run
- do not run repeated diff-analysis loops once required layer handoffs are complete and consistent
- run testing/review agents only when explicitly requested by the user, when a blocking failure is present, or when a prior handoff is invalid/stale/incomplete
- if uncertainty remains but there is no blocker, record it as a concise handoff note and stop; defer deep validation to human follow-up
- enforce artifact discipline: agent coordination artifacts must live only in `.claude/handoff/`; reject standalone `.md`/`.txt` reports elsewhere

The default terminal behavior is: generate required changes, satisfy required handoff completion, and stop without extra self-review iterations.

---

## Ownership Mapping

Use the following mapping when selecting agents:

- missing infrastructure handoff → infrastructure agent
- missing domain handoff → domain agent
- missing application handoff → application agent
- missing UI handoff → UI agent

- specification gaps:
    - model or invariant gaps → domain agent
    - use-case or flow orchestration gaps → application agent
    - if mixed → domain agent first, then application agent
- UI-reported application gaps (missing cubit method, missing state field, missing event message, missing cubit, missing loading state, missing error handling) → application agent
- infrastructure contract mismatches (API or adapter) → infrastructure agent
- architecture violations → responsible layer agent
- UI violations (only when `layout.md` is present) → UI agent
- UI violations (when `layout.md` is absent) → blocked (see Precedence Rules)

- test failures:
    - domain logic → domain agent
    - state/flow issues → application agent
    - UI behavior → UI agent
    - test infrastructure (driver/builder compilation errors, missing offline clients) → testing agent

- test artifact ownership:
    - any requested creation/modification/deletion under `test/**` → testing agent only
    - other layer agents must not be selected to implement test-file changes; they should report testing-owned gaps instead

Always select the closest responsible layer.

When multiple agents are selected from failures in the same iteration, run them in dependency order:
infrastructure → domain → application → UI.
Do not run them in parallel.

---

## Model Escalation Rules

The pipeline agent is the **sole authority** for model tier assignments. Layer agents are model-agnostic; they emit `routing_signals` but never select their own model. The `suggested_tier` in routing signals is advisory only — the pipeline must not blindly honor it; advisory values that would increase cost are validated against escalation triggers before acceptance.

### Tier Map

| Tier | Model class | Cost profile | When to use |
|---|---|---|---|
| `cheap` | Sonnet-class | Lowest | Default first attempt; mechanical/well-scoped generation |
| `medium` | Sonnet+ / stronger reasoning | Moderate | Complexity ≥ 4, confidence < 0.65, any ambiguity flags |
| `strong` | Opus-class | Highest | Repeated identical failures, cross-layer cascades, architectural review mismatches |

### Escalation Triggers (deterministic)

| Trigger | Resulting tier | Condition |
|---|---|---|
| First attempt, no escalation signal | `cheap` | Always the default starting point |
| `complexity_score >= 4` | at least `medium` | Assessed by the agent or inferred from spec size |
| `confidence < 0.65` | at least `medium` | Agent reports low confidence in result correctness |
| Non-empty `ambiguity_flags` | at least `medium` | Any of: `missing_spec`, `conflicting_behavior`, `cross_layer_dependency` |
| Same `failure_signature` on attempt 2+ | `strong` | Identical failure repeated after a previous fix attempt |
| Cross-layer cascade | `strong` | Failures span 2+ layers in the same iteration |
| Review finds architectural/spec inconsistency | `strong` | Not simple syntax/lint — structural spec mismatch |

### Retry and Escalation Limits

| Tier | Max attempts before escalation or block |
|---|---|
| `cheap` | 1 (escalate to `medium` on failure) |
| `medium` | 2 (escalate to `strong` on repeated same-signature failure) |
| `strong` | 2 (mark `blocked` — require human intervention) |

After exhausting `strong` tier retries, the pipeline MUST stop and record:
`"blocked: max model escalation reached — <failure_signature>"`

### De-escalation Rules

After a successful `strong`-tier run:
1. The next **independent** agent task (different agent, no dependency on the just-fixed artifact) reverts to `cheap`.
2. If the next task is in the **same agent** or depends directly on the just-fixed output, use `medium` as a safety net for one run, then drop to `cheap`.
3. Risk flags that **prevent** de-escalation:
   - `ambiguity_flags` still non-empty for the active feature
   - `complexity_score >= 4` persists for the next task
   - Open issues with `severity: blocking` reference the same layer

### Routing Signals Contract (layer agents)

Every layer agent handoff must include a `routing_signals` block (appended to the handoff markdown):

```yaml
## Routing Signals
complexity_score: <1-5>
confidence: <0.0-1.0>
ambiguity_flags: [<flag>, ...] | []
failure_signature: "<stable identifier>" | null
suggested_tier: cheap | medium | strong | null
```

Field definitions:

| Field | Type | Description |
|---|---|---|
| `complexity_score` | 1–5 | Local task complexity: 1=trivial edits, 2=single-file generation, 3=multi-file with clear spec, 4=cross-concern/ambiguous, 5=cross-layer redesign |
| `confidence` | 0.0–1.0 | Agent's self-assessed probability that its output is correct and complete |
| `ambiguity_flags` | list | Known ambiguity categories: `missing_spec`, `conflicting_behavior`, `cross_layer_dependency` |
| `failure_signature` | string or null | Stable identifier for a failure (e.g., `"compile:entity_constructor_mismatch"`, `"test:ac2_assertion_null"`) — enables same-failure detection across attempts |
| `suggested_tier` | enum or null | Advisory hint to pipeline; **never binding** |

Agents that do not yet emit `routing_signals` are treated as: `complexity_score: 2, confidence: 0.8, ambiguity_flags: [], failure_signature: null, suggested_tier: null` (safe defaults, cheap tier).

### Cost Guardrails

- The pipeline must log every tier decision in `coordination.plan.md` → `Model Routing Log`
- `strong` tier must never be used without an explicit escalation trigger logged
- If `strong` tier is used 3+ times in a single pipeline invocation, log a warning: `"cost alert: repeated strong-tier usage — review spec clarity"`
- Total pipeline budget awareness: the pipeline may add a `## Cost Summary` section to `coordination.plan.md` tracking cumulative tier usage per invocation (optional for v1, recommended for observability)

