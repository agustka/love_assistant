# Iteration Flexibility Framework

## Overview

The pipeline agent no longer operates under a fixed iteration limit. Instead, iterations continue based on **forward progress criteria** and are halted by **stall detection**.

## Guiding Principle

**Continue iteration as long as productive work is being done. Block only when stuck.**

---

## Forward Progress Markers

An iteration represents **forward progress** if any of these occur:

1. **Failure Signature Changed**
   - Previous iteration had signature: `recipient_info_widget_missing`
   - Current iteration has signature: `state_progression_regression`
   - → This indicates the problem was understood/fixed, now facing a different issue
   - → Decision: **Continue (no iteration limit)**

2. **Failure Count Shrinking**
   - Previous iteration: 27 failures
   - Current iteration: 12 failures
   - → Fewer tests failing means fixes are being applied
   - → Decision: **Continue (no iteration limit)**

3. **Owning Agent Attempted Fix**
   - Testing provided diagnostic with `expected_fix`
   - Owning agent's handoff shows `modified_files` list with actual changes
   - → Decision: **Continue (re-test the changes)**

Record in `coordination.plan.md`:
```yaml
iteration N:
  failure_count: 12
  previous_count: 27
  trend: shrinking  ← forward progress marker
  failure_signature: new_signature
  owning_agent_attempted_fix: yes
```

---

## Stall Detection

The pipeline **auto-blocks** when legitimate progress stops.

### Stall Condition 1: Identical Signature Repeats (3+ times)

```
Iteration 3: failure_signature = "missing_emit_RecipientResolved"
Iteration 4: [application agent fix attempt]
Iteration 5: failure_signature = "missing_emit_RecipientResolved" ← SAME!
Iteration 6: [application agent retries]
Iteration 6: failure_signature = "missing_emit_RecipientResolved" ← SAME AGAIN!

→ Stall detected: 3 identical signatures
→ Action: Escalate to strong tier (before blocking)
```

**Record in coordination.plan.md:**
```yaml
## Stall Detection Log
iteration 5: failure_signature "missing_emit_RecipientResolved" (attempt 2) — identical to iteration 4
iteration 6: failure_signature "missing_emit_RecipientResolved" (attempt 3) — **STALL DETECTED: escalating to strong**
```

### Stall Condition 2: Failure Count Not Shrinking for 2 Consecutive Iterations

```
Iteration 4: failure_count = 8, trend = stable
Iteration 5: failure_count = 8, trend = stable ← no improvement

→ Warning: 2 iterations without progress
→ Action: Allow 1 more iteration; if still stable → escalate
```

### Stall Condition 3: Agent Refusal (Diagnostic Ignored)

```
Iteration N:
  testing provides: evidence: "cubit.dart:156", expected_fix: "add emit(RecipientResolved)"
  application agent runs: Yes
  application agent modified cubit.dart: No ← refused to apply fix!

Iteration N+1:
  same failure returns
  diagnostic still suggests same fix
  application agent runs again but STILL doesn't apply fix

→ Stall detected: Agent paralysis
→ Action: Block immediately (requires human intervention or strong tier escalation)
```

**Record in coordination.plan.md:**
```yaml
## Issues
- agent-paralysis: Application agent ran but refused to modify cubit.dart:156 (severity: blocking, status: open)
```

---

## Escalation Protocol

When stall is detected, **escalate** before immediately blocking:

### Tier Progression
```
cheap tier (1 attempt)
  ↓
medium tier (2 attempts)
  ↓
strong tier (2 attempts)
  ↓
blocked (human review required)
```

### Escalation Steps

1. **Detect stall** (same signature for 3 iterations)
2. **Before blocking**, escalate to `medium` tier (if not already)
3. **Re-run owning agent** with:
   - Full diagnostic context from all previous iterations
   - Note: `"Escalated to medium tier due to stall after 3 iterations. Previous diagnostics: [list]."`
4. **If escalation succeeds** (new signature or fewer failures):
   - Return to `cheap` tier
   - Continue iteration with new budget
5. **If escalation fails** (identical signature):
   - Escalate to `strong` tier
   - Re-run with even more context (last 3 diagnostics)
6. **If strong tier fails**:
   - Mark `status: blocked`
   - Reason: `"Maximum escalation reached; architectural/specification review required"`

---

## Per-Tier Attempt Budgets

These are **suggested caps** to prevent runaway iterations:

| Tier | Attempts Per Signature | When to Escalate | Notes |
|---|---|---|---|
| **Cheap** | Unlimited if signature changes | After 1 identical signature | Quick, simple fixes; prefer cheap runs |
| **Medium** | 2 attempts per signature | After 2 identical signatures | More capable; diagnose complex issues |
| **Strong** | 2 attempts per signature | After 2 identical signatures | Deep reasoning; for architectural issues |

**Note**: These are **soft limits**, not hard caps. The stall detection rules (3 identical signatures) take precedence.

---

## Decision Tree

```
per iteration:
  IF no failures AND no blocking gaps:
    → status: complete
    → stop

  ELSE IF same_failure_signature_for_3_iterations:
    IF current_tier == cheap:
      → escalate to medium
      → continue (new attempt)
    ELSE IF current_tier == medium:
      → escalate to strong
      → continue (new attempt)
    ELSE IF current_tier == strong:
      → status: blocked (architectural review needed)
      → stop
  
  ELSE IF failure_count_not_shrinking_for_2_iterations:
    → warn in Issues
    → allow 1 more iteration
    → if still not shrinking AND new signature not yet seen → escalate
  
  ELSE IF new_failure_signature OR shrinking_failure_count:
    → continue (no escalation needed)
    → return to cheap tier (if was escalated)
  
  ELSE IF blocking_gap_unfixable (out-of-scope, missing spec):
    → status: blocked
    → stop
```

---

## Coordination.plan.md Updates

Record stall detection explicitly:

```yaml
## Iteration History
iteration 1: failed — [testing diagnostic] [tier: cheap, signature: sig1, count: 27, trend: baseline]
iteration 2: failed — [app fix] [tier: cheap, signature: sig1, count: 25, trend: minor_shrink]
iteration 3: failed — [app fix retry] [tier: cheap, signature: sig1, count: 24, trend: minimal] ⚠️
iteration 4: failed — [escalated to medium] [tier: medium, signature: sig2, count: 10, trend: shrinking] ✅

## Stall Detection Log
iteration 2: sig1 (attempt 2 of cheap) — no shrinking
iteration 3: sig1 (attempt 3 of cheap) — **stall warning**
iteration 4: escalation to medium → new signature detected, stall cleared

## Model Routing Log
testing: tier=cheap, attempt=1
application: tier=cheap, attempt=1
application: tier=cheap, attempt=2
application: tier=medium, attempt=1 (escalated)
testing: tier=cheap, attempt=2

## Cost Summary
cheap: 4 invocations
medium: 1 invocation
strong: 0 invocations
total_iterations: 5
```

---

## Implications

### What This Enables
- ✅ 3-iteration fixes that truly need 3 iterations (no hard wall)
- ✅ Multi-layer cascades (7+ iterations if shrinking each time)
- ✅ Automatic escalation when stuck (not manual pipeline intervention)
- ✅ Clear visibility (Stall Detection Log shows exact halt point)

### What This Prevents
- ❌ Infinite loops (stall detection at 3 identical signatures)
- ❌ Wasteful iterations (must show progress to continue)
- ❌ Ambiguous blocking (clear reason in Issues when blocked)

---

## Common Scenarios

### Scenario 1: Multi-phase fix (3 iterations)
```
Iteration 1: Testing → 27 failures
Iteration 2: UI fix → 12 failures (new signature) ✅ continue
Iteration 3: Application fix → 5 failures (new signature) ✅ continue
Iteration 4: Final fix → 0 failures ✅ complete
```
**Result**: 4 iterations (no wall hit). Progress markers detected each iteration.

### Scenario 2: Wedged in same error
```
Iteration 1: Testing → 27 failures, sig1
Iteration 2: App fix attempt → 27 failures, sig1 (no change)
Iteration 3: App fix retry → 27 failures, sig1 (no change)
Iteration 4: [stall detected—escalate to medium]
Iteration 5: Medium tier attempt → 12 failures, sig2 (progress!) ✅ continue
```
**Result**: Escalation cleared the stall. Continue naturally.

### Scenario 3: Truly stuck
```
Iteration 1: Testing → failure sig1
Iteration 2: App fix → failure sig1 (diagnostic ignored)
Iteration 3: UI fix → failure sig1 (different diagnostic, same error)
Iteration 4: [stall + escalate to strong]
Iteration 5: Strong tier → failure sig1 (still identical)
→ status: blocked, reason: "Max escalation reached; architectural review needed"
```
**Result**: Stall detected, escalation tried, still failed → blocked for human review.


