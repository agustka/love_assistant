#!/usr/bin/env bash
# Shared utility functions for qa-review scripts.
# Sourced by collect_infra_diff.sh.

extract_release_version() {
  python3 - "$1" <<'PY'
import re
import sys

matches = re.findall(r'(\d+(?:\.\d+)+)', sys.argv[1])
print(matches[-1] if matches else "")
PY
}

compare_versions() {
  python3 - "$1" "$2" <<'PY'
import sys

def normalize(value: str) -> list[int]:
    return [int(part) for part in value.split('.')]

a = normalize(sys.argv[1])
b = normalize(sys.argv[2])
width = max(len(a), len(b))
a.extend([0] * (width - len(a)))
b.extend([0] * (width - len(b)))

if a < b:
    print(-1)
elif a > b:
    print(1)
else:
    print(0)
PY
}

fetch_remote_refs() {
  echo "Refreshing remotes: git fetch --all --prune"
  git fetch --all --prune
}

resolve_remote_tracking_ref() {
  local ref="$1"

  if [[ "$ref" == "HEAD" ]]; then
    echo "$ref"
    return
  fi

  if git show-ref --verify --quiet "refs/remotes/$ref"; then
    echo "$ref"
    return
  fi

  if git show-ref --verify --quiet "refs/tags/$ref"; then
    echo "$ref"
    return
  fi

  if git show-ref --verify --quiet "refs/heads/$ref"; then
    local upstream
    upstream="$(git for-each-ref --format='%(upstream:short)' "refs/heads/$ref" | head -1)"
    if [[ -n "$upstream" ]] && git show-ref --verify --quiet "refs/remotes/$upstream"; then
      echo "$upstream"
      return
    fi
  fi

  if git show-ref --verify --quiet "refs/remotes/origin/$ref"; then
    echo "origin/$ref"
    return
  fi

  local remote_matches
  remote_matches="$(git for-each-ref --format='%(refname:short)' "refs/remotes/*/$ref")"
  if [[ -n "$remote_matches" ]] && [[ "$(echo "$remote_matches" | wc -l | tr -d ' ')" == "1" ]]; then
    echo "$remote_matches"
    return
  fi

  echo "$ref"
}

normalized_by_version=false
release_order_swapped=false
normalized_from_ref=""
normalized_to_ref=""

normalize_release_order() {
  local left_ref="$1"
  local right_ref="$2"
  local left_version
  local right_version
  local comparison

  normalized_by_version=false
  release_order_swapped=false
  normalized_from_ref="$left_ref"
  normalized_to_ref="$right_ref"

  left_version="$(extract_release_version "$left_ref")"
  right_version="$(extract_release_version "$right_ref")"

  if [[ -z "$left_version" || -z "$right_version" ]]; then
    return
  fi

  normalized_by_version=true
  comparison="$(compare_versions "$left_version" "$right_version")"

  if [[ "$comparison" == "1" ]]; then
    normalized_from_ref="$right_ref"
    normalized_to_ref="$left_ref"
    release_order_swapped=true
  fi
}

resolve_path() {
  python3 -c "import os,sys; print(os.path.realpath(os.path.abspath(sys.argv[1])))" "$1"
}

# Validates that output_dir is under an allowed QA scratch path.
# Requires $workspace_root to be set before calling.
is_allowed_output_dir() {
  local candidate="$1"
  case "$candidate" in
    "$workspace_root"/copilot/qa_review/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}
