Run the `bug-ticket-specs` agent for the current workspace.

Use `.claude/agents/bug-ticket-specs.md` as the source of truth.

Requirements:
- Always overwrite `.claude/specs/bdd.md`, `.claude/specs/layout.md`, and `.claude/specs/api.yaml`.
- Keep `bdd.md` in bug format with user story + Given/When/Then acceptance criteria.
- Write placeholder content in `layout.md` and/or `api.yaml` when those changes are not required by the ticket.
- Do not create extra report files.

$ARGUMENTS
