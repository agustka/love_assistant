#!/usr/bin/env bash
# Collects infrastructure-layer diff artifacts between an older ref
# and a newer ref (defaults to current checked-out branch / HEAD)
# for QA review.
#
# Usage:
#   collect_infra_diff.sh <older_ref> [output_dir]
#   collect_infra_diff.sh --legacy <ref_a> <ref_b> [output_dir]
#
# output_dir must be inside one of these workspace-local prefixes:
#   copilot/qa_review/
#
# Example:
#   collect_infra_diff.sh origin/release/6.2.7
#
# Outputs categorized file lists, endpoint diffs, cache changes, and
# per-file compact diffs into the output directory for agent analysis.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/_common.sh"

usage() {
  cat >&2 <<EOF
Usage:
  collect_infra_diff.sh <older_ref> [output_dir]
  collect_infra_diff.sh --legacy <ref_a> <ref_b> [output_dir]

Notes:
  output_dir defaults to: copilot/qa_review/tmp
  output_dir must resolve under:
    <workspace>/copilot/qa_review/
EOF
}

legacy_mode=false
if [[ "${1:-}" == "--legacy" ]]; then
  legacy_mode=true
  shift
fi

if [[ "$legacy_mode" == true ]]; then
  if [[ $# -lt 2 || $# -gt 3 ]]; then
    usage
    exit 1
  fi
  normalize_release_order "$1" "$2"
  from_ref="$normalized_from_ref"
  to_ref="$normalized_to_ref"
  output_dir="${3:-copilot/qa_review/tmp}"
else
  if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage
    exit 1
  fi
  if [[ $# -eq 2 ]] && git rev-parse --verify "$2" >/dev/null 2>&1; then
    echo "Error: second argument '$2' resolves as a git ref." >&2
    echo "In preferred mode, the second argument must be output_dir, not a ref." >&2
    echo "Choose an output_dir that does not resolve as a git ref." >&2
    echo "For explicit two-ref comparisons, use --legacy." >&2
    usage
    exit 1
  fi

  normalize_release_order "$1" "HEAD"
  from_ref="$normalized_from_ref"
  to_ref="$normalized_to_ref"
  output_dir="${2:-copilot/qa_review/tmp}"
fi

workspace_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

workspace_root="$(resolve_path "$workspace_root")"
output_dir="$(resolve_path "$output_dir")"

# Safety: refuse paths outside workspace
if [[ "$output_dir" == "/" || "$output_dir" == "$workspace_root" ]]; then
  echo "Refusing unsafe output_dir: $output_dir" >&2
  exit 1
fi
if [[ "$output_dir" != "$workspace_root"/* ]]; then
  echo "Refusing output_dir outside workspace: $output_dir" >&2
  exit 1
fi
if ! is_allowed_output_dir "$output_dir"; then
  echo "Refusing output_dir outside QA scratch paths: $output_dir" >&2
  echo "Allowed prefix: $workspace_root/copilot/qa_review/" >&2
  exit 1
fi

fetch_remote_refs

original_from_ref="$from_ref"
original_to_ref="$to_ref"
from_ref="$(resolve_remote_tracking_ref "$from_ref")"
to_ref="$(resolve_remote_tracking_ref "$to_ref")"

if [[ "$original_from_ref" != "$from_ref" || "$original_to_ref" != "$to_ref" ]]; then
  echo "Using refreshed refs: older=$from_ref newer=$to_ref"
fi

# Validate refs exist
for ref in "$from_ref" "$to_ref"; do
  if ! git rev-parse --verify "$ref" >/dev/null 2>&1; then
    echo "Error: ref '$ref' not found after fetching remotes." >&2
    exit 1
  fi
done

# Clean and create output dir
if [[ -d "$output_dir" ]]; then
  bash "$script_dir/cleanup.sh" "$output_dir"
fi
mkdir -p "$output_dir/diffs"

# Semantic review is always newer-versus-older, but git diff must still run as older..newer.
# Use two-dot (direct comparison) so both additions and removals are captured
# relative to the older ref — three-dot uses the merge base, which can hide
# changes that exist only on the older branch.
diff_range="${from_ref}..${to_ref}"
if [[ "$normalized_by_version" == true ]]; then
  echo "Using version-ordered refs: older=$from_ref newer=$to_ref"
fi
if [[ "$release_order_swapped" == true ]]; then
  echo "Swapped explicit ref order to preserve older..newer diff semantics."
fi
echo "Collecting infra diff: $diff_range"

# --- Metadata ---
printf '%s\n' "$from_ref" > "$output_dir/from_ref.txt"
printf '%s\n' "$to_ref" > "$output_dir/to_ref.txt"
printf '%s\n' "$diff_range" > "$output_dir/diff_range.txt"

# --- Overall stat ---
git diff --stat "$diff_range" > "$output_dir/stat_overall.txt"

# --- All changed files (excluding generated dart artifacts) ---
git diff --name-only --diff-filter=ACMRD "$diff_range" -- . \
  ':!*.g.dart' ':!*.freezed.dart' ':!*.chopper.dart' ':!*.mocks.dart' ':!*.config.dart' \
  | sort > "$output_dir/all_changed_files.txt"

# --- Deleted files (separate, for detecting removed services) ---
git diff --name-only --diff-filter=D "$diff_range" -- . \
  ':!*.g.dart' ':!*.freezed.dart' ':!*.chopper.dart' ':!*.mocks.dart' ':!*.config.dart' \
  | sort > "$output_dir/deleted_files.txt"

# --- Categorize files ---
categorize() {
  local pattern="$1" source="$2" dest="$3"
  grep -E "$pattern" "$source" > "$dest" 2>/dev/null || true
}

categorize '^lib/infrastructure/' "$output_dir/all_changed_files.txt" "$output_dir/infra_files.txt"
categorize '/services?/chopper/' "$output_dir/infra_files.txt" "$output_dir/chopper_service_files.txt"
categorize '(graphql|/service/graphql/)' "$output_dir/infra_files.txt" "$output_dir/graphql_files.txt"
categorize '/models/' "$output_dir/infra_files.txt" "$output_dir/model_files.txt"
categorize '/repository/' "$output_dir/infra_files.txt" "$output_dir/repository_files.txt"
categorize 'cache' "$output_dir/infra_files.txt" "$output_dir/cache_files.txt"
categorize '(/auth/|core/auth/|forgerock|security_settings|shared_prefs_keys\.dart|auth_request\.dart|token|session|cookie|authorization|biometric)' "$output_dir/infra_files.txt" "$output_dir/auth_files.txt"
categorize '(token|cookie|authorization|auth_request\.dart|token_fetcher|token_service|shared_prefs_keys\.dart|security_settings|forgerock|sso)' "$output_dir/infra_files.txt" "$output_dir/token_files.txt"
categorize 'home_screen' "$output_dir/all_changed_files.txt" "$output_dir/homescreen_files.txt"
categorize '^lib/application/' "$output_dir/all_changed_files.txt" "$output_dir/application_files.txt"
categorize '(feature_toggle|feature_flag)' "$output_dir/all_changed_files.txt" "$output_dir/feature_toggle_files.txt"
categorize 'infrastructure/core/' "$output_dir/infra_files.txt" "$output_dir/core_infra_files.txt"
categorize '/service/' "$output_dir/infra_files.txt" "$output_dir/service_files.txt"
categorize 'service_module\.dart$' "$output_dir/infra_files.txt" "$output_dir/service_module_files.txt"

# Broader header-related scan surface beyond only service modules.
cat \
  "$output_dir/service_module_files.txt" \
  "$output_dir/auth_files.txt" \
  "$output_dir/token_files.txt" \
  "$output_dir/core_infra_files.txt" \
  "$output_dir/service_files.txt" \
  2>/dev/null \
  | sed '/^$/d' \
  | sort -u > "$output_dir/header_files.txt"

# Also capture deleted infra files specifically
categorize '^lib/infrastructure/' "$output_dir/deleted_files.txt" "$output_dir/deleted_infra_files.txt"
categorize '/services?/chopper/' "$output_dir/deleted_infra_files.txt" "$output_dir/deleted_chopper_files.txt"

if [[ -s "$output_dir/chopper_service_files.txt" && -s "$output_dir/deleted_chopper_files.txt" ]]; then
  grep -Fvx -f "$output_dir/deleted_chopper_files.txt" "$output_dir/chopper_service_files.txt" \
    > "$output_dir/chopper_service_files_active.txt" 2>/dev/null || true
  mv "$output_dir/chopper_service_files_active.txt" "$output_dir/chopper_service_files.txt"
fi

# --- Extract endpoint annotations from chopper service diffs ---
echo "Extracting endpoint changes from chopper services..."
: > "$output_dir/endpoint_changes.txt"

extract_endpoints_from_file() {
  local file="$1" diff_output="$2"

  # Added endpoints should use newer ref baseUrl; removed endpoints should use older ref baseUrl.
  local added_base_url removed_base_url
  added_base_url=$(git show "${to_ref}:${file}" 2>/dev/null \
    | sed -nE 's/.*@ChopperApi\(baseUrl:[[:space:]]*"([^"]*)".*/\1/p' \
    | tail -1 || true)
  removed_base_url=$(git show "${from_ref}:${file}" 2>/dev/null \
    | sed -nE 's/.*@ChopperApi\(baseUrl:[[:space:]]*"([^"]*)".*/\1/p' \
    | tail -1 || true)

  # Extract added endpoints: "METHOD path" per line
  local added_endpoints
  added_endpoints=$(echo "$diff_output" \
    | sed -nE '/^\+.*@(GET|POST|PUT|DELETE|PATCH)\(/{
        s/.*@(GET|POST|PUT|DELETE|PATCH)\([^)]*path:[[:space:]]*"([^"]*)".*/\1 \2/p
        t
        s/.*@(GET|POST|PUT|DELETE|PATCH)\([^)]*\).*/\1 /p
      }')

  # Extract removed endpoints: "METHOD path" per line
  local removed_endpoints
  removed_endpoints=$(echo "$diff_output" \
    | sed -nE '/^\-.*@(GET|POST|PUT|DELETE|PATCH)\(/{
        s/.*@(GET|POST|PUT|DELETE|PATCH)\([^)]*path:[[:space:]]*"([^"]*)".*/\1 \2/p
        t
        s/.*@(GET|POST|PUT|DELETE|PATCH)\([^)]*\).*/\1 /p
      }')

  # Extract header changes
  local added_headers removed_headers
  added_headers=$(echo "$diff_output" \
    | sed -nE '/^\+.*@Header\(/{
        s/.*@Header\("([^"]*)".*/\1/p
      }')
  removed_headers=$(echo "$diff_output" \
    | sed -nE '/^\-.*@Header\(/{
        s/.*@Header\("([^"]*)".*/\1/p
      }')

  {
    echo "=== FILE: $file ==="
    echo "BASE_URL_ADDED: ${added_base_url:-unknown}"
    echo "BASE_URL_REMOVED: ${removed_base_url:-unknown}"

    if [[ -n "$added_endpoints" ]]; then
      echo "$added_endpoints" | while read -r method path; do
        echo "ENDPOINT_ADDED: $method ${added_base_url:-}${path}"
      done
    fi
    if [[ -n "$removed_endpoints" ]]; then
      echo "$removed_endpoints" | while read -r method path; do
        echo "ENDPOINT_REMOVED: $method ${removed_base_url:-}${path}"
      done
    fi
    if [[ -n "$added_headers" ]]; then
      echo "$added_headers" | while read -r h; do echo "HEADER_ADDED: $h"; done
    fi
    if [[ -n "$removed_headers" ]]; then
      echo "$removed_headers" | while read -r h; do echo "HEADER_REMOVED: $h"; done
    fi
    echo ""
  } >> "$output_dir/endpoint_changes.txt"
}

# Active chopper service files (changed, not deleted)
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  diff_output=$(git diff -U5 "$diff_range" -- "$f" 2>/dev/null || true)
  [[ -z "$diff_output" ]] && continue
  extract_endpoints_from_file "$f" "$diff_output"
done < "$output_dir/chopper_service_files.txt"

# Deleted chopper service files — extract ALL endpoints as removed
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  # For deleted files, show the full content from from_ref as "removed"
  file_content=$(git show "${from_ref}:${f}" 2>/dev/null || true)
  [[ -z "$file_content" ]] && continue

  base_url=$(echo "$file_content" \
    | sed -nE 's/.*@ChopperApi\(baseUrl:[[:space:]]*"([^"]*)".*/\1/p' \
    | tail -1)
  endpoints=$(echo "$file_content" \
    | sed -nE '/@(GET|POST|PUT|DELETE|PATCH)\(/{
        s/.*@(GET|POST|PUT|DELETE|PATCH)\([^)]*path:[[:space:]]*"([^"]*)".*/\1 \2/p
        t
        s/.*@(GET|POST|PUT|DELETE|PATCH)\([^)]*\).*/\1 /p
      }')

  {
    echo "=== FILE: $f (DELETED) ==="
    echo "BASE_URL: ${base_url:-unknown}"
    if [[ -n "$endpoints" ]]; then
      echo "$endpoints" | while read -r method path; do
        echo "ENDPOINT_REMOVED: $method ${base_url:-}${path} (entire service deleted)"
      done
    fi
    echo ""
  } >> "$output_dir/endpoint_changes.txt"
done < "$output_dir/deleted_chopper_files.txt"

# --- Extract cache/TTL changes ---
echo "Extracting cache changes..."
: > "$output_dir/cache_changes.txt"

extract_cache_from_list() {
  local file_list="$1"
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    local diff_output
    diff_output=$(git diff -U3 "$diff_range" -- "$f" 2>/dev/null || true)
    [[ -z "$diff_output" ]] && continue
    local cache_lines
    cache_lines=$(echo "$diff_output" | grep -E '^[+-].*(Duration|ttl|cacheTtl|cacheTimeout|HiveBox|boxName|CacheSupport|hiveBox)' || true)
    if [[ -n "$cache_lines" ]]; then
      echo "=== FILE: $f ===" >> "$output_dir/cache_changes.txt"
      echo "$cache_lines" >> "$output_dir/cache_changes.txt"
      echo "" >> "$output_dir/cache_changes.txt"
    fi
  done < "$file_list"
}

extract_cache_from_list "$output_dir/cache_files.txt"
extract_cache_from_list "$output_dir/repository_files.txt"

# --- Extract service-module interceptor changes ---
echo "Extracting service-module interceptor changes..."
: > "$output_dir/service_module_interceptor_changes.txt"

extract_service_module_interceptor_changes() {
  local file_list="$1"
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    local diff_output
    diff_output=$(git diff -U3 "$diff_range" -- "$f" 2>/dev/null || true)
    [[ -z "$diff_output" ]] && continue
    local interceptor_lines
    interceptor_lines=$(echo "$diff_output" | grep -E '^[+-].*(interceptor|Interceptor|AuthRequestInterceptor|BasicAuthRequestInterceptor|Authorization|Cookie|header)' || true)
    if [[ -n "$interceptor_lines" ]]; then
      echo "=== FILE: $f ===" >> "$output_dir/service_module_interceptor_changes.txt"
      echo "$interceptor_lines" >> "$output_dir/service_module_interceptor_changes.txt"
      echo "" >> "$output_dir/service_module_interceptor_changes.txt"
    fi
  done < "$file_list"
}

extract_service_module_interceptor_changes "$output_dir/service_module_files.txt"

# --- Extract broader header-related changes ---
echo "Extracting broader header changes..."
: > "$output_dir/header_changes.txt"

extract_header_changes_from_list() {
  local file_list="$1"
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    local diff_output
    diff_output=$(git diff -U3 "$diff_range" -- "$f" 2>/dev/null || true)
    [[ -z "$diff_output" ]] && continue
    local header_lines
    header_lines=$(echo "$diff_output" | grep -E '^[+-].*(@Header\(|\bheaders?\b|Authorization|Cookie|setHeader|addHeader|defaultHeaders|headerMap|x-[a-z0-9-]+|X-[A-Za-z0-9-]+|interceptor|Interceptor)' || true)
    if [[ -n "$header_lines" ]]; then
      echo "=== FILE: $f ===" >> "$output_dir/header_changes.txt"
      echo "$header_lines" >> "$output_dir/header_changes.txt"
      echo "" >> "$output_dir/header_changes.txt"
    fi
  done < "$file_list"
}

extract_header_changes_from_list "$output_dir/header_files.txt"

# --- Extract auth/token related changes ---
echo "Extracting auth/token changes..."
: > "$output_dir/token_changes.txt"

extract_token_changes_from_list() {
  local file_list="$1"
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    local diff_output
    diff_output=$(git diff -U3 "$diff_range" -- "$f" 2>/dev/null || true)
    [[ -z "$diff_output" ]] && continue
    local token_lines
    token_lines=$(echo "$diff_output" | grep -E '^[+-].*(Cookie|Authorization|Bearer|access[Tt]oken|refresh[Tt]oken|cloud[Tt]oken|[Tt]okenService|[Tt]okenFetcher|ssoCookie|session|JWT|jwt|authenticator|authentication-devices|biometricEnrollmentCloudTokenKey|preferredAuthorizationMethod|flowCompletionStream)' || true)
    if [[ -n "$token_lines" ]]; then
      echo "=== FILE: $f ===" >> "$output_dir/token_changes.txt"
      echo "$token_lines" >> "$output_dir/token_changes.txt"
      echo "" >> "$output_dir/token_changes.txt"
    fi
  done < "$file_list"
}

cat "$output_dir/auth_files.txt" "$output_dir/token_files.txt" 2>/dev/null | sort -u > "$output_dir/token_scan_files.txt"
extract_token_changes_from_list "$output_dir/token_scan_files.txt"
rm -f "$output_dir/token_scan_files.txt"

# --- Numstat for infrastructure files ---
git diff --numstat --diff-filter=ACMRD "$diff_range" -- lib/infrastructure/ \
  ':!*.g.dart' ':!*.freezed.dart' ':!*.chopper.dart' ':!*.mocks.dart' ':!*.config.dart' \
  > "$output_dir/infra_numstat.tsv" 2>/dev/null || true

# --- Per-file compact diffs for infrastructure files ---
echo "Collecting per-file diffs..."

diff_map_tmp="$output_dir/diff_artifacts_map.tsv.tmp"
: > "$diff_map_tmp"

path_sha256() {
  local input="$1"

  if command -v sha256sum >/dev/null 2>&1; then
    printf '%s' "$input" | sha256sum | awk '{print $1}'
    return
  fi

  if command -v shasum >/dev/null 2>&1; then
    printf '%s' "$input" | shasum -a 256 | awk '{print $1}'
    return
  fi

  if command -v openssl >/dev/null 2>&1; then
    printf '%s' "$input" | openssl dgst -sha256 -r | awk '{print $1}'
    return
  fi

  python3 - "$input" <<'PY'
import hashlib
import sys

print(hashlib.sha256(sys.argv[1].encode("utf-8")).hexdigest())
PY
}

artifact_file_name_for_path() {
  local source_path="$1"
  local safe_name
  local hash_prefix

  safe_name="$(echo "$source_path" | tr '/' '_' | tr -cd '[:alnum:]_.-')"
  hash_prefix="$(path_sha256 "$source_path" | cut -c1-12)"

  printf '%s_%s.diff' "$safe_name" "$hash_prefix"
}

collect_diff_for_file() {
  local f="$1"
  local artifact_file
  artifact_file="$(artifact_file_name_for_path "$f")"
  local artifact_path="$output_dir/diffs/$artifact_file"
  local tmp_file="$artifact_path.tmp"

  git diff -U3 "$diff_range" -- "$f" > "$tmp_file" 2>/dev/null || true
  if [[ -s "$tmp_file" ]]; then
    local line_count
    line_count=$(wc -l < "$tmp_file" | tr -d ' ')
    if [[ "$line_count" -gt 200 ]]; then
      {
        head -60 "$tmp_file"
        echo ""
        echo "... $((line_count - 80)) lines omitted ..."
        echo ""
        tail -20 "$tmp_file"
      } > "$artifact_path"
      printf '%s\t%s\n' "$f" "$artifact_file" >> "$diff_map_tmp"
      rm -f "$tmp_file"
    else
      mv "$tmp_file" "$artifact_path"
      printf '%s\t%s\n' "$f" "$artifact_file" >> "$diff_map_tmp"
    fi
  else
    rm -f "$tmp_file"
  fi
}

while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  collect_diff_for_file "$f"
done < "$output_dir/infra_files.txt"

# Also collect diffs for homescreen and application layer files
for list_file in "$output_dir/homescreen_files.txt" "$output_dir/application_files.txt"; do
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    artifact_file="$(artifact_file_name_for_path "$f")"
    [[ -f "$output_dir/diffs/$artifact_file" ]] && continue
    collect_diff_for_file "$f"
  done < "$list_file"
done

if [[ -s "$diff_map_tmp" ]]; then
  sort -u "$diff_map_tmp" > "$output_dir/diff_artifacts_map.tsv"
else
  : > "$output_dir/diff_artifacts_map.tsv"
fi
rm -f "$diff_map_tmp"

# --- Summary ---
count_lines() { wc -l < "$1" 2>/dev/null | tr -d ' '; }

infra_count=$(count_lines "$output_dir/infra_files.txt")
chopper_count=$(count_lines "$output_dir/chopper_service_files.txt")
model_count=$(count_lines "$output_dir/model_files.txt")
repo_count=$(count_lines "$output_dir/repository_files.txt")
service_module_count=$(count_lines "$output_dir/service_module_files.txt")
home_count=$(count_lines "$output_dir/homescreen_files.txt")
app_count=$(count_lines "$output_dir/application_files.txt")
auth_count=$(count_lines "$output_dir/auth_files.txt")
token_count=$(count_lines "$output_dir/token_files.txt")
header_file_count=$(count_lines "$output_dir/header_files.txt")
graphql_count=$(count_lines "$output_dir/graphql_files.txt")
toggle_count=$(count_lines "$output_dir/feature_toggle_files.txt")
deleted_count=$(count_lines "$output_dir/deleted_infra_files.txt")

cat <<EOF > "$output_dir/summary.txt"
Infrastructure Diff Summary: $from_ref → $to_ref
=================================================
Infrastructure files changed: $infra_count
  Chopper services:    $chopper_count
  GraphQL files:       $graphql_count
  Models:              $model_count
  Repositories:        $repo_count
  Service modules:     $service_module_count
  Auth files:          $auth_count
  Token files:         $token_count
  Header scan files:   $header_file_count
  Deleted infra files: $deleted_count
HomeScreen files:      $home_count
Application layer:     $app_count
Feature toggles:       $toggle_count

Artifacts:
  endpoint_changes.txt — Added/removed endpoints and headers
  service_module_interceptor_changes.txt — Service-module interceptor and auth/header wiring diffs
  header_changes.txt   — Broader header/interceptor diffs across auth/token/core/service files
  header_files.txt     — Infra files included in broader header scan
  token_changes.txt    — Token, cookie, authorization, and session-related diffs
  token_files.txt      — Infra files likely related to auth/token behavior
  cache_changes.txt    — Cache/TTL modifications
  infra_numstat.tsv    — Lines added/removed per infra file
  infra_files.txt      — All changed infrastructure files
  homescreen_files.txt — HomeScreen-related changes
  application_files.txt — Application layer changes
  deleted_files.txt    — Files removed between releases
  diff_artifacts_map.tsv — Mapping: original file path -> artifact filename in diffs/
  diffs/               — Per-file compact diffs
EOF

cat "$output_dir/summary.txt"
echo ""

# --- General Changes artifacts (layer categorization + commit log) ---
echo "Collecting general changes artifacts..."

general_dir="$output_dir/general"
mkdir -p "$general_dir"

# All changed files are already in all_changed_files.txt — copy for the general artifacts
cp "$output_dir/all_changed_files.txt" "$general_dir/general_changed_files.txt"

# Diff stat for all changed files excluding generated artifacts
git diff --stat "$diff_range" -- . \
  ':!*.g.dart' ':!*.freezed.dart' ':!*.chopper.dart' ':!*.mocks.dart' ':!*.config.dart' \
  > "$general_dir/general_stat.txt"

# Commit log between refs
git log --oneline --no-merges "$diff_range" > "$general_dir/general_commit_log.txt"

# Categorize by layer
count_matching() {
  local pattern="$1" file="$2"
  local count
  count="$(grep -cE "$pattern" "$file" 2>/dev/null || true)"
  if [[ -z "$count" ]]; then
    count="0"
  fi
  printf '%s\n' "$count"
}

presentation_count=$(count_matching '^lib/presentation/' "$general_dir/general_changed_files.txt")
domain_count=$(count_matching '^lib/domain/' "$general_dir/general_changed_files.txt")
application_layer_count=$(count_matching '^lib/application/' "$general_dir/general_changed_files.txt")
infrastructure_layer_count=$(count_matching '^lib/infrastructure/' "$general_dir/general_changed_files.txt")
assets_count=$(count_matching '^assets/' "$general_dir/general_changed_files.txt")
packages_count=$(count_matching '^packages/' "$general_dir/general_changed_files.txt")
total_count=$(wc -l < "$general_dir/general_changed_files.txt" | tr -d ' ')
other_count=$((total_count - presentation_count - domain_count - application_layer_count - infrastructure_layer_count - assets_count - packages_count))
if [[ "$other_count" -lt 0 ]]; then
  other_count=0
fi

commit_count=$(wc -l < "$general_dir/general_commit_log.txt" | tr -d ' ')

cat > "$general_dir/general_summary.txt" <<GEOF
General Diff Summary: $from_ref → $to_ref
=================================================
Total non-generated files changed: $total_count

Per-layer breakdown:
  lib/presentation/:    $presentation_count
  lib/domain/:          $domain_count
  lib/application/:     $application_layer_count
  lib/infrastructure/:  $infrastructure_layer_count
  assets/:              $assets_count
  packages/:            $packages_count
  other:                $other_count

Commits (non-merge): $commit_count

--- Commit Log ---
$(cat "$general_dir/general_commit_log.txt")
GEOF

cat "$general_dir/general_summary.txt"
echo ""
echo "DONE: all diff artifacts (infrastructure + general) collected in $output_dir"
