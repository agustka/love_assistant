---
name: bug-ticket-specs
description: >-
  Convert a bug ticket into repository spec artifacts for pipeline execution.
  Always rewrites agents/specs/bdd.md, agents/specs/layout.md, and
  agents/specs/api.yaml. Decides whether layout/api details are required or
  should remain explicit placeholders.
---

## Purpose

Transform a bug report into actionable specification files used by the pipeline.

## Input

- Bug ticket text from the caller context (required)
- Optional extra context from the caller (screenshots, logs, endpoint notes)

If the bug ticket is missing, stop and ask for the ticket text.

## Output

Always overwrite these files:

- `agents/specs/bdd.md`
- `agents/specs/layout.md`
- `agents/specs/api.yaml`

Do not create other docs unless explicitly requested.

Any user-facing copy you put in these specs (button and field labels, messages, empty/error/success states, notification text) must follow the `betterhalf-voice` skill. Apply it to the wording before writing the spec so downstream agents inherit copy that is already in voice.

Any behavior or layout you spec must conform to the product interaction doctrine in `.codex/instructions/product-decision.md`. Read it before writing `bdd.md` and `layout.md`: the product is card-based ("prepare and present, never automate"), input is limited to the four input shapes (chip, date/number picker, scoped ~120-char text, or a confirmation on a system-suggested fact), and the prohibited UI cues (chat bubbles, threads, blank prompt boxes, assistant avatars, "Ask me anything", "Regenerate response") must never appear. A bug fix must not reintroduce a chat-style surface.

## bdd.md format

Write in this exact section structure:

```markdown
### Work Type

bug

### User story
As <affected user>,
I want <correct behavior>,
so that <user value>.

#### Acceptance criteria
Given <initial context>
When <user action>
Then <expected observable result>

#### Supporting context
Here's the original bug ticket:

<verbatim bug ticket text>
```

Rules:
- Keep ACs user-observable and testable.
- Add multiple Given/When/Then blocks only when needed for distinct outcomes.
- Preserve important ticket constraints (build, preconditions, repro steps, expected, actual).
- Avoid implementation details, class names, and fix proposals.

## layout.md decision rules

Write **real layout guidance** only if the ticket explicitly requires UI composition or visual changes, for example:
- New/changed component hierarchy, sections, or screen structure
- Copy/text changes shown to users
- Spacing, alignment, sizing, or visual treatment changes
- New UI states requiring design-level structure

If none of the above is required, write exactly:

```markdown
No UI changes needed for this change.
```

## api.yaml decision rules

Write **real API spec content** only if the ticket requires API contract work, for example:
- New/changed endpoint
- Request/response schema change
- New/changed fields or validation rules coming from backend
- Different HTTP method/status/error contract behavior
- Supabase backend work — a database table/column/RLS change, a migration, or an Edge Function (all owned by the infrastructure layer). If the bug involves reading or writing a Supabase table, declare the table and whether a migration is required; never assume the table already exists.

If no API contract change is required, write exactly:

```yaml
No API changes needed for this change.
```

When changes are required, produce valid YAML in the matching mode (see `agents/specs/README_api_yml_creation.md`): Mode A OpenAPI for HTTP endpoints, Mode B adapters for non-API local infrastructure, or Mode C `mode: supabase` for Supabase tables/migrations/Edge Functions plus their client adapter. Keep it to a minimal slice for the bug scope only.

## Workflow

1. Read the bug ticket and extract: actor, preconditions, repro steps, expected, actual.
2. Derive one concise user story from expected behavior.
3. Convert repro + expected/actual into precise ACs in Given/When/Then form.
4. Decide `layout.md` using layout decision rules.
5. Decide `api.yaml` using API decision rules.
6. Overwrite all three spec files in one run.

## Constraints

- Keep scope tight to the bug ticket.
- Do not invent unrelated feature behavior.
- Do not leave stale content from previous specs.
- If information is ambiguous, choose conservative placeholders for `layout.md` and `api.yaml` and keep uncertainty in AC wording without inventing backend/UI requirements.

