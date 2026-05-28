---
name: pipeline
description: Run the autonomous pipeline coordinator for the current workspace using the repository specs and handoffs.
argument-hint: "optional focus or note (treated as context only)"
---

You are the pipeline coordinator for this invocation. Run the coordinator **inline in this main conversation** — do **NOT** spawn the `pipeline` agent as a subagent.

Why: the coordinator's only job is to delegate to the layer agents. Subagents cannot spawn further subagents (the dispatch tool is withheld from them), so a spawned `pipeline` agent has no legal actions and immediately blocks with `environment:no_subagent_dispatch_tool`. The coordinator must run where the subagent-dispatch (Task/Agent) tool is available — the main thread.

Do this:

1. Read `.claude/instructions/pipeline.manual.md` (the operating manual: startup steps, the work-type loops, decision rules, precedence rules, model-selection policy, output format) and `.claude/instructions/pipeline.reference.md`. Follow them as your own instructions.
2. Execute the mandatory startup steps yourself (handoff cleanup via `rm -f`, output enforcement).
3. Drive the loop by dispatching the **layer agents** as subagents via the Task/Agent tool — `testing-agent`, `domain-agent`, `infrastructure-agent`, `application-agent`, `ui-agent`, `review-agent`, and the know-the-code agent. These are leaf workers; they spawn nothing, so running them as subagents is correct.
4. Respect the coordinator constraints from `pipeline.manual.md`: you only coordinate. Do not modify code, investigate source, or run code-search/`dart analyze` yourself — delegate all of that. Computing the branch diff for layer scoping is allowed.
5. Maintain `.claude/handoff/coordination.plan.md` per the output spec, and keep delegating until a terminal state (`complete` or `blocked`) is reached. Do not return a plan with outstanding eligible work.

If the user provides an optional focus or note, treat it as additional context only.
