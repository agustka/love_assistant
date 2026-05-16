Before you start, delete all stale handoffs in `.claude/handoff` unless the prompt has "continue" in it.
Use explicit `rm -f` commands only (do not use `find` for deletion):
`rm -f .claude/handoff/*.handoff.md`
`rm -f .claude/handoff/coordination.plan.md`

Run the `pipeline` agent for the current workspace.

Use `.claude/agents/pipeline.md` as the source of truth for orchestration behavior.

Enforce that all agent-to-agent communication is written only to `.claude/handoff/*.handoff.md` (and `.claude/handoff/coordination.plan.md`).

Do not allow agents to create standalone `.md`/`.txt` reports outside `.claude/handoff/`.

Prefer tight execution: code changes + concise handoff updates only.

If the user provides an optional focus or note, treat it as additional context only.

$ARGUMENTS
