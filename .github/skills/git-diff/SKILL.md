---
name: git-diff
description: >-
  Use this skill to understand what has changed in the current working branch —
  before making changes, focusing a review, scoping a task, or answering
  questions about what is new or modified. Trigger whenever an agent needs to
  know what files have been added, changed, or deleted relative to the staging branch.
---

# Git Diff

A lightweight procedure for detecting the current change situation in the repository. Use this to orient before acting — not to produce review artifacts.

---

## Step 1: Identify the current branch and base

```bash
git branch --show-current
git merge-base HEAD origin/staging
```

This gives you the branch name and the commit where it diverged from the base. Use the merge-base SHA as `<base>` in subsequent commands.

---

## Step 2: Get the list of changed files

```bash
# Files changed on the branch vs base
git diff --name-status <base>...HEAD

# Uncommitted changes (staged + unstaged)
git status --short
```

`--name-status` output uses single-letter codes:

| Code | Meaning |
|---|---|
| `A` | Added |
| `M` | Modified |
| `D` | Deleted |
| `R` | Renamed |

---

## Step 3: Read the diff when needed

```bash
# Full diff for the branch
git diff <base>...HEAD

# Diff for a specific file only
git diff <base>...HEAD -- <path>
```

For large diffs, prefer reading file-by-file rather than the full output at once.

---

## Interpreting the situation

Once you have the changed file list, orient around:

- **What is new** (`A`) — focus here if the task is about new functionality
- **What is modified** (`M`) — focus here if the task is about changes to existing behaviour
- **What is deleted** (`D`) — note removals that might affect dependents
- **Scope** — a small focused diff vs a broad one changes how much context you need before acting

Use this orientation to decide what to read next, not as a final answer in itself.