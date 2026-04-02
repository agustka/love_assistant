---
name: git-diff
description: "Gather git diffs for code review OR review workflows (code review, QA review). Handles scope detection, diff artifact collection, structured manifest generation, and hotspot analysis. Delegates terminal work to the git-specialist agent. Use when a review workflow needs diff artifacts."
argument-hint: "[auto | uncommitted | branch | <ref>...HEAD] — scope for diff gathering"
---

# Git Diff Skill

Git diff gathering for review workflows. This skill owns scope detection, diff collection, manifest building, and hotspot analysis. It is consumed by `code-review`, `qa-review`, and any future workflow that needs structured diff artifacts.

## Operating Policy (Non-Negotiable)

- Operate as **read-only** — never modify source or config files.
- Use workspace-local scratch paths only. **No `/tmp/`, `mktemp`, or OS temp directories.**
- **No cleanup** — cleanup is the calling workflow's responsibility (e.g., `code-review` runs its own `cleanup.sh` after the report is written).
- Do not ask the user for permission to run terminal/search/read operations or delegate to subagents.
- Run `./.github/skills/git-diff/scripts/permission_preflight.sh` at the start to front-load terminal permissions.
- Terminal auto-approval settings for this workflow are an accepted operational choice, not a review finding.

## Output Directory Convention

- **Default base**: `copilot/code_review_reports/` (for code review workflows).
- Callers can override the base via the `REVIEW_OUTPUT_BASE` env var (e.g., `REVIEW_OUTPUT_BASE=copilot/qa_review` for QA review).
- **Session format**: `<base>/<DD_MMTHH_MM_SS>_<model>_<role>_<rand5>/tmp`
- Session ID is generated from env vars `REVIEW_MODEL` (default: `unknown`) and `REVIEW_ROLE` (`main` or `subagent`, default: `main`), plus a random 5-char suffix.
- **One session folder per review** — the scripts auto-generate a unique session directory. Do not rerun with alternative names (`*_v2`, etc.) unless the prior run failed.

## Scope Detection

**Scope values**: `auto` (default — prefer uncommitted when both exist), `uncommitted`, `branch`, or explicit ref range (`origin/master...HEAD`).

Base ref detection order: `$BASE_REF` → `origin/master` → `master`.

| Scope | Behavior |
|---|---|
| `auto` | Detect uncommitted + branch commits; prefer uncommitted for faster feedback |
| `uncommitted` | Staged + unstaged + untracked changes vs HEAD |
| `branch` | Current branch diff vs resolved base ref (`<base_ref>...HEAD`) |
| `<ref>...HEAD` | Explicit three-dot range (PR-only diff) |
| `<ref>..HEAD` | Explicit two-dot range |

## Bundled Scripts

All scripts live at `.github/skills/git-diff/scripts/`. Always prefer these over ad-hoc one-liners.

| Script | Purpose |
|---|---|
| `run_full_review.sh [scope]` | **Recommended.** Runs collect → build manifest → hotspots in one command. |
| `collect_scope_and_diff_artifacts.sh [scope]` | Step 1: scope detection + diff artifacts. |
| `build_structured_manifest.sh <output_dir>` | Step 2: assembles markdown manifest from artifacts. |
| `print_diff_hotspots.sh <output_dir>` | Step 3: prints high-churn hotspot files. |
| `permission_preflight.sh` | Syncs VS Code terminal auto-approve settings. Run automatically by the above. |

> **Note**: `cleanup.sh` is NOT in this skill — cleanup is the calling workflow's responsibility. The `code-review` skill owns `cleanup.sh` at `.github/skills/code-review/scripts/cleanup.sh`.

Preflight runs automatically; set `SKIP_PERMISSION_PREFLIGHT=1` to disable.

When running step-by-step, pass the session `output_dir` printed by the collect step to the subsequent commands.

## Environment Variables

| Variable | Purpose | Default |
|---|---|---|
| `REVIEW_MODEL` | Model slug for session ID (e.g., `claude-opus-4.5`, `gpt-5-3-codex`) | `unknown` |
| `REVIEW_ROLE` | Role for session ID (`main` or `subagent`) | `main` |
| `REVIEW_OUTPUT_DIR` | Override the full output directory path | Auto-generated |
| `REVIEW_OUTPUT_BASE` | Override the base path for output directories | `copilot/code_review_reports` |
| `BASE_REF` | Override the base ref for branch diff | Auto-detected |
| `SKIP_PERMISSION_PREFLIGHT` | Set to `1` to skip VS Code settings sync | `0` |

## Terminal-Capable Agent Requirement (Non-Negotiable)

- Any step that runs shell commands (`git`, review scripts, `bash`, etc.) **MUST** execute in a terminal-capable agent context.
- Prefer delegated diff gathering with the `git-specialist` custom agent.
- Fallback order: 1) `git-specialist`, 2) default terminal-capable agent context.
- Do NOT use read-only discovery agents (e.g., `Explore`) or `search_subagent` for terminal-required steps.

## Subagent: Diff Gatherer (Non-Negotiable)

Spawn a **`git-specialist` subagent** for all git-diff gathering. Fallback to the default terminal-capable agent context only if `git-specialist` is unavailable.

Use the subagent prompt template in `references/templates.md` under **Template A - Diff Gatherer Prompt (`git-specialist`)**.

## Critical Constraints

1. **No `/tmp/` or `mktemp`** — the scripts enforce workspace-local scratch paths under `<REVIEW_OUTPUT_BASE>/<session_id>/tmp/`.
2. **One session folder per review** — do not rerun with alternative names unless the prior run failed.
3. **Cleanup is the caller's responsibility** — never run `cleanup.sh` from this skill or from the `git-specialist` agent.
