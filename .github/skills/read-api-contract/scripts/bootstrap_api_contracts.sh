#!/usr/bin/env bash

# Bootstraps the API.Contracts repository as a sibling directory and creates a workspace symlink.
# Clones the contracts repo from Azure if missing, updates it if present, and ensures api_contracts symlink is correct.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../../../.." && pwd)"
sibling_root="$(dirname "${repo_root}")"

contracts_repo_dir="${sibling_root}/API.Contracts"
contracts_remote="${API_CONTRACTS_REMOTE:-https://dev.azure.com/islandsbanki/IT/_git/API.Contracts}"
contracts_branch="${API_CONTRACTS_BRANCH:-master}"
workspace_symlink="${repo_root}/api_contracts"

echo "[read-api-contract] Workspace root: ${repo_root}"
echo "[read-api-contract] Sibling contracts repo: ${contracts_repo_dir}"

if [[ -d "${contracts_repo_dir}" && ! -d "${contracts_repo_dir}/.git" ]]; then
  echo "[read-api-contract] Error: ${contracts_repo_dir} exists but is not a git repository."
  echo "[read-api-contract] Move or remove it, then run this script again."
  exit 1
fi

if [[ ! -d "${contracts_repo_dir}" ]]; then
  echo "[read-api-contract] Cloning API.Contracts from ${contracts_remote}"
  git clone --branch "${contracts_branch}" "${contracts_remote}" "${contracts_repo_dir}"
else
  echo "[read-api-contract] Updating existing API.Contracts checkout"
  if git -C "${contracts_repo_dir}" show-ref --verify --quiet "refs/heads/${contracts_branch}"; then
    git -C "${contracts_repo_dir}" checkout "${contracts_branch}"
  else
    git -C "${contracts_repo_dir}" checkout -b "${contracts_branch}" "origin/${contracts_branch}"
  fi
  git -C "${contracts_repo_dir}" pull --ff-only origin "${contracts_branch}"
fi

if [[ -e "${workspace_symlink}" && ! -L "${workspace_symlink}" ]]; then
  echo "[read-api-contract] Error: ${workspace_symlink} exists but is not a symlink."
  echo "[read-api-contract] Replace it with a symlink to ${contracts_repo_dir}."
  exit 1
fi

if [[ -L "${workspace_symlink}" ]]; then
  current_target="$(cd "${workspace_symlink}" && pwd -P)"
  expected_target="$(cd "${contracts_repo_dir}" && pwd -P)"

  if [[ "${current_target}" != "${expected_target}" ]]; then
    echo "[read-api-contract] Repointing existing api_contracts symlink"
    rm "${workspace_symlink}"
    ln -s "${contracts_repo_dir}" "${workspace_symlink}"
  else
    echo "[read-api-contract] Existing api_contracts symlink is already correct"
  fi
else
  echo "[read-api-contract] Creating api_contracts symlink"
  ln -s "${contracts_repo_dir}" "${workspace_symlink}"
fi

echo "[read-api-contract] Bootstrap complete"
echo "[read-api-contract] Contracts repo: ${contracts_repo_dir}"
echo "[read-api-contract] Workspace link: ${workspace_symlink}"
