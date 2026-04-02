---
name: code-review
description: "Methodology for code-reviewing uncommitted changes or git-diff against the PR base branch. Use when performing code reviews, reviewing diffs, or analyzing code changes."
argument-hint: "[uncommitted | branch | auto] — or attach files with #file: to review specific files only"
---

# Code Review Skill

Efficient code review methodology using subagent-delegated diff gathering to keep the reviewer's context window clean. 

## Operating Policy (Non-Negotiable)

- Operate as a read-only reviewer.
- Use `createFile` only to create new markdown report files in `copilot/code_review_reports/` and script support files under `copilot/code_review_reports/<session_id>/tmp/`.
- Never create or modify `.dart`, `.yaml`, `.json`, or other source/config files as part of review.
- Do not ask the user for permission to run terminal/search/read operations, create report artifacts, or delegate to subagents.
- Run `./.github/skills/git-diff/scripts/permission_preflight.sh` at review start to front-load permissions.
- Treat generated Dart files and golden test image diffs as review noise unless explicitly requested.
- Terminal auto-approval settings for this workflow are an accepted operational choice, not a review finding.

## Attached Files Mode & Diff Scope

If one or more files are attached to context (via `#file:` references), review **only those files**.

This default applies even when the user includes additional natural-language instructions.

Treat these cases as **no substantive text**:
- slash-command only (e.g., `/code-review`) with attachments
- wrapper/boilerplate text injected by chat UI that does not provide actual review requirements

When diff mode is explicitly requested or no files attached to prompt, treat attachments as supplemental context.

- Read each attached file with `readFile`.
- Apply the Hierarchical Review Framework to the full file content.
- Save the report using the naming convention defined in this skill.
- No cleanup needed (no temp artifacts).

## When to Delegate to a Subagent

**If you are performing a code review as part of a larger workflow** (e.g., loaded by another prompt or agent that is doing more than just reviewing), delegate the **entire review** to a subagent using the `code-review` agent. Pass the user's request and let the subagent produce the report. This preserves your main context window.

### Terminal-Capable Agent Requirement (Non-Negotiable)

- Any step that runs shell commands (`git`, review scripts, `pwd`, `bash`, etc.) MUST execute in a terminal-capable agent context.
- Prefer delegated git-diff gathering with `git-specialist` custom agent.
- Fallback order for terminal-required steps: 1) `git-specialist`, 2) default terminal-capable agent context.
- Do NOT use read-only discovery agents (for example `Explore`) or `search_subagent` for terminal-required steps.
- If terminal tools are unavailable in the current context, re-run using the fallback order above. Do not attempt a read-only subagent path.
- Main agent is allowed to run preflight scripts.

## Diff Gathering

Diff gathering is handled by the **git-diff** skill (`.github/skills/git-diff/SKILL.md`). Delegate all diff gathering to the `git-specialist` agent, which follows the git-diff skill workflow.

When delegating, set `REVIEW_OUTPUT_BASE=copilot/code_review_reports` (the default) so artifacts land in the code review session directory.

### Scripts

The only script remaining in this skill's `scripts/` folder is `cleanup.sh`:

| Script | Purpose |
|---|---|
| `cleanup.sh <output_dir>` | Deletes session tmp artifacts. Run explicitly after report creation. Sources `_common.sh` from `../../git-diff/scripts/_common.sh`. |

### Cleanup

Cleanup is the code-review workflow's responsibility. After the report is written, run the command from `references/templates.md` under **Template A - Cleanup Command**.

## Review Process

After receiving the change manifest from the subagent:

1. **Scan the manifest** — identify high-risk files (security, architecture, complex logic).
2. **Targeted deep-dives** — use `readFile` to examine specific files/regions that need closer inspection. Don't re-read what the diff already shows clearly.
3. **Cross-reference** — check if changes touch domain/infrastructure/application/presentation boundaries correctly.
4. **Apply the Hierarchical Review Framework** in this skill (architecture → correctness → security → maintainability → testing → performance → hygiene → dependencies).
5. **Write the report** — save as markdown to `copilot/code_review_reports/<uncommitted/branch/auto>_<current_checked_out_branch>_<YYYY_MM_DDTHH_MM_SS>_<reviewer_suffix>_code_review_report.md`.
   - Replace template placeholders with real values. Use a filesystem-safe slug for the branch segment.
   - Valid `reviewer_suffix` values are `code-review` and `codex-code-review`.
   - Never edit an existing review report in place. If the filename already exists, append `_v2`, `_v3`, etc.
6. **Run cleanup** — `./.github/skills/code-review/scripts/cleanup.sh <output_dir>`.

## Hierarchical Review Framework

Analyze changes with this priority order:

### 1. Architectural Design and Integrity (Critical)

- Verify alignment with existing architecture boundaries and layer contracts.
- Check SRP, cohesion, and separation of concerns.
- Flag unnecessary complexity where a simpler design would satisfy requirements.
- Verify the change is atomic and not bundling unrelated concerns.

### 2. Functionality and Correctness (Critical)

- Validate business logic against intended behavior.
- Check edge cases, error paths, and invalid/unexpected input handling.
- Look for race conditions, stale state, ordering issues, and idempotency gaps.

### 3. Security (Non-Negotiable)

- Verify input validation/sanitization at trust boundaries.
- Check auth/authz coverage for protected paths.
- Flag hardcoded secrets, keys, certificates, credentials, or token leakage.
- Check logs/errors for PII or sensitive data exposure.

### 4. Maintainability and Readability (High)

- Check naming quality and typos in identifiers.
- Flag deep nesting, unclear flow, and duplicated logic.
- Flag unwanted artifacts: debug leftovers, commented-out blocks, context-free TODO/FIXME.
- Suggest extraction when files become excessively large.

### 5. Testing Strategy and Robustness (High)

- Evaluate whether test coverage matches risk and complexity.
- Ensure failure modes and edge paths are covered.
- For UI changes, assess whether golden baselines should remain stable or be intentionally updated.

### 6. Performance and Scalability (Important)

- Check for unnecessary widget rebuilds and missing `const` usage where meaningful.
- Check memory/lifecycle hygiene: subscriptions, controllers, focus nodes, animation controllers.
- Flag blocking or heavy main-isolate work and weak caching/invalidation behavior.

### 7. Code Hygiene (Standard)

- Check formatting cleanliness (`dart format --line-length 120`).
- Ensure no unintended files are included in the change set.
- Re-check typos and naming consistency across modified files.

### 8. Dependencies and Documentation (Important)

- Question necessity and risk of new third-party dependencies.
- Verify deployment/config/doc updates where behavior changes require them.
- Ensure API model/converter changes are consistent with contracts.

## Layer-Specific Review Focus

### Domain Layer (`lib/domain/`)

- No imports from application/infrastructure/presentation.
- Entities extend `Equatable`, are immutable, and enforce domain invariants.
- Entities built from infrastructure models expose `fromModel` constructors.
- Prefer value objects over raw primitives for constrained domain data.

### Application Layer (`lib/application/`)

- Cubits extend `IsbCubit`.
- No state emission in constructors.
- Avoid cubit-to-cubit communication.
- State remains immutable with `copyWith` updates.
- Prefer use cases over direct repository injection in new code.
- Ensure stream subscriptions are cancelled in `close()`.

### Infrastructure Layer (`lib/infrastructure/`)

- Repositories use `BehaviorSubject` with `StreamPayload` where required.
- Caching follows project Hive cache support patterns.
- Error handling logs via `err()` and wraps failures in `Payload`/`StreamPayload`.
- API model fields are nullable.
- Models do not implement `toDomain()`.
- Service methods are wrapped in try-catch.
- New endpoints include offline client coverage when applicable.

### Presentation Layer (`lib/presentation/`)

- Preserve atomic design import direction (lower levels do not import higher levels).
- Keep business logic out of widgets.
- Use localized strings (`S.of(context)`) instead of hardcoded UI text.
- Ensure all disposable state fields are disposed.
- Recommend extracting subwidgets when files become too large.

## Communication and Triage

- Prioritize findings by severity: `Critical/Blocker`, `Improvement`, `Nit`.
- Keep feedback concise, specific, and actionable. Explain _why_ with clear engineering rationale.
- Assume positive intent and keep tone constructive.
- Always include a `## PR` section with one short sentence; if unsafe to merge, write `Do not merge as-is.`.

## Feedback Style

- Be short and to the point; avoid lengthy explanations.
- Keep feedback concise and direct.
- Keep the `PR` section to a single sentence.

## Report Template

Use the markdown report template in `references/templates.md` under **Template B - Review Report Markdown**.
