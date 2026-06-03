# Test Diagnostics Skill

## Overview

When tests fail, the testing agent performs **diagnostic investigation** rather than generic classification. This delivers actionable feedback to owning layer agents (application, UI, domain).

## Protocol: Three-Part Diagnostic

### 1. Pre-Execution Validation

Before running ANY test, verify that required implementation exists:

```bash
dart analyze lib/application/<feature>/
dart analyze lib/presentation/<feature>/
```

Check that:
- Cubit classes exist at paths specified in `application.handoff.md`
- Widget classes exist at paths specified in `ui.handoff.md`
- All expected state fields exist in state classes
- All expected widget keys exist (via grep) in widget sources

**If validation fails:**
- Document exact missing symbol/method/field
- Generate diagnostic handoff with missing symbol
- Mark status `failed` with gap type `missing_cubit_class`, `missing_state_field`, `missing_widget_key`
- Do NOT run tests (avoids false failures)

### 2. Diagnostic Investigation (on test failure)

**Core rule**: Do NOT accept a failure classification without investigating the actual source.

When a test fails, investigate by layer:

#### For Cubit/State Failures
- Read the cubit source (from `lib/application/<feature>/`)
- Check `emit()` call sites for the expected state
- If state is missing → document exact line range where emit should occur
- If method is missing → show the method signature expected

#### For Widget/UI Failures
- Read the widget source (from `lib/presentation/<feature>/`)
- Check the `build()` method for expected widget keys
- If key is missing → show the exact widget tree location
- Grep for the key to confirm absolute absence

#### For Navigation Failures
- Check the cubit for route emission statements
- Verify the route name matches the test expectation
- If navigation is missing → show exact push/replace statement needed

#### For Validation Failures (Domain)
- Check value object validation logic against test data
- Document exact constraint that rejects the data
- Show the validation line that should change

### 3. Diagnostic Handoff Format

When generating a handoff to an owning agent, include:

```yaml
failures:
  - scenario: "Test name/description"
    error: "Assertion failure message"
    actual_issue: "Concise root cause (1-2 sentences)"
    evidence: "file_path:line_range — code snippet or 'ABSENT'"
    expected_fix: "Specific change needed (2-3 lines description)"
    owning_layer: domain | application | ui | testing | infrastructure
```

**Example:**
```yaml
failures:
  - scenario: "Single paste into kennitala fills kennitala"
    error: "Expected recipient info widget key 'NewRecipientKennitala_recipientInfoKey' to be present, but none found"
    actual_issue: "RecipientInfoWidget not being rendered after kennitala validation"
    evidence: "lib/presentation/transfers/new_recipient/domestic/transfer_new_recipient_page.dart:156-180 — build() method renders RecipientProgressWidget but checks state without rendering RecipientInfoWidget"
    expected_fix: "In build(), after RecipientProgressWidget check, add conditional: if (state is RecipientResolved) return RecipientInfoWidget(state: state, key: Key('...'))"
    owning_layer: ui
```

## Classification Reference

| Failure Type | Owning Layer | Diagnostic Question | Evidence Location |
|---|---|---|---|
| Value object validation incorrect | domain | Does validation logic match test data constraints? | `lib/domain/<feature>/value_objects/<vo>.dart` |
| Entity `fromModel` mapping wrong | domain | Does mapping produce correct entity fields? | `lib/domain/<feature>/entities/<entity>.dart:fromModel()` |
| Cubit emits wrong state | application | Does cubit emit() produce the expected state? | `lib/application/<feature>/<cubit>.dart:emit()` calls |
| Missing cubit method | application | Is the method defined with correct signature? | Method signature in cubit class |
| Missing state field | application | Is the field defined in state class? | Field definition in state class |
| Widget not found on page | UI | Is the widget rendered in build()? | `lib/presentation/<feature>/<page>.dart:build()` |
| Wrong text displayed | UI | Is the text widget using correct text variable? | Text widget in page/widget source |
| Navigation does not reach page | UI | Does navigation emit the correct route? | Route navigation in cubit source |
| Golden mismatch | UI | Visual layout changed; check recent widget/layout edits | Recent changes in `lib/presentation/<feature>/` |
| Builder/driver compilation error | testing | Do driver/builder signatures match handoff API? | Driver/builder class definition |

## No Diagnostic Loops

When a test fails, investigate **once**:
1. Read source code → locate exact problem
2. Produce diagnostic handoff with evidence
3. Stop

**Do NOT** re-run the same test expecting another investigation. The owning layer agent reads the diagnostic and applies the fix.

## Integration with Pipeline

Once diagnostic is produced:
- Mark handoff status as `failed`
- Include diagnostic with evidence in `failures` section
- Pipeline routes to owning agent based on `owning_layer` classification
- Owning agent reads diagnostic and applies targeted fix
- Testing agent re-runs after fix is applied

This creates a tight feedback loop: **test → diagnose → fix → re-test**.


