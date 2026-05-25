---
name: pipeline
description: Run the autonomous pipeline coordinator for the current workspace using the repository specs and handoffs.
argument-hint: "optional focus or note (treated as context only)"
---

Run the `pipeline` agent for the current workspace.

All startup steps (handoff cleanup, output enforcement) are defined in `.claude/agents/pipeline.md` — the agent handles them directly.

If the user provides an optional focus or note, treat it as additional context only.
