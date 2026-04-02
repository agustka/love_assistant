#!/usr/bin/env bash
# Removes temporary QA review artifacts from the output directory.
set -euo pipefail

output_dir_input="${1:-copilot/qa_review/tmp}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/_common.sh"
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

if ! is_allowed_output_dir "$output_dir"; then
  echo "Cleanup refused: output_dir outside QA scratch paths: $output_dir" >&2
  echo "Allowed prefix: $workspace_root/copilot/qa_review/" >&2
  exit 1
fi

if [[ -d "$output_dir" ]]; then
  file_count=$(find "$output_dir" -type f 2>/dev/null | wc -l | tr -d ' ')
  echo "Cleanup: $file_count files scheduled for deletion in $output_dir"
  rm -rf -- "$output_dir"
  echo "Cleanup complete: removed $output_dir (deleted $file_count files)"
else
  echo "Nothing to clean up: $output_dir does not exist"
fi
