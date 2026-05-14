# Test Data Consistency Validation

## Purpose

Before finalizing any test, validate that the test data arrangement is **adequate and consistent** with what the test is asserting. This prevents silent-pass failures where tests pass but cannot actually verify the required behavior.

Tests that pass with incomplete data are **false positives** — they're worse than test failures because they mask bugs.

---

## When to Apply

Apply this skill whenever you're composing or executing a test in generative or regression mode. Before accepting a test as complete (passing, failing, or blocked), check that the test data actually supports the assertion.

---

## Consistency Checks (All Test Types)

### 1. Negative Constraints

**Pattern**: Test asserts "X must NOT appear/happen"

**Requirements**:
- X must be available in the base data or system state initially
- The feature/code must actively filter/exclude X
- The test must demonstrate that X was present in the data, then filtered out

**Validation**:
```
Does the test builder/data provide X initially?
  ✅ Yes → test can verify X is filtered → proceed
  ❌ No → gap: "incomplete_test_data: '<assertion>' requires '<X>' 
           to be available in test data but it is not"
```

**Example**:
- AC: "ISK must not appear as a selectable currency when user opens the foreign transfer currency dropdown"
- Data check: Does FirebaseBuilder provide ISK in the currency pool?
  - ✅ Yes → test can verify ISK is filtered out
  - ❌ No → gap: `"incomplete_test_data: 'ISK must not appear' — requires ISK in the test currency pool, but test data provides only USD, EUR, GBP"`

### 2. Positive Constraints

**Pattern**: Test asserts "Y must appear/be visible/be selectable"

**Requirements**:
- Y must be provided by the test data, OR
- The feature's business logic must create/generate Y from the data
- Y must be rendered/accessible in the final state

**Validation**:
```
Can Y exist in the test data OR be created by the feature logic?
  ✅ Yes → test can verify Y appears → proceed
  ❌ No → gap: "incomplete_test_data: '<assertion>' — <Y> cannot exist 
           given the test data or feature logic"
```

**Example**:
- AC: "User can select EUR from the currency list"
- Test setup: test data provides EUR
- ✅ Proceed
- Test setup: test data does NOT provide EUR, and the feature doesn't generate it
- ❌ Gap: `"incomplete_test_data: 'User can select EUR' — EUR is not in the test data and the feature has no logic to add it"`

### 3. Error/Validation Constraints

**Pattern**: Test asserts "Error message appears when Z is invalid"

**Requirements**:
- Test data must be in the **invalid** state (empty, malformed, out-of-range, negative, etc.)
- The scenario must actually trigger the validation error path
- The error state must be reachable from the test data

**Validation**:
```
Does the test data represent an invalid state for Z?
  ✅ Yes → test can verify error → proceed
  ❌ No (only valid states in data) → gap: "incomplete_test_data: 
      'Error when <Z>' — test data provides only valid states, 
      cannot verify error path"
```

**Example**:
- AC: "Validation error shown when swift code is invalid"
- Test setup: test data includes an invalid SWIFT code
- ✅ Proceed
- Test setup: test data only includes valid SWIFT codes
- ❌ Gap: `"incomplete_test_data: 'Validation error for invalid swift' — test data provides only valid SWIFT codes"`

### 4. State Transitions

**Pattern**: Test asserts "State changes from A to B"

**Requirements**:
- Test data must start in state A (not already in B)
- The action must be capable of transitioning from A to B
- The transition must be observable/measurable

**Validation**:
```
Does the test setup produce state A initially?
  ✅ Yes → action can transition to B → proceed
  ❌ No (already in B) → gap: "incomplete_test_data: 
      'State transitions from <A> to <B>' — test data 
      starts in state <B>, cannot verify transition"
```

**Example**:
- AC: "Form state transitions from empty to validation-error when user taps submit without entering required field"
- Test setup: form starts with empty required field (state A)
- User taps submit
- Form shows validation error (state B)
- ✅ Proceed
- Test setup: form pre-populates the required field (already in valid state B)
- ❌ Gap: `"incomplete_test_data: 'State transition to error' — form data starts in valid state, cannot trigger error state"`

### 5. UI/Interaction Constraints

**Pattern**: Test asserts "User can select/interact with element Z"

**Requirements**:
- Z must exist in the rendered UI (not hidden, disabled, not filtered out by data)
- Test data must provide the conditions for Z to be present
- If Z's presence depends on data, that data must be in the test builder

**Validation**:
```
Does the test data provide conditions for Z to be rendered and enabled?
  ✅ Yes → test can verify interaction → proceed
  ❌ No (Z filtered by data, disabled, not in UI) → gap: 
      "incomplete_test_data: 'User can interact with <Z>' 
      — requires <data/conditions>, but test setup omits them"
```

**Example**:
- AC: "User can tap the submit button"
- Test setup: form is valid, submit button is enabled
- ✅ Proceed
- Test setup: form is invalid so submit button is disabled (due to feature logic or data state)
- ❌ Gap: `"incomplete_test_data: 'User can tap submit' — submit button is disabled because form is invalid; test data must provide valid form state"`

---

## Decision Logic: When to Block vs. Record a Gap

### Before Generating the Test

If you recognize incomplete test data during planning phase → **do not generate the test**; record the gap immediately.

Handoff status: `incomplete` with gap recorded, so the pipeline understands the blocker.

### While Composing/Executing the Test

If you recognize incomplete test data while writing test code → **do not finalize it as passing**; mark the test with a gap.

Handoff status: `incomplete` or `failed` (depending on severity) with the gap recorded.

### After Test Passes (Silent-Pass Detection)

If a test passes but the gap description reveals the assertion was **not actually verified** → **escalate to blocking gap**.

Example:
- Test: "ISK must not appear"
- Result: Test passes ✅
- Analysis: ISK was never in the test data, so the feature was never tested
- Action: **Do not report as passing** — classify as `incomplete_test_data` gap; mark status as `incomplete` or `failed`

This is the critical check: **false positives are worse than failures**.

---

## Gap Recording Format

Record in the handoff `gaps` section:

```
incomplete_test_data: '<assertion or AC title>' — <reason>
```

**Examples**:

- `incomplete_test_data: 'ISK must not appear' — requires ISK in the test currency pool, but test data provides only USD, EUR, GBP`
- `incomplete_test_data: 'User sees validation error' — test data only includes valid states; no invalid input scenario`
- `incomplete_test_data: 'Payment status transitions to complete' — test data starts in complete state, cannot verify transition from pending`
- `incomplete_test_data: 'User can edit recipient name' — test builder does not provide a pre-existing recipient; cannot test edit scenario`

---

## Examples in Context

### Example 1: ISK Currency Bug Test

**AC**: "ISK must not appear as a selectable currency when opening the currency dropdown from the foreign transfer new-recipient flow"

**Checklist**:
1. Is this a negative constraint? ✅ Yes ("must not appear")
2. Is ISK in the test data initially? ❌ No — test data provides [USD, EUR, GBP]
3. Can the feature filter ISK if it's not there? ❌ No — nothing to filter
4. Can the test verify the constraint? ❌ No — false positive if it passes

**Decision**: Record gap before generating test
```
Gap: incomplete_test_data: 'ISK must not appear' — requires ISK in the 
test currency pool so the feature can filter it out, but test data 
provides only USD, EUR, GBP
```

**Action**: Update test builder to include ISK in the base currency list, OR update the AC to acknowledge the limitation, OR wait for a builder that supports it.

---

### Example 2: Form Validation Error Test

**AC**: "User sees validation error when swift code is empty"

**Checklist**:
1. Is this an error/validation constraint? ✅ Yes ("error when...")
2. Does test data provide the invalid state (empty swift)? ✅ Yes
3. Does the scenario trigger validation? ✅ Yes — user taps submit
4. Can the test verify the error appears? ✅ Yes

**Decision**: Proceed with test — data is adequate.

---

### Example 3: State Transition Test

**AC**: "Currency selector state changes from empty to currency-selected when user selects a currency"

**Checklist**:
1. Is this a state transition? ✅ Yes ("state changes from A to B")
2. Does test data start in state A (empty)? ✅ Yes — no pre-selected currency
3. Does action transition to state B? ✅ Yes — user selects EUR
4. Can the test observe the change? ✅ Yes

**Decision**: Proceed with test — data is adequate.

---

## Integration with Testing Agent

When the testing agent is composing tests:

1. **Before composing**: Apply checks from this skill to the AC + test data plan
2. **While composing**: Flag any inconsistencies during test code writing
3. **After generating**: Before running the test, verify data consistency
4. **After test passes**: Apply silent-pass detection — confirm assertion was actually verified
5. **Recording gaps**: Use the `incomplete_test_data` format; mark handoff status accordingly

If gaps are too numerous or blocking, update the handoff status to `incomplete` and wait for test data builder updates or AC clarification from the pipeline.

---

## Common Pitfalls

| Pitfall | Problem | Prevention |
|---|---|---|
| Test passes with empty data | "Feature correctly excludes payment" when no payments exist | Check that negative constraints have data to filter |
| Test only exercises happy path | "User can submit form" with pre-valid data | Check that error/validation constraints have invalid data |
| Test assumes state starts in B | "Currency changes from USD to EUR" but USD not in data | Verify state A is achievable before the action |
| Test doesn't check UI rendering | "User can tap button" but button is disabled | Check pre-conditions for element to be enabled/visible |
| False positive passes | Test passes, but feature change breaks it later | Apply silent-pass detection before accepting pass |


