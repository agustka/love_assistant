---
name: pipeline
description: Run the autonomous pipeline coordinator for the current workspace using the repository specs and handoffs.
argument-hint: "add 'continue' if you want to resume with handoffs"
---

Before you start, delete all stale handoffs in `.github/handoff` unless the prompt has "continue" in it.
Use explicit `rm -f` commands only (do not use `find` for deletion):
`rm -f .github/handoff/*.handoff.md`
`rm -f .github/handoff/coordination.plan.md`

Run the `pipeline` agent for the current workspace.

Use `.github/agents/pipeline.agent.md` as the source of truth for orchestration behavior.

Enforce that all agent-to-agent communication is written only to `.github/handoff/*.handoff.md` (and `.github/handoff/coordination.plan.md`).

Do not allow agents to create standalone `.md`/`.txt` reports outside `.github/handoff/`.

Prefer tight execution: code changes + concise handoff updates only.

If the user provides an optional focus or note, treat it as additional context only.

