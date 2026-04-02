---
name: qa-review
description: "Generate a Teams-ready message summarizing release changes — including a high-level General Changes summary and detailed infrastructure-layer API analysis — between an older release branch and the current checked-out branch, or between two release branches. Use when QA needs a release diff summary covering user-facing changes, endpoint additions/removals/modifications, caching changes, auth/header/token changes, homescreen load impact, and lifecycle trigger changes."
argument-hint: "<older_ref> (only when current branch is release/*) | <release_ref_a> <release_ref_b> — two release refs are normalized by version"
---

# QA Review

Generates a Teams-friendly message summarizing infrastructure-layer changes between an older release branch and the currently checked-out branch (`HEAD`), or between two explicit release branches, so QA can notify the platforms/server team about API-impacting changes.

## Operating Policy (Non-Negotiable)

- Operate fully autonomously. Never ask for permission, confirmation, or approval. Run terminal commands, read files, and create reports directly. The user invoked you to get a finished Teams message — not to babysit prompts.
- Never use `/tmp/` or `mktemp`. Use workspace QA paths only: `copilot/qa_review/tmp/` for scratch files. Store final report artifacts in `copilot/qa_review/`.

## Accepted Inputs

- **One release ref**: compare that release ref against the current checked-out branch (`HEAD`) only when the current checked-out branch is also a release branch.
- **Two release refs**: compare those two release branches directly instead of using `HEAD`.
- When two release-style refs are available, determine **older** and **newer** from the version number, not from the prompt order.
- Always analyze the **newer release against the older release** semantically. For git diff correctness, the diff range must still be run as `older..newer`.

## Mandatory Input Preflight Gate

Do not start artifact collection or analysis until this gate passes.

1. Resolve the current branch first (`git rev-parse --abbrev-ref HEAD`) and classify whether it is a release branch.
2. Parse release-branch refs from the user prompt.
3. Enforce these rules strictly:
	 - If current checkout is a release branch and the user did not specify at least one comparison release branch in the prompt, stop and do not perform QA review.
	 - If current checkout is not a release branch and the user did not specify two release branches in the prompt, stop and do not perform QA review.
4. On gate failure, return a short corrective message and request the missing refs; do not run `collect_infra_diff.sh`.

### Gate Failure Messages

- **Case 1 (on release branch, missing comparison ref):**
	- `QA review not started: current branch is a release branch, but no comparison release branch was provided. Provide one release ref (or two explicit release refs).`
- **Case 2 (not on release branch, missing two release refs):**
	- `QA review not started: current branch is not a release branch, so two release branches must be provided in the prompt.`

## Workflow

### 1. Collect Diffs

Delegate diff collection to the `git-specialist` subagent. Do NOT run the collection scripts directly in the main agent's terminal — the raw terminal output pollutes the main agent's context window. The subagent absorbs all terminal output and returns only a structured summary.

#### Critical Constraints

1. **No files into `/tmp/` or `mktemp`** — scripts enforce workspace-local scratch paths under `copilot/qa_review/tmp/`.

#### Subagent: Diff Gatherer (Non-Negotiable)

Spawn a **`git-specialist` subagent** for diff collection. Fallback to the default terminal-capable agent context only if `git-specialist` is unavailable. A single invocation collects both infrastructure-specific artifacts and general (all-layer) change artifacts.

Use the diff-gatherer prompt template in `references/templates.md` under **Template A — Diff Gatherer Prompt (`git-specialist`)**.

#### Bundled Scripts

All scripts live at `.github/skills/qa-review/scripts/`:

| Script | Purpose |
|---|---|
| `_common.sh` | Shared utility functions (version comparison, ref resolution, path safety). Sourced by the other scripts. |
| `collect_infra_diff.sh <older_ref> [output_dir]` | Collects categorized file lists, endpoint changes, cache changes, per-file diffs, and general (all-layer) change artifacts (layer counts, commit log). |
| `collect_infra_diff.sh --legacy <ref_a> <ref_b> [output_dir]` | Explicit two-release-ref comparison mode. |
| `resolve_diff_artifact.sh <output_dir> <source_file_path>` | Resolves a source file path to its compact diff artifact in `diffs/`. |
| `cleanup.sh [output_dir]` | Removes temporary artifacts. |

**Script behavior:**
- The collection script enforces remote freshness by running `git fetch --all --prune` before analysis.
- For release comparisons, remote-tracking refs are preferred when available (e.g., `origin/release/6.2.7`).
- Default output_dir: `copilot/qa_review/tmp`. Allowed output_dir prefix: `copilot/qa_review/`.
- One-ref mode uses the current checked-out branch (`HEAD`) as the comparison target.
- When both refs include a release version, the script normalizes them so the lower version is treated as **old** and the higher version is treated as **new**, regardless of prompt order.
- Produces categorized file lists, endpoint change summaries, cache changes, and per-file diffs.
- Produces `diff_artifacts_map.tsv` for resolving source file paths to exact `diffs/*.diff` artifact names.

### 2. Analyze Changes

Read the collection artifacts and deep-dive into specific files.

#### Subagent Split for Analysis (Recommended)

After diff collection completes, use two focused subagents so each analysis pass stays precise and context-efficient:

1. **Infrastructure deep dive (API-risk focused):** run the default agent as subagent.
2. **All-layer deep dive (user-impact focused):** run the **`Explore`** subagent.

#### Subagent Prompt Template: Infrastructure Deep Dive (default agent as subagent)

Use the infrastructure deep-dive prompt template in `references/templates.md` under **Template B — Infrastructure Deep Dive Prompt (Default Subagent)**.

#### Subagent Prompt Template: All-Layer Deep Dive (`Explore`)

Use the all-layer deep-dive prompt template in `references/templates.md` under **Template C — All-Layer Deep Dive Prompt (`Explore`)**.

#### General Changes Analysis

Analyze the general (all-layer) diff artifacts to produce a plain-English summary of user-facing and behavioral changes:

1. Read `general/general_summary.txt` and `general/general_changed_files.txt` from the output directory.
2. Optionally read selected presentation-layer or domain-layer diff artifacts for additional context on user-facing impact. This is especially important when commit messages are uninformative (e.g., "fix", "WIP", "update").
3. Synthesize a plain-English summary focusing on: features added/removed/modified, UI changes, flow changes, and behavioral changes.
4. **Do NOT mention Dart file names, class names, cubit names, widget names, or other technical code artifacts. Write as if explaining to someone who uses the app, not someone who reads the code.**
5. Aim for 3–8 bullet points of high-signal changes. Each bullet should be one concise sentence.

#### Categories to Analyze

| Category | What to Look For | Emoji |
|---|---|---|
| **New Endpoints** | `ENDPOINT_ADDED` in endpoint_changes.txt, new chopper service files | 🆕 |
| **Modified Endpoints** | Changed parameters, return types, annotations in existing endpoints | ✏️ |
| **Removed Endpoints** | `ENDPOINT_REMOVED` in endpoint_changes.txt, deleted service files | 🗑️ |
| **HomeScreen Impact** | Changes in `homescreen_files.txt`, new subscriptions in homescreen cubits — anything new on homescreen means more API calls on every unlock | 🏠 |
| **Auth & Token Changes** | Changes in `auth_files.txt` and `token_changes.txt`, `@Header("Cookie")` or `@Header("Authorization")` modifications, token handling in services/repos/interceptors, token invalidation, refresh, persistence, or per-user token keys | 🔐 |
| **Header Changes** | `HEADER_ADDED`/`HEADER_REMOVED` in endpoint_changes.txt, new `@Header()` annotations | 📋 |
| **Caching Changes** | `cache_changes.txt` — Duration/TTL modifications, new CacheSupport, Hive box changes | ⏱️ |
| **Lifecycle Triggers** | Changes affecting app unlock/lock/user-switch behavior — homescreen cubits, auth flow, session management | 🔄 |
| **Model Changes** | New/modified DTOs in `model_files.txt` — new fields, removed fields, new models | 📦 |
| **Feature Toggle Changes** | `feature_toggle_files.txt` — new toggles gating API calls | 🚩 |
| **Load Impact** | Anything that increases/decreases network request frequency — new polling, homescreen widgets, background syncs | ⚡ |

#### Mandatory Review Checklist

These three checks must always be investigated and must always be reported in the Teams paste block and the detailed report. Checklist items 2 and 3 must always include an explicit `Yes`/`No` verdict; when `No`, use `No - No change detected` and do not list affected URLs:

1. **Potentially affected URLs** — list every REST or GraphQL URL/path that could be affected by the release diff.
2. **Potential token changes review** — inspect changed service modules and auth interceptors, then state whether token-interceptor behavior changed. If yes, list the affected URLs.
3. **Potential header changes review** — inspect changed service modules, chopper services, and interceptor/header code (including broader infra header diffs in `header_changes.txt`), then state whether header behavior changed. If yes, list the affected URLs.

#### Deep-Dive Strategy

1. **Read `endpoint_changes.txt`** — pre-extracted endpoint additions/removals with base URLs.
2. **Read `token_changes.txt`** — token, cookie, authorization, session, and auth-interceptor related diff lines.
3. **Read `service_module_interceptor_changes.txt`** — explicit service-module diff lines for interceptor additions/removals and auth/header-related wiring changes.
4. **Read `header_changes.txt`** — broader header-related changes across auth/token/core-infra/service files.
5. **Read `cache_changes.txt`** — TTL and cache configuration changes.
6. **Scan `homescreen_files.txt`** — any file here needs careful analysis for load impact.
7. **Use `diff_artifacts_map.tsv`** — resolve each changed source file path to its exact artifact file under `diffs/` before reading compact diffs.
8. **For each added/modified chopper service** in `chopper_service_files.txt`, read the full file at the normalized newer ref to understand the complete endpoint surface: `git show <newer_ref>:<file_path>`
9. **For each deleted chopper service** in `deleted_chopper_files.txt`, read the prior version from the older ref: `git show <older_ref>:<file_path>`
10. **For each changed service module** in `service_module_files.txt`, inspect the full file at both refs when needed and identify which chopper services or GraphQL clients it wires up. Use that mapping to determine the URLs affected by token-interceptor or header changes.
11. **Build the mandatory checklist facts explicitly** before drafting the message:
	- Compile a de-duplicated list of potentially affected URLs.
	- Record `Token-interceptor changes: Yes/No` and write the line as `Yes - <summary>` or `No - No change detected`; include affected URLs when `Yes`.
	- Record `Header changes: Yes/No` and write the line as `Yes - <summary>` or `No - No change detected`; include affected URLs when `Yes`.
12. **Trace homescreen wiring**: If homescreen-related cubits changed, trace which repositories they subscribe to and which endpoints those repos call. New subscriptions = new API calls on unlock.
13. **Check for subtle load changes**: A widget moved to the homescreen means its backing API will be called much more frequently.
14. **GraphQL**: Check `electronic_documents_graphql/` and any `*_graphql*` paths for query/mutation changes — not just REST.
15. **Token vigilance**: Always inspect auth/token-related interceptors, token fetchers/services, shared-prefs token keys, SSO cookies, refresh/invalidation logic, and per-user token persistence even if no endpoint annotation changed.

#### Artifact-Read Guardrails

- Do not manually derive artifact names in `diffs/` from source paths; always use `diff_artifacts_map.tsv`.
- Prefer reading one artifact file per tool call (or a very small batch) instead of long terminal loops to avoid wrapped/truncated output.
- If shell lookup is needed, use `resolve_diff_artifact.sh` and then read the returned file path directly.
- Avoid chained multi-file `cat` loops for artifact analysis.

### 3. Generate Teams Message

Format the analysis as a Teams-ready message. Start with a very short Teams paste block, then place the fuller categorized analysis below it.

#### Top Summary Rules

- The report MUST begin with a heading exactly named `## TEAMS MESSAGE TO PASTE`.
- The Teams block MUST NOT include general changes - that is only intended for server people.
- The Teams block should include a short **Summary** section plus the mandatory **Default Review Checklist**.
- The summary section should usually be **2 to 5 bullets total**.
- Each bullet should be **one sentence**. Two sentences are allowed only for unusually important changes.
- Prioritize only the highest-signal changes: endpoint surface, token/auth behavior, load impact, and contract changes.
- If there are no important changes in a category, omit it from the short block.
- End the short block with a brief “no major X/Y/Z changes” bullet when that absence is important context.
- The checklist must always contain all three items. For items 2 and 3, always include an explicit `Yes`/`No` verdict.
- Display the Teams block in chat so QA can copy-paste immediately.
- After the short block, add `## Detailed Report` and include the fuller categorized analysis.

#### Teams Message Template

Use the Teams output template in `references/templates.md` under **Template D — Teams Message Template**.

**Formatting rules:**
- The short Teams block at the top is the default deliverable QA should paste into Teams.
- Keep the top Teams block compact and high-signal, but always include the checklist.
- Only include categories that have actual changes. Skip empty categories entirely.
- Use backticks for endpoint paths and model names.
- Use ⚠️ for anything that increases load or could affect stability.
- Keep descriptions brief — one line per change.
- Always mention token-related changes when token lifecycle, token persistence, token invalidation, SSO cookies, authorization headers, or auth interceptors changed, even if no endpoint changed.
- For checklist items 2 and 3, never omit the explicit `Yes`/`No` verdict. Use `Yes - <summary>` or `No - No change detected`.
- If checklist items 2 or 3 are `No - No change detected`, do not add an `Affected URLs` segment for that item.
- Do not mention Flutter offline implementation details, offline clients, or Flutter testing setup in either the Teams block or Detailed Report; omit them entirely.
- `Potentially affected URLs` should include URLs implicated by changed service modules and interceptors even if the endpoint annotation itself did not change.
- Extract `<from_version>` from the normalized older ref (e.g., `release/6.2.7` → `6.2.7`).
- Extract `<to_version>` from the normalized newer ref.
- If the newer target is `HEAD` and it is not a release branch, use a sanitized current branch name for `<to>` (fallback: short SHA).
- If explicit two-ref mode is used and the newer ref is not a release branch, use a sanitized ref name for `<to>`.
- End the detailed section with the Load Impact Summary as a concise overall assessment.

### 4. Save Report

Save the Teams message as markdown to: `copilot/qa_review/qa_review_<from>_to_<to>_<DD_MM_YY>.md`

Where `<from>` is extracted from the normalized older ref and `<to>` is extracted from the normalized newer ref (release version when available, otherwise sanitized branch name or short SHA).

### 5. Cleanup

Temporary artifacts in `copilot/qa_review/tmp/` should be cleaned after the report is saved:
- Run `./.github/skills/qa-review/scripts/cleanup.sh copilot/qa_review/tmp` after writing the report.
- If files remain after a failed or cancelled run, the next `collect_infra_diff.sh` invocation cleans old artifacts before starting.

## Things to Watch For

- **Subtle load amplifiers**: A feature added to homescreen gets fetched on every unlock — can 10x endpoint traffic.
- **Request body changes**: New required fields in request models that the backend must support.
- **Token-related changes**: Be extra alert for token services, token fetchers, auth interceptors, `Cookie`/`Authorization` header changes, shared-pref token keys, token invalidation, token refresh, JWT/SSO handling, and per-user token persistence changes.
- **Service-module wiring changes**: A changed `*_service_module.dart` file can affect every URL wired through that module even when the endpoint declaration is untouched.
- **Error handling changes**: Different error response handling may indicate backend contract changes.
- **Feature toggle gating**: New toggles mean traffic won't appear until the toggle is enabled — mention this to the server team.
- **Polling/refresh intervals**: If debounce or polling durations changed, it directly affects request frequency.
