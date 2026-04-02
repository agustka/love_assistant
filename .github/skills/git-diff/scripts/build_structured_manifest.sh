#!/usr/bin/env bash
# Assembles a Markdown "Structured Change Manifest" from the diff artifacts
# produced by collect_scope_and_diff_artifacts.sh. The manifest includes per-file
# stats, generated-file skip list, and high-risk hotspots.
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: build_structured_manifest.sh <output_dir> [output_file]" >&2
  exit 1
fi

output_dir="$1"
output_file="${2:-$output_dir/manifest_body.md}"

required=(
  "$output_dir/branch.txt"
  "$output_dir/scope.txt"
  "$output_dir/stat_unstaged.txt"
  "$output_dir/stat_staged.txt"
  "$output_dir/log_master_head.txt"
  "$output_dir/stat_branch.txt"
  "$output_dir/relevant_files.txt"
  "$output_dir/per_file_summary.tsv"
  "$output_dir/generated_skipped.txt"
)

for file in "${required[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required input: $file" >&2
    exit 1
  fi
done

: > "$output_file"
branch=$(tr -d '\n' < "$output_dir/branch.txt")
resolved_scope=$(tr -d '\n' < "$output_dir/scope.txt")

has_uncommitted=0
if [[ -s "$output_dir/stat_unstaged.txt" || -s "$output_dir/stat_staged.txt" ]]; then
  has_uncommitted=1
fi

has_branch_commits=0
if [[ -s "$output_dir/log_master_head.txt" ]]; then
  has_branch_commits=1
fi

# Determine preferred scope — honor explicit caller intent when set.
requested_scope="auto"
if [[ -f "$output_dir/requested_scope.txt" ]]; then
  requested_scope=$(tr -d '\n' < "$output_dir/requested_scope.txt")
fi

if [[ "$requested_scope" == "branch" || "$requested_scope" == *"...HEAD" || "$requested_scope" == *"..HEAD" ]]; then
  scope='branch'
  preferred='branch'
elif [[ "$requested_scope" == "uncommitted" ]]; then
  scope='uncommitted'
  preferred='uncommitted'
else
  # Determine display scope in auto mode (what actually exists).
  if [[ "$has_uncommitted" -eq 1 && "$has_branch_commits" -eq 1 ]]; then
    scope='both'
  elif [[ "$has_uncommitted" -eq 1 ]]; then
    scope='uncommitted'
  else
    scope='branch'
  fi

  # Auto mode: prefer uncommitted when present, else branch.
  if [[ "$has_uncommitted" -eq 1 ]]; then
    preferred='uncommitted'
  else
    preferred='branch'
  fi
fi

printf '### Structured Change Manifest\n\n' >> "$output_file"
printf -- '- Review scope: %s\n' "$scope" >> "$output_file"
printf -- '- Preferred scope to review now: %s\n' "$preferred" >> "$output_file"
printf -- '- Branch name: %s\n\n' "$branch" >> "$output_file"

printf '#### Files changed\n' >> "$output_file"
rel_count=$(wc -l < "$output_dir/relevant_files.txt" | tr -d ' ')
rel_add=$(awk -F '\t' 'NF>=3{a+=$2}END{print a+0}' "$output_dir/per_file_summary.tsv")
rel_del=$(awk -F '\t' 'NF>=3{d+=$3}END{print d+0}' "$output_dir/per_file_summary.tsv")
skip_count=$(wc -l < "$output_dir/generated_skipped.txt" | tr -d ' ')

printf -- '- Reviewable files (%s): %s files, +%s/-%s\n' "$resolved_scope" "$rel_count" "$rel_add" "$rel_del" >> "$output_file"
printf -- '- Files skipped from review: %s\n\n' "$skip_count" >> "$output_file"

printf '#### Per-file changes\n' >> "$output_file"
awk -F '\t' '{printf "- %s | +%s/-%s | hunks=%s | diffLines=%s | truncated=%s | omitted=%s | %s\n",$1,$2,$3,$4,$5,$6,$7,$8}' "$output_dir/per_file_summary.tsv" >> "$output_file"

printf '#### Files skipped from review\n' >> "$output_file"
if [[ -s "$output_dir/generated_skipped.txt" ]]; then
  awk '{printf "- %s\n",$0}' "$output_dir/generated_skipped.txt" >> "$output_file"
else
  printf -- '- None\n' >> "$output_file"
fi

printf '\n#### High-risk hotspots to inspect deeply\n' >> "$output_file"
awk -F '\t' 'NF>=3 {score=$2+$3; if(score>=120) print score"\t"$1}' "$output_dir/per_file_summary.tsv" | sort -nr | head -n 20 | awk -F '\t' '{printf "- %s (churn=%s)\n",$2,$1}' >> "$output_file"

echo "DONE: manifest written to $output_file"
