#!/usr/bin/env bash
# Syncs VS Code settings required by git-diff scripts.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
workspace_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
workspace_vscode_dir="$workspace_root/.vscode"
workspace_settings_file="$workspace_root/.vscode/settings.json"
template_settings_file="$script_dir/../documentation/settings.jsonc"

echo "Preflight: preparing VS Code git-diff settings."

if [[ ! -d "$workspace_vscode_dir" ]]; then
  echo "Preflight: no .vscode folder found in workspace. Skipping VS Code settings sync."
  exit 0
fi

if [[ "${TERM_PROGRAM:-}" != "vscode" && -z "${VSCODE_PID:-}" && -z "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
  echo "Preflight: non-VS Code terminal session detected. Skipping VS Code settings sync."
  exit 0
fi

if [[ -f "$template_settings_file" ]]; then
  merge_result="$(python3 - "$template_settings_file" "$workspace_settings_file" <<'PY'
import json
import pathlib
import re
import sys


def strip_jsonc(text: str) -> str:
  out = []
  in_string = False
  escaped = False
  i = 0
  while i < len(text):
    ch = text[i]
    if in_string:
      out.append(ch)
      if escaped:
        escaped = False
      elif ch == "\\":
        escaped = True
      elif ch == '"':
        in_string = False
      i += 1
      continue

    if ch == '"':
      in_string = True
      out.append(ch)
      i += 1
      continue

    if ch == "/" and i + 1 < len(text) and text[i + 1] == "/":
      while i < len(text) and text[i] != "\n":
        i += 1
      continue

    out.append(ch)
    i += 1

  cleaned = "".join(out)
  cleaned = re.sub(r",(\s*[}\]])", r"\1", cleaned)
  return cleaned


def load_jsonc(path: pathlib.Path, default):
  if not path.exists():
    return default
  raw = path.read_text(encoding="utf-8")
  stripped = strip_jsonc(raw)
  if not stripped.strip():
    return default
  return json.loads(stripped)


template_path = pathlib.Path(sys.argv[1])
workspace_path = pathlib.Path(sys.argv[2])

template_data = load_jsonc(template_path, {})
workspace_data = load_jsonc(workspace_path, {})

template_auto_approve = template_data.get("chat.tools.terminal.autoApprove", {})
if not isinstance(template_auto_approve, dict):
  print("error:invalid-template-auto-approve")
  raise SystemExit(2)

workspace_auto_approve = workspace_data.get("chat.tools.terminal.autoApprove", {})
if not isinstance(workspace_auto_approve, dict):
  workspace_auto_approve = {}

added_entries = 0

missing_auto_approve = {}
for key, value in template_auto_approve.items():
  if key not in workspace_auto_approve:
    missing_auto_approve[key] = value

if missing_auto_approve:
  workspace_data.setdefault("chat.tools.terminal.autoApprove", {})
  if not isinstance(workspace_data["chat.tools.terminal.autoApprove"], dict):
    workspace_data["chat.tools.terminal.autoApprove"] = {}
  workspace_data["chat.tools.terminal.autoApprove"].update(missing_auto_approve)
  added_entries += len(missing_auto_approve)

top_level_map_merge_keys = ["files.watcherExclude"]
for key in top_level_map_merge_keys:
  template_value = template_data.get(key)
  if not isinstance(template_value, dict):
    continue

  workspace_value = workspace_data.get(key)
  if not isinstance(workspace_value, dict):
    if key not in workspace_data:
      workspace_data[key] = {}
    else:
      continue

  for nested_key, nested_value in template_value.items():
    if nested_key not in workspace_data[key]:
      workspace_data[key][nested_key] = nested_value
      added_entries += 1

top_level_scalar_keys = [
  "chat.useCustomAgentHooks",
  "search.followSymlinks",
  "github.copilot.chat.codesearch.enabled",
]
for key in top_level_scalar_keys:
  if key in template_data and key not in workspace_data:
    workspace_data[key] = template_data[key]
    added_entries += 1

if added_entries == 0:
  print("unchanged:0")
  raise SystemExit(0)

workspace_path.parent.mkdir(parents=True, exist_ok=True)
workspace_path.write_text(json.dumps(workspace_data, indent=4, ensure_ascii=False) + "\n", encoding="utf-8")

print(f"updated:{added_entries}")
PY
)"

  case "$merge_result" in
  updated:*)
    echo "Preflight: updated workspace settings entries (${merge_result#updated:})."
    ;;
  unchanged:*)
    echo "Preflight: workspace settings already contain required review entries."
    ;;
  *)
    echo "Preflight warning: unable to verify/merge workspace settings ($merge_result)."
    ;;
  esac
else
  echo "Preflight warning: template settings file not found at $template_settings_file"
fi
echo "Preflight complete: VS Code settings sync finished."
