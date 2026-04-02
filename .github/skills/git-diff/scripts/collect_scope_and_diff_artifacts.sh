#!/usr/bin/env bash
# Resolves the git diff scope (base ref), then collects all diff artifacts
# (branch stats, relevant files, per-file summary TSV, generated file list)
# into an output directory for downstream review scripts.
#
# Usage:
#   collect_scope_and_diff_artifacts.sh [scope]
#
# Scope values:
#   (empty)       — auto mode (prefer uncommitted when both exist)
#   uncommitted   — review staged + unstaged + untracked changes vs HEAD
#   branch        — current checked-out branch diff vs base ref (<base_ref>...HEAD)
#   auto          — detect uncommitted + branch commits, prefer uncommitted
#   <ref>...HEAD  — explicit three-dot range (PR-only diff)
#   <ref>..HEAD   — explicit two-dot range
set -euo pipefail

scope="${1:-}"
requested_scope="${scope:-auto}"

if [[ "$#" -gt 1 ]]; then
  echo "Usage: collect_scope_and_diff_artifacts.sh [scope]" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/_common.sh"

output_dir="${REVIEW_OUTPUT_DIR:-$(default_output_dir_create)}"
workspace_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

resolve_path() {
  local path_input="$1"
  python3 - "$path_input" <<'PY'
import os
import sys

print(os.path.realpath(os.path.abspath(sys.argv[1])))
PY
}

workspace_root="$(resolve_path "$workspace_root")"
output_dir="$(resolve_path "$output_dir")"

if [[ "$output_dir" == "/" || "$output_dir" == "$workspace_root" ]]; then
  echo "Refusing unsafe output_dir: $output_dir" >&2
  exit 1
fi

if ! is_session_output_dir "$output_dir" "$workspace_root"; then
  echo "Refusing output_dir that does not match session format: $output_dir" >&2
  echo "Expected: ${REVIEW_OUTPUT_BASE:-copilot/code_review_reports}/<DD_MMTHH_MM_SS>_<model>_<role>_<rand5>/tmp" >&2
  echo "Set REVIEW_OUTPUT_DIR to a compliant session path when overriding output_dir." >&2
  exit 1
fi

if [[ "$output_dir" != "$workspace_root"/* ]]; then
  echo "Refusing output_dir outside workspace: $output_dir" >&2
  echo "Workspace root: $workspace_root" >&2
  exit 1
fi

if [[ "${SKIP_PERMISSION_PREFLIGHT:-0}" != "1" ]]; then
  bash "$script_dir/permission_preflight.sh"
fi

if [[ -d "$output_dir" ]] && [[ -n "$(find "$output_dir" -mindepth 1 -maxdepth 1 2>/dev/null)" ]]; then
  echo "Refusing to use non-empty output_dir: $output_dir" >&2
  echo "Cleanup is a separate final step after report creation. Use a new session output_dir or run cleanup explicitly." >&2
  exit 1
fi

resolve_base_ref() {
  local candidates=()
  if [[ -n "${BASE_REF:-}" ]]; then
    candidates+=("$BASE_REF")
  fi
  candidates+=("origin/master" "master")

  for candidate in "${candidates[@]}"; do
    if git rev-parse --verify "$candidate" >/dev/null 2>&1; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

# --- Resolve scope and base_ref ---
base_ref=""
if [[ "$scope" == *"...HEAD" ]]; then
  base_ref="${scope%...HEAD}"
elif [[ "$scope" == *"..HEAD" ]]; then
  base_ref="${scope%..HEAD}"
fi

if [[ -z "$base_ref" ]]; then
  base_ref="$(resolve_base_ref || true)"
fi

if [[ "$scope" == "uncommitted" ]]; then
  # Uncommitted mode: compare working tree (staged + unstaged) against HEAD.
  # Keep resolved base_ref for branch-commit visibility in the manifest.
  scope="HEAD"
elif [[ -z "$scope" || "$scope" == "auto" ]]; then
  # Auto mode: if uncommitted changes exist, prefer those for faster feedback.
  # Otherwise, review current checked-out branch against base ref.
  has_uncommitted="0"
  if [[ -n "$(git status --porcelain)" ]]; then
    has_uncommitted="1"
  fi

  if [[ "$has_uncommitted" == "1" ]]; then
    scope="HEAD"
  else
    if [[ -z "$base_ref" ]]; then
      echo "Unable to resolve base ref for branch diff. Set BASE_REF or pass explicit scope (e.g. origin/master...HEAD)." >&2
      exit 1
    fi
    scope="$base_ref...HEAD"
  fi
elif [[ "$scope" == "branch" ]]; then
  if [[ -z "$base_ref" ]]; then
    echo "Unable to resolve base ref for branch mode. Set BASE_REF or pass explicit scope (e.g. origin/master...HEAD)." >&2
    exit 1
  fi
  scope="$base_ref...HEAD"
elif [[ "$scope" == *"...HEAD" || "$scope" == *"..HEAD" ]]; then
  # Explicit revision range provided by caller; keep as-is.
  :
else
  echo "Unsupported scope '$scope'. Use one of: auto, uncommitted, branch, <ref>...HEAD, <ref>..HEAD." >&2
  exit 1
fi

mkdir -p "$output_dir"

printf '%s\n' "$scope" > "$output_dir/scope.txt"
printf '%s\n' "${base_ref:-unknown}" > "$output_dir/base_ref.txt"
printf '%s\n' "$requested_scope" > "$output_dir/requested_scope.txt"

git branch --show-current > "$output_dir/branch.txt"
git status --porcelain > "$output_dir/status.txt"
git log --oneline "${base_ref:-HEAD}"..HEAD > "$output_dir/log_master_head.txt" 2>/dev/null || true
git diff --stat > "$output_dir/stat_unstaged.txt"
git diff --cached --stat > "$output_dir/stat_staged.txt"
git diff "$scope" --stat > "$output_dir/stat_branch.txt"

is_uncommitted_scope=0
if [[ "$scope" == "HEAD" ]]; then
  is_uncommitted_scope=1
  git ls-files --others --exclude-standard | sort -u > "$output_dir/untracked_all.txt"
else
  : > "$output_dir/untracked_all.txt"
fi

if [[ "$is_uncommitted_scope" == "1" ]]; then
  {
    git diff --name-only --diff-filter=ACMRD "$scope" -- .
    cat "$output_dir/untracked_all.txt"
  } \
    | sort -u \
    | filter_reviewable_paths > "$output_dir/relevant_files.txt"
else
  git diff --name-only --diff-filter=ACMRD "$scope" -- . \
    | sort -u \
    | filter_reviewable_paths > "$output_dir/relevant_files.txt"
fi

if [[ "$is_uncommitted_scope" == "1" ]]; then
  {
    git diff --name-only --diff-filter=ACMRD "$scope" -- .
    cat "$output_dir/untracked_all.txt"
  } | sort -u > "$output_dir/generated_skipped.txt"
else
  git diff --name-only --diff-filter=ACMRD "$scope" -- . | sort -u > "$output_dir/generated_skipped.txt"
fi

tmp_skipped="$output_dir/.review_skipped_all.txt"
mv "$output_dir/generated_skipped.txt" "$tmp_skipped"
filter_review_skipped_paths < "$tmp_skipped" > "$output_dir/generated_skipped.txt"
rm -f "$tmp_skipped"

# Pre-compute numstat for all files in one call (avoids N per-file subprocess invocations).
# Binary files output "-\t-\tfilename" — handled below.
git diff --numstat --diff-filter=ACMRD "$scope" > "$output_dir/.numstat_cache.tsv" 2>/dev/null || true

while IFS= read -r f; do
  [[ -z "$f" ]] && continue

  # Look up add/del from pre-computed numstat (tab-delimited: add\tdel\tfile)
  ns=$(awk -F '\t' -v file="$f" '$3 == file {print; exit}' "$output_dir/.numstat_cache.tsv")
  add=$(printf '%s' "$ns" | awk -F '\t' '{print $1}')
  del=$(printf '%s' "$ns" | awk -F '\t' '{print $2}')
  [[ -z "$add" || "$add" == "-" ]] && add=0
  [[ -z "$del" || "$del" == "-" ]] && del=0

  is_untracked=0
  if [[ "$is_uncommitted_scope" == "1" ]] && grep -Fqx -- "$f" "$output_dir/untracked_all.txt"; then
    is_untracked=1
    if [[ -f "$f" ]]; then
      add=$(wc -l < "$f" | tr -d ' ')
    else
      add=0
    fi
    del=0
  fi

  # Single diff call per file: extract diff_lines, hunks, and sample lines in one awk pass.
  # This replaces 4 separate git-diff + grep/sed pipelines from the original.
  if [[ "$is_untracked" == "1" ]]; then
    { git diff --no-index -U3 -- /dev/null "$f" 2>/dev/null || true; } | awk -v file="$f" -v add="$add" -v del="$del" '
      BEGIN { hunks=0; got_r=0; got_a=0; removed=""; added="" }
      /^@@/ { hunks++ }
      /^-/ && !/^---/ {
        if (!got_r) {
          line = substr($0, 2)
          gsub(/^[ \t]+/, "", line)
          if (line != "" && substr(line,1,2) != "//") {
            removed = substr(line, 1, 120)
            got_r = 1
          }
        }
      }
      /^\+/ && !/^\+\+\+/ {
        if (!got_a) {
          line = substr($0, 2)
          gsub(/^[ \t]+/, "", line)
          if (line != "" && substr(line,1,2) != "//") {
            added = substr(line, 1, 120)
            got_a = 1
          }
        }
      }
      END {
        diff_lines = NR + 0
        trunc = "no"
        omitted = 0
        if (diff_lines > 200) {
          omitted = diff_lines - 70
          trunc = "yes"
        }
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t- %s | + %s\n", file, add, del, hunks, diff_lines, trunc, omitted, removed, added
      }
    '
  else
    git diff -U3 "$scope" -- "$f" | awk -v file="$f" -v add="$add" -v del="$del" '
      BEGIN { hunks=0; got_r=0; got_a=0; removed=""; added="" }
      /^@@/ { hunks++ }
      /^-/ && !/^---/ {
        if (!got_r) {
          line = substr($0, 2)
          gsub(/^[ \t]+/, "", line)
          if (line != "" && substr(line,1,2) != "//") {
            removed = substr(line, 1, 120)
            got_r = 1
          }
        }
      }
      /^\+/ && !/^\+\+\+/ {
        if (!got_a) {
          line = substr($0, 2)
          gsub(/^[ \t]+/, "", line)
          if (line != "" && substr(line,1,2) != "//") {
            added = substr(line, 1, 120)
            got_a = 1
          }
        }
      }
      END {
        diff_lines = NR + 0
        trunc = "no"
        omitted = 0
        if (diff_lines > 200) {
          omitted = diff_lines - 70
          trunc = "yes"
        }
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t- %s | + %s\n", file, add, del, hunks, diff_lines, trunc, omitted, removed, added
      }
    '
  fi
done < "$output_dir/relevant_files.txt" > "$output_dir/per_file_summary.tsv"

rm -f "$output_dir/.numstat_cache.tsv" "$output_dir/untracked_all.txt"

echo "DONE: artifacts generated in $output_dir"
