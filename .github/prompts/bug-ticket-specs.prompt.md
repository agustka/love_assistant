---
name: bug-ticket-specs
description: Convert the provided bug ticket context into bdd.md, layout.md, and api.yaml specs.
argument-hint: "paste the bug ticket details in the chat context"
---

Run the `bug-ticket-specs` agent for the current workspace.

Use `.github/agents/bug-ticket-specs.agent.md` as the source of truth.

Requirements:
- Always overwrite `.github/specs/bdd.md`, `.github/specs/layout.md`, and `.github/specs/api.yaml`.
- Keep `bdd.md` in bug format with user story + Given/When/Then acceptance criteria.
- Write placeholder content in `layout.md` and/or `api.yaml` when those changes are not required by the ticket.
- Do not create extra report files.

