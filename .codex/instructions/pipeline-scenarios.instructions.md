# Pipeline Usage Scenarios

This document walks through the four main scenarios and how the pipeline handles them.

---

## Scenario 1: Full BDD User Story (Many ACs, All Layers)

**Setup**: User writes `bdd.md` with 5+ acceptance criteria covering a complete feature (e.g., foreign transfer: search bank, select, validate, confirm).

**Flow**:
1. Pipeline scaffolds test skeletons (`tdd_phase: scaffold`) from BDD scenarios — detects any spec ambiguities early
2. Implements layers in dependency order: **infrastructure** (API models, service) → **domain** (entities, use cases) → **application** (cubits, state) → **ui** (pages)
   - Each layer:
     - Calls `know-the-code` agent to establish conventions from codebase
     - Generates code
     - Runs compile checkpoint (`dart analyze`)
     - Only if clean, updates handoff with `status: complete`
3. **Testing** agent fills in test bodies, runs full test suite end-to-end
4. **Review** agent validates against specifications and architecture (only if tests pass)
5. If any layer fails: pipeline re-routes with exact error details; agent applies targeted fix (read errors, fix single issue, re-check) 
6. Loop until all tests pass and review clears

**Advantages**:
- TDD scaffold detects spec issues before any implementation
- Full context for each layer (all other layers available)
- Tests validate integration across layers
- Fast feedback on failures (error details passed to re-triggered agent)

---

## Scenario 2: Iterative Feature Development (Multiple Rounds)

**Setup**: User develops a feature in multiple rounds. Each round replaces `bdd.md` entirely with updated ACs (not appended), commits the changes locally, and invokes the pipeline again.

**Example workflow**:

Round 1: User writes `bdd.md` with AC1 (search functionality), runs pipeline, commits.
```bash
git commit -m "AC1: User searches payments by amount"
```

Round 2: User updates `bdd.md` to replace AC1 with AC1 + AC2 (added filtering), commits, runs pipeline again.
```bash
git commit -m "AC2: User filters payments by status"
```

**Pipeline behavior**:
- Each invocation reads the current `bdd.md` state
- Staleness is evaluated fresh: handoffs older than `bdd.md` are regenerated
- Between-commit implementation persists in git
- Tests run against all ACs in current `bdd.md` (regression + new)

**Use AC Scope for selective regeneration within one invocation**

If `bdd.md` contains many ACs and you want the pipeline to focus only on a subset, use the optional `AC Scope` field to list the feature directories for the CURRENT focus:

```markdown
---
Work Type: feature
AC Scope: lib/domain/filter/*, lib/application/filter/*, lib/presentation/filter/*
---

### AC1: User searches payments (existing, implemented)
...

### AC2: User filters payments by status (new, in focus)
...
```

**Pipeline behavior with AC Scope**:
- Staleness is evaluated only within AC Scope directories
- Search handoffs (out of scope) are reused from before
- Filter handoffs (in scope) are regenerated
- Tests run for all ACs (regression + new)
- ✅ Efficient: only in-scope work is regenerated

**Critical constraint**: ACs outside AC Scope must have been **previously committed and tested**. If AC1 (search) is out of scope and its code is incomplete, tests will fail and you must expand AC Scope to include search.

---

## Scenario 3: Bug Fixes

**Setup**: User identifies a broken scenario, writes `bdd.md` with the failure case and expected behavior. `work_type: bug`.

**Flow**:
1. Pipeline runs **testing** agent first to reproduce the failure
2. Testing agent classifies failure by layer using Failure Classification table
3. Pipeline routes to **owning layer agent** only (not full pipeline)
   - Agent receives exact error from compilation/test output via coordination plan
   - Agent applies targeted fix: read errors, change only what's needed, verify compile passes
4. Pipeline re-runs **testing** agent to confirm fix
5. Pipeline runs **review** agent on changed code only (lightweight review for bug scope)

**Advantages**:
- Minimal re-work: only the broken layer is touched
- Error details are passed directly to the agent (no re-discovery)
- Fast iteration: typically 2–3 round trips to ready

**Example**:
- Test reports: `"Cubit does not emit loading state on submit"`
- Pipeline classifies as: `application` layer
- Routing issue to `coordination.plan.md`: `"compile error: application — Cubit does not emit loading state on submit"`
- Application agent reads this, fixes the cubit, re-checks
- Tests re-run

---

## Scenario 4: Layer Refactors (Structure, No New Behavior)

**Setup**: User restructures infrastructure, extracts a shared domain utility, reorganizes UI components. `bdd.md` lists existing ACs that must continue to work. `work_type: refactor`.

**Flow**:
1. Pipeline does NOT run layer agents (no generative work)
2. Pipeline runs **review** agent (diff-scoped) to validate architecture compliance
3. Pipeline runs **testing** agent in **regression mode**: executes existing tests against changed code
4. If tests fail:
   - Classifies failure to owning layer
   - Routes to owning layer agent (targeted fix only, not regen)
   - Re-runs tests
5. If review reports architecture violations:
   - Routes to responsible agent (targeted fix only)
   - Re-runs review
6. Loop until all tests pass and review clears

**Advantages**:
- No code generation: changes are hand-crafted, under user control
- Tests serve as regression baseline
- Fast feedback on breaks

**Example refactor**: Extract a services layer
- User creates `lib/infrastructure/core/services/auth_service.dart`
- Modifies existing code to use it instead of direct HTTP calls
- Tests run against new structure
- If tests break: agent fixes (not re-generates)

---

## Key Insights

### Convention Matters Most

All agents call the `know-the-code` agent first to discover the actual codebase patterns. **Codebase patterns always win over skill canonical templates**. This prevents code drift.

### Compilation First

Domain, application, infrastructure, and UI agents all run `dart analyze` BEFORE marking handoff as complete. If analysis fails, the agent reports the exact error and stops (status: failed). Pipeline passes that error to the re-triggered agent for targeted fix.

### Targeted Fixes, Not Re-runs

When re-triggered after a failure, agents are told: read the error from coordination plan, fix ONLY that error, re-check, update handoff. Agents do NOT re-run the full generation sequence.

### Error Details Flow Pipeline → Agent

When routing a failure back, the pipeline puts the exact compilation error or test failure in the coordination plan Issues section. The agent doesn't have to re-discover what went wrong.

### AC Scope for Iterative Development

When iterating on a branch without committing between rounds, use `AC Scope` field in `bdd.md` to tell the pipeline which feature directories are being worked on THIS iteration. Out-of-scope handoffs are reused (not regenerated) and out-of-scope code is tested for regression.

### Test First for Ambiguous Specs

Use TDD scaffold (`work_type: feature`) to write test skeletons before any implementation. This surfaces spec ambiguities early and forces the team to resolve them before code is generated.


