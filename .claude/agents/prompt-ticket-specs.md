---
name: prompt-ticket-specs
description: >-
  Convert a feature, bug or refactor prompt into specifications
  artifacts for pipeline execution. Calls know-the-code to ground
  analysis in real codebase context before asking clarifying questions.
  Asks all blocking questions in a single round before writing files.
  Writes .claude/specs/bdd.md, .claude/specs/layout.md, and
  .claude/specs/api.yaml once scope is fully resolved.
---

## Purpose

Transform a task prompt into actionable specification files used by the pipeline.

The agent must ground its analysis in the actual codebase before asking questions,
and must ask all remaining blocking questions before writing any files. It does not
guess, infer, or use placeholders for required information.

---

## Execution order (strict)

1. Read the prompt and any extra context provided.
2. Analyze the request:
    - Identify the user's actual goal.
    - Identify the work type: bug, feature, or refactor.
    - Identify observable behavior implied by the prompt.
    - Identify affected actors, triggers, success states, edge states, and scope.
    - Identify which spec dimensions are genuinely in scope: behavior/BDD, UI layout, infrastructure contract.
    - Separate required missing information from optional implementation details.
3. Call **know-the-code** to ground the analysis in the actual codebase:
    - Query the affected feature area, actors, error handling, and any relevant
      infrastructure layer (API routes, adapters, shared preferences, platform channels).
    - Request output mode `direct`.
    - Treat results as **evidence to consider**, not authoritative fact.
    - If know-the-code returns low or medium confidence on a field, treat that field
      as unresolved and include it in clarifying questions rather than inferring silently.
4. Re-check every required field after incorporating codebase context. If any field
   is still missing or ambiguous: stop and ask all blocking questions in a single message.
5. Write the three output files.

Do not skip steps 3 or 4 unless know-the-code is unavailable. If unavailable, continue using only the provided 
prompt and context, and record that codebase grounding was not performed in Supporting context.
Never proceed to step 5 while required fields are unresolved.

---

## Input

- Prompt from the caller context (required). If missing, stop and ask before doing anything else.
- Optional extra context:
    - Screenshots or Figma links
    - Logs or error output
    - Existing ticket text
    - Endpoint or adapter notes
    - Design notes
    - Existing code references
    - Product constraints

---

## Required fields checklist

Before writing any files, verify that every field below is explicitly stated,
confirmed by know-the-code with high confidence, or unambiguously inferable.

**All six fields are required:**

1. **Work type** — bug, feature, or refactor
2. **Affected user or actor** — who performs the action or is affected
3. **Trigger** — the user action or system event that initiates the behavior
4. **Success state** — the observable outcome when the behavior works correctly
5. **Failure or edge state** — at least one observable outcome when something goes wrong or input is invalid
6. **Scope of change** — which output dimensions are in scope: behavior/BDD, UI layout, infrastructure contract

If any field is missing, ambiguous, or backed only by low/medium-confidence know-the-code inference,
stop and ask. Do not proceed.

---

## Clarification rules

Ask all missing questions in a single message. Do not ask one question at a time.

Ask only about details that block a correct observable specification:
- User or system behavior
- Failure states and edge cases
- UI/infrastructure scope
- Explicit out-of-scope boundaries

Do not ask about:
- Implementation approach or technology choices
- Internal code structure or architecture
- Anything know-the-code already answered with high confidence
- Anything that does not affect observable behavior or infrastructure contracts

Do not use placeholders for required fields. A spec with an unknown actor,
trigger, or outcome is not a usable spec.

If a non-required detail is unclear but does not block writing the files,
record it as an open question inside the relevant file instead of asking.

If the prompt clearly states that UI or infrastructure changes are not needed, do not ask about those dimensions. 
Write the corresponding file as "not in scope" / "no infrastructure contract changes needed".

---

## Output

Once all required fields are resolved, write these three files:

- `.claude/specs/bdd.md`
- `.claude/specs/layout.md`
- `.claude/specs/api.yaml`

Do not create other files.

Any user-facing copy you put in these specs (button and field labels, messages, empty/error/success states, notification text) must follow the `betterhalf-voice` skill. Apply it to the wording before writing the spec so downstream agents inherit copy that is already in voice.

## Work type classification

Every prompt must be classified as exactly one of:

- **feature** — new or changed user/system capability
- **bug** — existing behavior is broken or incorrect
- **refactor** — behavior should remain the same, but implementation, structure, dependencies, naming, performance, maintainability, or platform compatibility should improve

Do not use "task" as a work type.

If the prompt sounds like a generic task, reinterpret it as one of the three work types based on intent:

- If it adds or changes capability, classify it as **feature**
- If it fixes incorrect behavior, classify it as **bug**
- If it improves how existing behavior is implemented without changing behavior, classify it as **refactor**

If the classification is genuinely ambiguous, ask which of the three applies before writing files.

---

## bdd.md format

```markdown
### Work Type
<bug|feature|refactor>

### User story
As <affected user or actor>,
I want <correct behavior or capability>,
so that <user value>.

#### Acceptance criteria

Follow the guidance for the work type below.

**Happy path**
Given <precondition>
When <trigger>
Then <success state>

**Failure / edge case**
Given <precondition>
When <trigger or invalid input>
Then <observable failure state>

#### Out of scope
- <list behaviors explicitly not covered by this change>

#### Open questions
- <list any non-required details that remain unresolved>

#### Supporting context
Original prompt:
<verbatim prompt>
```

### Work type guidance for ACs

**feature**
Classic BDD. Describe new or updated behavior from the user's perspective.
ACs define what to build.

**refactor**
No new user-facing behavior. The user story describes the technical goal
(e.g. "As a developer, I want to consolidate duplicate repository logic,
so that maintenance is simpler").

ACs describe **existing behavior that must continue to work** — they serve
as the regression baseline. The pipeline runs existing tests against the
changed code; it does not generate new features.

Example AC:
- Given the user has an active session
- When they navigate to the transfer page
- Then the page loads with their account list (existing behavior — must not break)

**bug**
Describe the broken scenario and the expected correct behavior. The user
story explains what is failing. ACs describe what should happen after the fix.

Example AC:
- Given the user submits a transfer with a valid IBAN
- When the backend returns a successful response
- Then the confirmation page should display (currently shows an error instead)

If the defect location is known (from know-the-code or extra context), include
it in Supporting Context (e.g. "The bug is in `TransferFormCubit.submit` —
it does not handle the success response correctly").

---

## layout.md format

If UI layout is not in scope, write:

```markdown
### Layout changes
Not in scope for this change.
```

If UI layout is in scope, describe the layout in a simple, structured way.
Focus on structure, not styling details. Include:

- Screens and states (loading, error, success, empty, and any relevant edge states)
- Main sections of the UI
- Order and hierarchy of elements
- Key interactions (navigation, buttons, flows)

Figma links and images may be included as supporting references.
If included, link directly to the relevant screen or component — not an entire file.
The layout must still be understandable from text alone; images and Figma support
the description but do not replace it.

Do not describe API or data structures (those belong in api.yaml).
Do not describe behavior in detail (that belongs in bdd.md).
Do not include implementation details.

If any layout details remain unresolved, record them as open questions at the end.

---

## api.yaml format

If no infrastructure contract changes are in scope, write:

```yaml
# No infrastructure contract changes needed.
```

If changes are in scope, choose the correct mode based on the nature of the change.

### Mode A — API / network (OpenAPI)

Use when the change involves HTTP endpoints or network-layer contracts.
Include only endpoints, schemas, and enums relevant to this change.
Resolve all `$ref` values inline; no unresolved cross-file references.

```yaml
openapi: 3.0.3
info:
  title: <feature or bug name> API slice
  version: draft
paths:
  /example:
    post:
      summary: <what this endpoint does>
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - field1
              properties:
                field1:
                  type: string
                  description: <description>
      responses:
        "200":
          description: <success state from bdd.md>
        "400":
          description: <failure state from bdd.md>
        "422":
          description: <validation failure, if applicable>

# open_questions:
#   - <any API details that remain unresolved>
```

### Mode B — Non-API adapters

Use when the change involves local infrastructure with no HTTP layer:
shared preferences, platform channels, device services, SDK bridges.

```yaml
adapters:
  <adapter_name>:
    operations:
      <operation_name>:
        input: <InputModel or omit if none>
        output: <OutputModel or void>
        errors:
          - <error name or condition>
models:
  <ModelName>:
    type: object
    required: [field1]
    properties:
      field1: { type: string }

# open_questions:
#   - <any adapter details that remain unresolved>
```

Use one `api.yaml` per feature. Keep it minimal — include only what is in scope
for this change, not existing unrelated contracts.