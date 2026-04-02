# Git Diff Templates

## Table Of Contents
- Template A - Diff Gatherer Prompt (git-specialist)

## Template A - Diff Gatherer Prompt (git-specialist)

```text
Gather the git diff for review using the bundled scripts in the git-diff skill. Return the structured change manifest - do NOT return raw diff output.

CRITICAL RULES:
- Do NOT use /tmp/, mktemp, or any OS temp directory.
- Do NOT run cleanup.sh - the calling workflow handles cleanup after the report is written.
- Use ONLY the bundled scripts - do not run manual git-diff one-liners.

Steps:
1. Set environment:
   export REVIEW_MODEL="<model-slug>"   # e.g. claude-opus-4.6, gpt-5-3-codex
   export REVIEW_ROLE="subagent"

2. Run the full review flow:
   ./.github/skills/git-diff/scripts/run_full_review.sh <scope>
   (scope: auto | uncommitted | branch | <ref>...HEAD)

3. Read the generated manifest and return its contents:
   - Read <output_dir>/manifest_body.md (the structured change manifest).
   - Include the output_dir path so the caller can reference it for cleanup.

4. Return this structure:
   - **Output dir**: the session path created by the script
   - **Review scope**: uncommitted | branch (name) | both
   - **Manifest**: full contents of manifest_body.md
   - **Hotspots**: any high-churn files printed by the script
   - **Files skipped from review**: list of excluded generated Dart files and golden test images
```
