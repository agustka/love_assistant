#!/usr/bin/env bash
# Orchestrates the full diff-gathering flow: collects diff artifacts,
# builds the structured manifest, and prints hotspots — all in one command.
set -euo pipefail

scope="${1:-}"

if [[ "$#" -gt 1 ]]; then
  echo "Usage: run_full_review.sh [scope]" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/_common.sh"

output_dir="$(default_output_dir_create)"

if ! is_session_output_dir "$output_dir"; then
  echo "Refusing output_dir that does not match session format: $output_dir" >&2
  echo "Expected: ${REVIEW_OUTPUT_BASE:-copilot/code_review_reports}/<DD_MMTHH_MM_SS>_<model>_<role>_<rand5>/tmp" >&2
  exit 1
fi

if [[ "${SKIP_PERMISSION_PREFLIGHT:-0}" != "1" ]]; then
  bash "$script_dir/permission_preflight.sh"
  export SKIP_PERMISSION_PREFLIGHT=1
fi

REVIEW_OUTPUT_DIR="$output_dir" "$script_dir/collect_scope_and_diff_artifacts.sh" "$scope"
"$script_dir/build_structured_manifest.sh" "$output_dir"
"$script_dir/print_diff_hotspots.sh" "$output_dir"

echo "DONE: full review support flow completed"
echo "Manifest: $output_dir/manifest_body.md"
echo "Summary:  $output_dir/per_file_summary.tsv"
