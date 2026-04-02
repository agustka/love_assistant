# QA Review Templates

## Table Of Contents
- Template A - Diff Gatherer Prompt (git-specialist)
- Template B - Infrastructure Deep Dive Prompt (Default Subagent)
- Template C - All-Layer Deep Dive Prompt (Explore)
- Template D - Teams Message Template

## Template A - Diff Gatherer Prompt (git-specialist)

```text
Gather diffs for QA review using the bundled scripts in the qa-review skill. Return a structured summary - do NOT return raw diff output.

CRITICAL RULES:
- Do NOT use /tmp/, mktemp, or any OS temp directory.
- Run cleanup.sh at the end of the workflow.
- Use ONLY the bundled scripts - do not run manual git-diff one-liners.

Steps:
1. Run the collection script:
   ./.github/skills/qa-review/scripts/collect_infra_diff.sh <older_ref> [output_dir]
   For explicit two-ref mode:
   ./.github/skills/qa-review/scripts/collect_infra_diff.sh --legacy <ref_a> <ref_b> [output_dir]

   Default output_dir: copilot/qa_review/tmp

2. Read the generated artifacts and return their contents:
   - Read <output_dir>/summary.txt
   - Read <output_dir>/from_ref.txt and <output_dir>/to_ref.txt
   - Read <output_dir>/general/general_summary.txt
   - Include the output_dir path so the main agent can reference artifacts.

3. Return this structure:
   - **Output dir**: the path where artifacts were collected
   - **From ref**: contents of from_ref.txt
   - **To ref**: contents of to_ref.txt
   - **Infrastructure summary**: full contents of summary.txt
   - **General summary**: full contents of general/general_summary.txt (includes per-layer file counts and commit log)
   - **Endpoint changes preview**: first 50 lines of endpoint_changes.txt (or full if shorter)
```

## Template B - Infrastructure Deep Dive Prompt (Default Subagent)

```text
Perform the infrastructure-layer deep dive for QA review using artifacts already collected in <output_dir>. Return structured findings only.

Scope:
- Endpoint surface changes (added/modified/removed)
- Service-module wiring implications
- Token/interceptor behavior changes
- Header behavior changes
- Caching and lifecycle-trigger changes
- Homescreen-related load impact

Mandatory outputs:
1) Potentially affected URLs (deduplicated)
2) Token-interceptor verdict: Yes/No, with summary and affected URLs when Yes
3) Header verdict: Yes/No, with summary and affected URLs when Yes
4) Categorized findings for: New/Modified/Removed Endpoints, Auth and Token, Header, Caching, Lifecycle, HomeScreen Impact, Load Impact

Rules:
- Use diff_artifacts_map.tsv to resolve per-file artifacts
- Do not return raw diff dumps
- Keep statements evidence-based and concise
```

## Template C - All-Layer Deep Dive Prompt (Explore)

```text
Perform an all-layer deep dive for QA review using <output_dir>/general artifacts and selected diffs as needed. Return a concise product-impact summary.

Goal:
- Produce 3-8 high-signal bullets describing user-facing and behavioral changes across all layers.

Rules:
- Focus on feature/flow/behavior impact
- Do NOT mention Dart file names, class names, cubits, widgets, or code artifacts
- Keep each bullet one sentence
- Ignore infrastructure checklist mechanics (handled by infra deep dive)
```

## Template D - Teams Message Template

```markdown
## TEAMS MESSAGE TO PASTE

🚀 **Infrastructure Changes: <from_version> → <to_version>**
⚠️ THIS IS AN LLM GENERATED REPORT ⚠️
⚠️ CONTENT MIGHT CONTAIN INACCURATE INFORMATION ⚠️

**Default Review Checklist**

1. **Potentially affected URLs:** <comma-separated URLs/paths, or `None identified`>
2. **Token-interceptor changes:** <`Yes - <brief change summary>` or `No - No change detected`>
   - If Yes: **Affected URLs:** <comma-separated URLs/paths or `None`>
3. **Header changes:** <`Yes - <brief change summary>` or `No - No change detected`>
   - If Yes: **Affected URLs:** <comma-separated URLs/paths or `None`>

**Summary**

- <very brief highest-signal change>
- <very brief highest-signal change>
- <very brief highest-signal change>

---

## Detailed Report

🚀 **Infrastructure Changes: <from_version> → <to_version>**

📋 **General Changes**

- <plain-English user-facing change - may be more detailed than the Teams paste version>
- <plain-English user-facing change>
- <plain-English user-facing change>

**Default Review Checklist**

1. **Potentially affected URLs:** <full deduplicated URL/path list>
2. **Token-interceptor changes:** <`Yes - <full explanation>` or `No - No change detected`>
   - If Yes: **Affected URLs:** <full list or `None`>
3. **Header changes:** <`Yes - <full explanation>` or `No - No change detected`>
   - If Yes: **Affected URLs:** <full list or `None`>

---

🆕 **New Endpoints**
- `<HTTP_METHOD> <base_url><path>` - <brief description of purpose>

✏️ **Modified Endpoints**
- `<HTTP_METHOD> <base_url><path>` - <what changed: params, response, etc.>

🗑️ **Removed Endpoints**
- `<HTTP_METHOD> <base_url><path>` - <was used for X>

🏠 **HomeScreen Impact**
- ⚠️ `<endpoint>` now called from homescreen - **expect increased traffic on every app unlock**
- <widget/feature> removed from homescreen - reduced load on `<endpoint>`

🔐 **Auth and Token Changes**
- <description of auth/token changes and affected endpoints>

📋 **Header Changes**
- `<header_name>` added to `<endpoint>` - <why it matters>

⏱️ **Caching Changes**
- <model/repo> cache TTL changed: <old> → <new>
- New cache added for <model>

🔄 **Lifecycle Triggers (Unlock / Lock / User Switch)**
- New call on unlock: `<endpoint>`
- <behavior> changed on user switch

📦 **Model Changes**
- `<ModelName>` - <N> new fields, <M> removed fields
- New model: `<ModelName>` for <endpoint>

🚩 **Feature Toggles**
- New toggle `<toggle_name>` gates `<endpoint/feature>`

⚡ **Load Impact Summary**
- <overall assessment of traffic changes>
```
