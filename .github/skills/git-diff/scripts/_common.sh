#!/usr/bin/env bash
# Shared helpers for git-diff scripts.
# Source this file — do not execute directly.

# Creator variant: generates a new uniquely-named output directory path.
# Uses env vars REVIEW_MODEL (default: unknown) and REVIEW_ROLE (default: main)
# plus a random 5-char suffix to prevent collisions across parallel reviews.
# REVIEW_OUTPUT_BASE overrides the base path (default: copilot/code_review_reports).
default_output_dir_create() {
  local base="${REVIEW_OUTPUT_BASE:-copilot/code_review_reports}"
  local timestamp
  timestamp="$(date +%d_%mT%H_%M_%S)"

  local model="${REVIEW_MODEL:-unknown}"
  local role="${REVIEW_ROLE:-main}"

  # Sanitize for filesystem: lowercase, non-alnum to dash, collapse dashes
  model="$(printf '%s' "$model" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')"
  role="$(printf '%s' "$role" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')"

  local rand5
  rand5="$(python3 -c 'import random,string; print("".join(random.choices(string.ascii_lowercase + string.digits, k=5)))')"

  echo "${base}/${timestamp}_${model}_${role}_${rand5}/tmp"
}

is_session_output_dir() {
  local output_dir="$1"
  local workspace_root="${2:-}"
  local base="${REVIEW_OUTPUT_BASE:-copilot/code_review_reports}"
  local output_rel="$output_dir"

  if [[ -n "$workspace_root" && "$output_dir" == "$workspace_root"/* ]]; then
    output_rel="${output_dir#$workspace_root/}"
  fi

  # Escape special regex chars in base path for ERE matching
  local base_regex
  base_regex="$(printf '%s' "$base" | sed 's/[.[\*^$()+?{|\\]/\\&/g')"

  local pattern="^${base_regex}/[0-9]{2}_[0-9]{2}T[0-9]{2}_[0-9]{2}_[0-9]{2}_[a-z0-9-]+_[a-z0-9-]+_[a-z0-9]{5}/tmp$"
  [[ "$output_rel" =~ $pattern ]]
}

filter_reviewable_paths() {
  local base="${REVIEW_OUTPUT_BASE:-copilot/code_review_reports}"
  # Escape slashes for awk regex
  local base_awk
  base_awk="$(printf '%s' "$base" | sed 's/\//\\\//g')"
  awk -v base="$base_awk" '
    !($0 ~ /\.(g|freezed|chopper|mocks|config)\.dart$/) &&
    !($0 ~ "^" base "/.*\\.md$") &&
    !($0 ~ /(^|\/)(golden|goldens|failures)\/.*\.(png|jpg|jpeg|webp)$/)
  '
}

filter_review_skipped_paths() {
  awk '
    ($0 ~ /\.(g|freezed|chopper|mocks|config)\.dart$/) ||
    ($0 ~ /(^|\/)(golden|goldens|failures)\/.*\.(png|jpg|jpeg|webp)$/)
  '
}
