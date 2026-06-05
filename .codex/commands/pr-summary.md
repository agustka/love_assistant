Compare this local branch/worktree against the local `main` branch and write a concise,
non-technical pull request summary in bullet-point form — no specific code references,
written in a general tone suitable for technical and non-technical readers alike.

Then publish that summary to GitHub using `gh`. There will not always be an open PR
when this command runs, so follow this procedure:

## 0. Establish the PR branch

First check the current branch:

```bash
git branch --show-current
```

### If currently on `main`

Do not create or update a PR directly from `main`.

1. Inspect the worktree changes, including untracked files:

```bash
git status --short
git diff --stat
git ls-files --others --exclude-standard
```

2. Derive a short branch name from the work, using lowercase words separated by hyphens:

```bash
git switch -c <short-feature-branch>
```

3. Build the PR summary from the worktree diff and untracked files.
4. Stage and commit the work before pushing:

```bash
git add -A
git commit -m "<short human-readable commit title>"
```

5. Continue to the PR detection/publishing steps below from the new branch.

If there are unrelated changes mixed into the worktree and it is not clear whether they should be included,
stop and ask before staging or committing. Never silently omit or include ambiguous changes.

### If already on a non-`main` branch

Continue with the existing branch. Include both committed branch changes and uncommitted worktree changes
in the summary. If uncommitted changes are present and no PR exists yet, stage and commit them before pushing
unless they are clearly unrelated; ask if the scope is ambiguous.

## 1. Build the summary

- Diff the current branch against `main` (e.g. `git diff main...HEAD --stat` and
  `git log main..HEAD --oneline`) to understand what changed.
- Also inspect uncommitted changes when present (e.g. `git diff --stat` and
  `git ls-files --others --exclude-standard`) so the summary matches what will be committed/pushed.
- Draft the summary as markdown bullet points. Keep it high-level and outcome-focused.
- Write the summary to a temp file so multi-line markdown survives intact:
  `gh` reads it via `--body-file`. Example: write it to `/tmp/pr-summary.md`.

## 2. Detect whether a PR already exists for this branch

```bash
gh pr view --json number,url -q .number 2>/dev/null
```

- If this prints a number, a PR exists — go to step 3a.
- If it errors / prints nothing, no PR exists — go to step 3b.

## 3a. PR exists -> update its body

```bash
gh pr edit --body-file /tmp/pr-summary.md
```

Report back the PR URL.

## 3b. No PR exists -> create one

Make sure the branch is pushed first (creating a PR requires a remote branch):

```bash
git push -u origin HEAD
```

Then create the PR against `main`, using the summary as the body. Derive a short,
human-readable title from the branch's changes (not the raw branch name):

```bash
gh pr create --base main --title "<short title>" --body-file /tmp/pr-summary.md
```

Report back the URL of the newly created PR.

## Notes

- Never paste the full diff or raw commit list into the PR body — only the curated summary.
- If `gh push` or `gh pr create` fails (e.g. no remote, auth), surface the error and
  fall back to printing the summary in chat so it can be pasted manually.
