# Codex Mirror

This directory mirrors the repository's Claude orchestration setup for Codex.

- `agents/`: role prompts for Codex subagents.
- `commands/`: command runbooks to execute from the main Codex thread.
- `instructions/`: shared architecture, product, pipeline, and layer rules.
- `skills/`: reusable implementation and review procedures.
- `specs/`: pipeline input specs.
- `handoff/`: pipeline and subagent handoff files.

Do not edit `.claude/**` when working in Codex mode. Keep Codex runtime artifacts under `.codex/**`.

Some copied agents reference skill names that were not present in the source `.claude/skills/` tree. If a referenced skill file is missing, continue from the agent instructions, the layer `AGENTS.md`, and the closest available `.codex/skills/` file instead of reading from `.claude/**`.
