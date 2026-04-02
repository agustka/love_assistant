# Code Review Templates

## Table Of Contents
- Template A - Cleanup Command
- Template B - Review Report Markdown

## Template A - Cleanup Command

```bash
./.github/skills/code-review/scripts/cleanup.sh <output_dir>
```

## Template B - Review Report Markdown

```markdown
# Code Review: <scope/feature>
**Date**: YYYY-MM-DD
**Branch**: <branch name>
**Review scope**: uncommitted changes | branch diff against PR base
**Files reviewed**: N files, +X/-Y lines

## Summary
[1-3 sentence overall assessment. Is this a net positive change?]

## PR
[One sentence, max ~20 words, describing what lands in master if this merges. If it should not merge, write: Do not merge as-is.]

## Critical Issues
- **[File:Line]** - [Description, engineering principle violated, suggested fix]

## Improvements
- **[File:Line]** - [Suggestion and rationale]

## Nitpicks
- **Nit: [File:Line]** - [Minor detail]

## What's Done Well
- [Positive observations - acknowledge good patterns]

## Files Skipped
- [List of generated Dart files and golden test images excluded from review]
```
