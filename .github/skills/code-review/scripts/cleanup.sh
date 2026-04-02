#!/usr/bin/env bash
# Removes temporary review artifacts from the output directory.
# Run this after the review report has been written to clean up scratch files.
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: cleanup.sh <output_dir>" >&2
  exit 1
fi

output_dir_input="$1"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/../../git-diff/scripts/_common.sh"
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
output_dir="$(resolve_path "$output_dir_input")"

if [[ -z "$output_dir" || "$output_dir" == "/" || "$output_dir" == "$workspace_root" ]]; then
  echo "Cleanup refused: unsafe output_dir '$output_dir'" >&2
  exit 1
fi

if [[ "$output_dir" != "$workspace_root"/* ]]; then
  echo "Cleanup refused: output_dir is outside workspace: $output_dir" >&2
  echo "Workspace root: $workspace_root" >&2
  exit 1
fi

if ! is_session_output_dir "$output_dir" "$workspace_root"; then
  echo "Cleanup refused: output_dir must match session format: $output_dir" >&2
  echo "Expected: copilot/code_review_reports/<DD_MMTHH_MM_SS>_<model>_<role>_<rand5>/tmp" >&2
  exit 1
fi

if [[ -d "$output_dir" ]]; then
  file_count=$(find "$output_dir" -type f 2>/dev/null | wc -l | tr -d ' ')
  echo "Cleanup: $file_count files scheduled for deletion in $output_dir"
  if [[ "$file_count" != "0" ]]; then
    echo "Cleanup: files to delete:"
    find "$output_dir" -type f 2>/dev/null | sort | sed 's/^/ - /'
  fi
  rm -rf -- "$output_dir"
  echo "Cleanup complete: removed $output_dir (deleted $file_count files)"

  parent_dir="$(dirname "$output_dir")"
  if [[ -d "$parent_dir" ]] && [[ -z "$(find "$parent_dir" -mindepth 1 -maxdepth 1 2>/dev/null)" ]]; then
    rmdir "$parent_dir"
    echo "Cleanup complete: removed empty parent directory $parent_dir"
  fi
else
  echo "Nothing to clean up: $output_dir does not exist"
fi
