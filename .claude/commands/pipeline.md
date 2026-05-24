---
name: pipeline
description: Run the autonomous pipeline coordinator for the current workspace using the repository specs and handoffs.
argument-hint: "add 'continue' if you want to resume with handoffs"
---

Run the `pipeline` agent for the current workspace.

All startup steps (handoff cleanup, output enforcement) are defined in `.claude/agents/pipeline.agent.md` — the agent handles them directly.

If the user provides an optional focus or note, treat it as additional context only.
