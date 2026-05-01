#!/usr/bin/env bash
# secrets-menu.sh — Interactive fzf CLI for managing sops-encrypted NixOS secrets
#
# Usage:
#   secrets-menu              # Interactive fzf menu
#   secrets-menu <command>    # Run a specific command
#   secrets-menu init          # Bootstrap a new secrets repo
#   secrets-menu init --migrate  # Migrate existing keys
#
# Designed to be wrapped in a Nix derivation (pkgs.writeShellScriptBin or similar).
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

err()   { printf "${RED}ERROR:${NC} %s\n" "$*" >&2; }
ok()    { printf "${GREEN}[OK]${NC} %s\n" "$*"; }
info()  { printf "${CYAN}[INFO]${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$*"; }

# ─── Resolve repo root ─────────────────────────────────────────────────────────
: "${SECRETS_ROOT:=""
if [[ -z "${SECRETS_ROOT}" ]]; then
  for candidate in /etc/nixos/external/secrets "${HOME}/nixos-config/external/secrets"; do
    [[ -f "${candidate}/.sops.yaml" ]] && { SECRETS_ROOT="${candidate}"; break; }
  done
fi
[[ -z "${SECRETS_ROOT}" ]] && { printf "${RED}ERROR: Set SECRETS_ROOT=/path/to/external/secrets${NC}\n" >&2; exit 1; }
REPO_ROOT="${SECRETS_ROOT}"

export SOPS_AGE_KEY_FILE="${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"

# ─── Dependency checks ────────────────────────────────────────────────────────
require_cmds() {
  local missing=()
  for cmd in "$@"; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    err "Required commands not found: ${missing[*]}"
    err "Install with: nix-shell -p ${missing[*]}"
    return 1
  fi
  return 0
}

require_sops() { require_cmds sops age; }
require_fzf()   { require_cmds fzf; }
require_yq()    { require_cmds yq; }

# ─── Target resolution ────────────────────────────────────────────────────────
# Converts shorthand names to full relative paths within the secrets repo.
resolve_target() {
  local target="$1"
  # If it's already a valid file path, return as-is
  if [[ -f "${REPO_ROOT}/${target}" ]]; then
    echo "${target}"
    return 0
  fi
  case "${target}" in
    bagalamukhi|matangi|bhairavi|chhinamasta)
      echo "hosts/${target}/secrets.yaml"
      ;;
    tlh|smg)
      echo "users/${target}/secrets.yaml"
      ;;
    shared)
      echo "shared/secrets.yaml"
      ;;
    *)
      # Try as-is (might be a path like hosts/bagalamukhi/some-file.json)
      echo "${target}"
      ;;
  esac
}

# Resolve target that must be a YAML secrets file
resolve_target_yaml() {
  local target="$1"
  local resolved
  resolved="$(resolve_target "$target")"
  # If it resolved to a directory, append secrets.yaml
  if [[ -d "${REPO_ROOT}/${resolved}" ]]; then
    resolved="${resolved%/}/secrets.yaml"
  fi
  echo "${resolved}"
}

# ─── .sops.yaml helpers ──────────────────────────────────────────────────────
# Parse key anchors from .sops.yaml — returns lines like: bagalamukhi age13rzh...
sops_yaml_keys() {
  grep -E '^\s*-&\S+' "${REPO_ROOT}/.sops.yaml" | sed 's/.*-&\(\S\+\)\s\+\(age1\S\+\)/\1 \2/'
}

# Get the public age key for a given anchor name
get_age_pubkey() {
  local anchor="$1"
  grep -E "^\s*-&${anchor}\s+" "${REPO_ROOT}/.sops.yaml" | awk '{print $NF}' | head -1
}

# Check if an anchor name exists in .sops.yaml
anchor_exists() {
  local anchor="$1"
  grep -qE "^\s*-&${anchor}\s+" "${REPO_ROOT}/.sops.yaml"
}

# ─── Interactive fzf menu ─────────────────────────────────────────────────────
interactive_menu() {
  require_fzf || return 1

  local actions=(
    "list:List all secrets"
    "show-host:Show secrets for host..."
    "show-user:Show secrets for user..."
    "show-shared:Show secrets for shared"
    "edit-host:Edit secrets for host..."
    "edit-user:Edit secrets for user..."
    "add-secret:Add secret"
    "delete-secret:Delete secret"
    "add-binary:Add binary file"
    "add-host:Add host"
    "remove-host:Remove host"
    "rekey:Rekey all secrets"
    "verify:Verify all secrets"
    "keys:Show keys in sops.yaml"
    "backup-keys:Backup keys"
    "unlock:Unlock master key"
    "lock:Lock - remove decrypted keys"
  )

  local choice
  choice=$(printf '%s\n' "${actions[@]}" | fzf --prompt="secrets-menu> " \
    --with-nth=2 --delimiter=':' \
    --height=~40% --layout=reverse --border=rounded \
    --header="Select an action" | cut -d: -f1)

  [[ -z "${choice}" ]] && { info "No selection made."; return 0; }

  case "${choice}" in
    list)        cmd_list "" ;;
    show-host)
      local host
      host=$(_pick_host) || return 0
      cmd_show "${host}" ;;
    show-user)
      local user
      user=$(_pick_user) || return 0
      cmd_show "${user}" ;;
    show-shared) cmd_show "shared" ;;
    edit-host)
      local host
      host=$(_pick_host) || return 0
      cmd_edit "${host}" ;;
    edit-user)
      local user
      user=$(_pick_user) || return 0
      cmd_edit "${user}" ;;
    add-secret)  _interactive_add_secret ;;
    delete-secret) _interactive_delete_secret ;;
    add-binary)  _interactive_add_file ;;
    add-host)     _interactive_add_host ;;
    remove-host)
      local host
      host=$(_pick_host) || return 0
      cmd_rm_host "${host}" ;;
    rekey)       cmd_rekey ;;
    verify)      cmd_verify ;;
    keys)        cmd_keys ;;
    backup-keys) cmd_backup_keys "" ;;
    unlock)      cmd_unlock ;;
    lock)        cmd_lock ;;
    *)           err "Unknown action: ${choice}" ;;
  esac
}

_pick_host() {
  local hosts=()
  for d in "${REPO_ROOT}"/hosts/*/; do
    [[ -d "$d" ]] && hosts+=("$(basename "$d")")
  done
  [[ ${#hosts[@]} -eq 0 ]] && { err "No hosts found."; return 1; }
  printf '%s\n' "${hosts[@]}" | fzf --prompt="Select host> " --height=~20% --layout=reverse
}

_pick_user() {
  local users=()
  for d in "${REPO_ROOT}"/users/*/; do
    [[ -d "$d" ]] && users+=("$(basename "$d")")
  done
  [[ ${#users[@]} -eq 0 ]] && { err "No users found."; return 1; }
  printf '%s\n' "${users[@]}" | fzf --prompt="Select user> " --height=~20% --layout=reverse
}

_pick_target() {
  local targets=()
  for d in "${REPO_ROOT}"/hosts/*/; do
    [[ -d "$d" ]] && targets+=("$(basename "$d")")
  done
  for d in "${REPO_ROOT}"/users/*/; do
    [[ -d "$d" ]] && targets+=("$(basename "$d")")
  done
  [[ -d "${REPO_ROOT}/shared" ]] && targets+=("shared")
  printf '%s\n' "${targets[@]}" | fzf --prompt="Select target> " --height=~30% --layout=reverse
}

_interactive_add_secret() {
  local target key value
  target=$(_pick_target) || return 0
  read -rp "Key name: " key
  [[ -z "${key}" ]] && { err "Key name cannot be empty."; return 1; }
  read -rp "Value: " value
  cmd_add_secret "${target}" "${key}" "${value}"
}

_interactive_delete_secret() {
  local target key
  target=$(_pick_target) || return 0
  local resolved
  resolved="$(resolve_target_yaml "${target}")"
  local filepath="${REPO_ROOT}/${resolved}"
  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${resolved}"
    return 1
  fi
  local keys
  keys=$(sops --decrypt "${filepath}" 2>/dev/null | yq 'keys | .[]' -r 2>/dev/null) || {
    err "Cannot decrypt ${resolved}"
    return 1
  }
  [[ -z "${keys}" ]] && { info "No keys in ${resolved}"; return 0; }
  key=$(echo "${keys}" | fzf --prompt="Select key to delete> " --height=~20% --layout=reverse) || return 0
  [[ -z "${key}" ]] && { info "No selection."; return 0; }
  cmd_delete_secret "${target}" "${key}"
}

_interactive_add_file() {
  local target_path source
  read -rp "Target path within repo [e.g. hosts/bagalamukhi/my-file.enc]: " target_path
  [[ -z "${target_path}" ]] && { err "Target path cannot be empty."; return 1; }
  read -rp "Source file path: " source
  [[ -z "${source}" ]] && { err "Source cannot be empty."; return 1; }
  cmd_add_file "${target_path}" "${source}"
}

_interactive_add_host() {
  read -rp "Hostname: " hostname
  [[ -z "${hostname}" ]] && { err "Hostname cannot be empty."; return 1; }
  read -rp "SSH host key path [empty: /etc/ssh/ssh_host_ed25519_key.pub]: " key_path
  cmd_add_host "${hostname}" "${key_path}"
}

# ─── Init ──────────────────────────────────────────────────────────────────────
cmd_init() {
  require_sops || return 1
  require_cmds ssh-to-age age-keygen || return 1

  local migrate=false
  [[ "${1:-}" == "--migrate" ]] && migrate=true

  echo "=== Bootstrapping NixOS Secrets Repo ==="
  echo ""

  # ── [1/6] Generate master age key ─────────────────────────────────────────
  echo "[1/6] Generating master age key..."
  local master_key_tmp
  master_key_tmp="$(mktemp)"
  age-keygen -o "${master_key_tmp}" 2>/dev/null
  local master_pub
  master_pub="$(age-keygen -y "${master_key_tmp}")"
  ok "Master age key generated: ${master_pub}"

  # ── [2/6] Passphrase-encrypt the master key ───────────────────────────────
  echo ""
  echo "[2/6] Passphrase-encrypting master key..."
  age --encrypt --passphrase --armor -o "${REPO_ROOT}/keys.txt.age" "${master_key_tmp}"
  ok "keys.txt.age written"
  rm -f "${master_key_tmp}"

  # ── [3/6] Derive host and user age keys ────────────────────────────────────
  echo ""
  echo "[3/6] Deriving host and user age keys..."
  local AGE_TMPDIR
  AGE_TMPDIR="$(mktemp -d)"
  trap 'rm -rf "${AGE_TMPDIR}"' RETURN

  local AGE_KEYS
  AGE_KEYS="${AGE_TMPDIR}/keys.txt"

  derive_host_age() {
    local label="$1" key_path="$2"
    local age_out="${AGE_TMPDIR}/${label}.age" age_pub=""
    if [[ -r "${key_path}" ]]; then
      sudo ssh-to-age -private-key -i "${key_path}" > "${age_out}" 2>/dev/null && \
        sudo chown "$(id -u):$(id -g)" "${age_out}" 2>/dev/null && \
        age_pub="$(age-keygen -y "${age_out}")" && \
        cat "${age_out}" >> "${AGE_KEYS}" && \
        echo "${age_pub}" && \
        return 0
    fi
    return 1
  }

  derive_user_age() {
    local label="$1" key_path="$2"
    local age_out="${AGE_TMPDIR}/${label}.age" age_pub=""
    if [[ -r "${key_path}" ]]; then
      if ssh-to-age -private-key -i "${key_path}" > "${age_out}" 2>/dev/null; then
        age_pub="$(age-keygen -y "${age_out}")"
        cat "${age_out}" >> "${AGE_KEYS}"
        echo "${age_pub}"
        return 0
      fi
    fi
    return 1
  }

  local BAGALAMUKHI_AGE="" MATANGI_AGE="" BHAIRAVI_AGE="" CHHINAMASTA_AGE="" TLH_AGE="" SMG_AGE=""

  # Derive host keys
  BAGALAMUKHI_AGE="$(derive_host_age bagalamukhi /etc/ssh/ssh_host_ed25519_key || true)"
  if [[ -z "${BAGALAMUKHI_AGE}" ]]; then
    err "Could not derive bagalamukhi age key."
    return 1
  fi
  ok "bagalamukhi [host]: ${BAGALAMUKHI_AGE}"

  # Try matangi from the same host key (may differ on that host)
  MATANGI_AGE="${BAGALAMUKHI_AGE}"  # Same key by default; update on matangi
  ok "matangi [host]:      ${MATANGI_AGE} [same as bagalamukhi]"

  # bhairavi and chhinamasta share bagalamukhi's key
  BHAIRAVI_AGE="${BAGALAMUKHI_AGE}"
  CHHINAMASTA_AGE="${BAGALAMUKHI_AGE}"

  # Derive user key
  TLH_AGE="$(derive_user_age tlh ~/.ssh/id_ed25519 || true)"
  if [[ -z "${TLH_AGE}" ]]; then
    warn "tlh: SSH key is passphrase-protected or missing. Generating fresh age key."
    local tlh_fallback="${AGE_TMPDIR}/tlh-fallback.age"
    age-keygen -o "${tlh_fallback}" 2>/dev/null
    TLH_AGE="$(age-keygen -y "${tlh_fallback}")"
    cat "${tlh_fallback}" >> "${AGE_KEYS}"
  fi
  ok "tlh [admin]:         ${TLH_AGE}"

  SMG_AGE="${TLH_AGE}"  # Placeholder; update when smg has their own key
  ok "smg [user]:          ${SMG_AGE} [placeholder]"

  # Also add master key to the keys file for init operations
  # Decrypt master key back temporarily for sops operations
  echo ""
  echo "[3b/6] Decrypting master key for sops operations..."
  age --decrypt --passphrase --output "${AGE_KEYS}.master" "${REPO_ROOT}/keys.txt.age" 2>/dev/null || {
    warn "Master key decryption requires passphrase input."
    age --decrypt --passphrase --output "${AGE_KEYS}.master" "${REPO_ROOT}/keys.txt.age"
  }
  cat "${AGE_KEYS}.master" >> "${AGE_KEYS}"
  rm -f "${AGE_KEYS}.master"

  if [[ ! -s "${AGE_KEYS}" ]]; then
    err "No age identities could be derived. Cannot proceed."
    return 1
  fi

  mkdir -p "${HOME}/.config/sops/age"
  cp "${AGE_KEYS}" "${HOME}/.config/sops/age/keys.txt"
  chmod 600 "${HOME}/.config/sops/age/keys.txt"
  export SOPS_AGE_KEY_FILE="${HOME}/.config/sops/age/keys.txt"
  ok "Wrote $(wc -l < ~/.config/sops/age/keys.txt) keys to ~/.config/sops/age/keys.txt"

  # ── Migrate existing keys ──────────────────────────────────────────────────
  if ${migrate} && [[ -f "${HOME}/.config/sops/age/keys.txt" ]]; then
    echo ""
    echo "[3c/6] Migration mode: preserving existing keys..."
    # Keys are already in keys.txt from derivation above; any additional
    # keys from the original file are merged
    ok "Existing keys preserved during migration."
  fi

  # ── [4/6] Write .sops.yaml ────────────────────────────────────────────────
  echo ""
  echo "[4/6] Writing .sops.yaml with age keys..."

  # Build a YAML anchors block that includes master + all per-host/user keys.
  # The master key is included in every creation rule so the repo admin
  # can always decrypt any file with the passphrase-encrypted master key.
  cat > "${REPO_ROOT}/.sops.yaml" <<SOPS_YAML
keys:
  - &master       ${master_pub}
  - &bagalamukhi  ${BAGALAMUKHI_AGE}
  - &matangi      ${MATANGI_AGE}
  - &bhairavi     ${BHAIRAVI_AGE}
  - &chhinamasta  ${CHHINAMASTA_AGE}
  - &tlh          ${TLH_AGE}
  - &smg          ${SMG_AGE}

creation_rules:
  # yaml secrets (structured key-value)
  - path_regex: hosts/bagalamukhi/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: hosts/matangi/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *matangi
  - path_regex: hosts/bhairavi/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: hosts/chhinamasta/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: shared/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: users/tlh/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: users/smg/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *matangi
  # arbitrary encrypted files (binary/json/env/ini/toml — anything)
  - path_regex: hosts/bagalamukhi/.+\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: hosts/matangi/.+\$
    key_groups:
      - age:
          - *master
          - *matangi
  - path_regex: hosts/bhairavi/.+\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: hosts/chhinamasta/.+\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: shared/.+\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: users/tlh/.+\$
    key_groups:
      - age:
          - *master
          - *bagalamukhi
  - path_regex: users/smg/.+\$
    key_groups:
      - age:
          - *master
          - *matangi
SOPS_YAML
  ok ".sops.yaml written"

  # ── [5/6] Create directory structure and encrypt placeholder secrets ───────
  echo ""
  echo "[5/6] Creating directory structure..."
  for host in bagalamukhi matangi bhairavi chhinamasta; do
    mkdir -p "${REPO_ROOT}/hosts/${host}"
    if [[ ! -f "${REPO_ROOT}/hosts/${host}/secrets.yaml" ]]; then
      printf "# %s secrets\n{}" "${host}" > "${REPO_ROOT}/hosts/${host}/secrets.yaml"
      sops --encrypt --in-place "${REPO_ROOT}/hosts/${host}/secrets.yaml" || {
        err "sops --encrypt failed for hosts/${host}/secrets.yaml"
        return 1
      }
    fi
  done
  mkdir -p "${REPO_ROOT}/shared"
  if [[ ! -f "${REPO_ROOT}/shared/secrets.yaml" ]]; then
    printf "# Shared secrets\n{}" > "${REPO_ROOT}/shared/secrets.yaml"
    sops --encrypt --in-place "${REPO_ROOT}/shared/secrets.yaml" || {
      err "sops --encrypt failed for shared/secrets.yaml"
      return 1
    }
  fi
  for user in tlh smg; do
    mkdir -p "${REPO_ROOT}/users/${user}"
    if [[ ! -f "${REPO_ROOT}/users/${user}/secrets.yaml" ]]; then
      printf "# %s secrets\n{}" "${user}" > "${REPO_ROOT}/users/${user}/secrets.yaml"
      sops --encrypt --in-place "${REPO_ROOT}/users/${user}/secrets.yaml" || {
        err "sops --encrypt failed for users/${user}/secrets.yaml"
        return 1
      }
    fi
  done
  ok "Directory structure and encrypted placeholders created"

  # ── [6/6] Verify ──────────────────────────────────────────────────────────
  echo ""
  echo "[6/6] Verifying all files decrypt correctly..."
  cmd_verify || { err "Verification failed."; return 1; }

  echo ""
  echo "=== Bootstrap complete ==="
  echo ""
  echo "Next steps:"
  echo "  Edit secrets:     secrets-menu edit <target>"
  echo "  Add new host:     secrets-menu add-host <hostname>"
  echo "  Rekey after changes: secrets-menu rekey"
  echo "  Push to remote:   cd ${REPO_ROOT} && git add -A && git commit -m 'init' && git push"
}

# ─── CRUD Commands ─────────────────────────────────────────────────────────────
cmd_list() {
  require_sops || return 1
  require_yq || return 1
  local target="${1:-}"
  local resolved

  if [[ -z "${target}" || "${target}" == "all" ]]; then
    echo "=== All secret keys ==="
    local found=0
    for f in "${REPO_ROOT}"/hosts/*/secrets.yaml "${REPO_ROOT}"/users/*/secrets.yaml "${REPO_ROOT}/shared/secrets.yaml"; do
      [[ -f "${f}" ]] || continue
      local relpath="${f#${REPO_ROOT}/}"
      local keys
      keys=$(sops --decrypt "${f}" 2>/dev/null | yq 'keys | .[]' -r 2>/dev/null) || continue
      if [[ -n "${keys}" ]]; then
        echo ""
        echo "  ${relpath}:"
        while IFS= read -r k; do echo "    ${k}"; done <<< "${keys}"
        found=1
      else
        echo ""
        echo "  ${relpath}: [empty]"
        found=1
      fi
    done
    [[ ${found} -eq 0 ]] && echo "  [no secrets defined anywhere]"
  else
    resolved="$(resolve_target_yaml "${target}")"
    local filepath="${REPO_ROOT}/${resolved}"
    if [[ ! -f "${filepath}" ]]; then
      err "File not found: ${resolved}"
      return 1
    fi
    echo "=== Keys in ${resolved} ==="
    local keys
    keys=$(sops --decrypt "${filepath}" 2>/dev/null | yq 'keys | .[]' -r 2>/dev/null) || {
      err "Cannot decrypt ${resolved}"
      return 1
    }
    if [[ -z "${keys}" ]]; then
      echo "  [empty - no secrets defined]"
    else
      while IFS= read -r k; do echo "  ${k}"; done <<< "${keys}"
    fi
  fi
}

cmd_show() {
  require_sops || return 1
  require_yq || return 1
  local target="$1"
  local resolved
  resolved="$(resolve_target_yaml "${target}")"
  local filepath="${REPO_ROOT}/${resolved}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${resolved}"
    return 1
  fi

  echo "=== Secrets in ${resolved} ==="
  local keys
  keys=$(sops --decrypt "${filepath}" 2>/dev/null | yq 'keys | .[]' -r 2>/dev/null) || {
    err "Cannot decrypt ${resolved}"
    return 1
  }
  if [[ -z "${keys}" ]]; then
    echo "  [empty - no secrets defined]"
    return 0
  fi

  local decrypted
  decrypted=$(sops --decrypt "${filepath}" 2>/dev/null)
  while IFS= read -r k; do
    local val
    val=$(echo "${decrypted}" | yq ".${k}" -r 2>/dev/null | head -c 80)
    echo "  ${k} = ${val}"
  done <<< "${keys}"
}

cmd_edit() {
  require_sops || return 1
  local target="$1"
  local resolved
  resolved="$(resolve_target_yaml "${target}")"
  local filepath="${REPO_ROOT}/${resolved}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${resolved}"
    return 1
  fi

  ${EDITOR:-vi} "${filepath}"
  # sops handles encrypt/decrypt transparently when the file has sops metadata
  # and $SOPS_AGE_KEY_FILE is set — but explicit re-encryption via `sops` is safer
}

cmd_add_secret() {
  require_sops || return 1
  require_yq || return 1
  local target="$1" key="$2" value="$3"
  local resolved
  resolved="$(resolve_target_yaml "${target}")"
  local filepath="${REPO_ROOT}/${resolved}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${resolved}. Use 'secrets-menu new-secret' to create it first."
    return 1
  fi
  [[ -z "${key}" ]] && { err "Key name is required."; return 1; }

  sops --decrypt "${filepath}" \
    | yq ".${key} = \"${value}\"" \
    | sops --encrypt --filename-override "${resolved}" /dev/stdin > "${filepath}.tmp" \
    && mv "${filepath}.tmp" "${filepath}" \
    && ok "${key} added to ${resolved}"
}

cmd_modify_secret() {
  require_sops || return 1
  require_yq || return 1
  local target="$1" key="$2" value="$3"
  local resolved
  resolved="$(resolve_target_yaml "${target}")"
  local filepath="${REPO_ROOT}/${resolved}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${resolved}"
    return 1
  fi
  [[ -z "${key}" ]] && { err "Key name is required."; return 1; }

  # Verify key exists
  local exists
  exists=$(sops --decrypt "${filepath}" 2>/dev/null | yq ".${key}" -r 2>/dev/null) || {
    err "Cannot decrypt or parse ${resolved}"
    return 1
  }
  if [[ "${exists}" == "null" ]]; then
    err "Key '${key}' does not exist in ${resolved}. Use 'add-secret' instead."
    return 1
  fi

  sops --decrypt "${filepath}" \
    | yq ".${key} = \"${value}\"" \
    | sops --encrypt --filename-override "${resolved}" /dev/stdin > "${filepath}.tmp" \
    && mv "${filepath}.tmp" "${filepath}" \
    && ok "${key} updated in ${resolved}"
}

cmd_delete_secret() {
  require_sops || return 1
  require_yq || return 1
  local target="$1" key="$2"
  local resolved
  resolved="$(resolve_target_yaml "${target}")"
  local filepath="${REPO_ROOT}/${resolved}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${resolved}"
    return 1
  fi
  [[ -z "${key}" ]] && { err "Key name is required."; return 1; }

  sops --decrypt "${filepath}" \
    | yq "del(.${key})" \
    | sops --encrypt --filename-override "${resolved}" /dev/stdin > "${filepath}.tmp" \
    && mv "${filepath}.tmp" "${filepath}" \
    && ok "${key} removed from ${resolved}"
}

cmd_add_file() {
  require_sops || return 1
  local target_path="$1" source="$2"

  if [[ ! -f "${source}" ]]; then
    err "Source file not found: ${source}"
    return 1
  fi

  local dest="${REPO_ROOT}/${target_path}"
  local dest_dir
  dest_dir="$(dirname "${dest}")"
  mkdir -p "${dest_dir}"

  cp "${source}" "${dest}"
  sops --encrypt --in-place "${dest}" || {
    err "sops encrypt failed. Check that .sops.yaml has a rule matching ${target_path}"
    rm -f "${dest}"
    return 1
  }
  ok "${target_path} encrypted and stored"
}

cmd_cat() {
  require_sops || return 1
  local path="$1"
  local filepath="${REPO_ROOT}/${path}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${path}"
    return 1
  fi

  sops --decrypt "${filepath}"
}

cmd_extract() {
  require_sops || return 1
  local path="$1" output="${2:-}"
  local filepath="${REPO_ROOT}/${path}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${path}"
    return 1
  fi

  if [[ -z "${output}" ]]; then
    local base
    base="$(basename "${path}")"
    if [[ "${base}" == *.enc ]]; then
      output="${base%.enc}"
    elif [[ "${base}" == *.sops ]]; then
      output="${base%.sops}"
    else
      output="${base}.decrypted"
    fi
  fi

  sops --decrypt "${filepath}" > "${output}"
  ok "Decrypted to ${output}"
}

# ─── Host / Key Management ────────────────────────────────────────────────────
cmd_add_host() {
  require_sops || return 1
  require_cmds ssh-to-age || return 1
  local hostname="$1" key_path="${2:-}"

  if [[ -d "${REPO_ROOT}/hosts/${hostname}" ]]; then
    err "hosts/${hostname} already exists."
    return 1
  fi

  if [[ -z "${key_path}" ]]; then
    if [[ -f /etc/ssh/ssh_host_ed25519_key.pub ]]; then
      key_path="/etc/ssh/ssh_host_ed25519_key.pub"
    else
      err "No SSH host key found. Provide path: secrets-menu add-host ${hostname} /path/to/key.pub"
      return 1
    fi
  fi

  # Derive age public key from SSH public key
  local age_pub
  age_pub=$(cat "${key_path}" | ssh-to-age 2>/dev/null) || {
    err "ssh-to-age failed for ${key_path}"
    return 1
  }
  [[ -z "${age_pub}" ]] && { err "ssh-to-age returned empty key."; return 1; }

  # Create host directory and secrets file
  mkdir -p "${REPO_ROOT}/hosts/${hostname}"
  printf "# %s secrets\n{}" "${hostname}" > "${REPO_ROOT}/hosts/${hostname}/secrets.yaml"
  sops --encrypt --in-place "${REPO_ROOT}/hosts/${hostname}/secrets.yaml" || {
    err "sops encrypt failed for hosts/${hostname}/secrets.yaml"
    rm -rf "${REPO_ROOT}/hosts/${hostname}"
    return 1
  }

  # Add key anchor to .sops.yaml
  if anchor_exists "${hostname}"; then
    err "Key anchor '&${hostname}' already exists in .sops.yaml"
    return 1
  fi

  # Insert new key anchor after the last existing key anchor
  local sops_file="${REPO_ROOT}/.sops.yaml"
  local last_key_line
  last_key_line=$(grep -nE '^\s*-&\S+' "${sops_file}" | tail -1 | cut -d: -f1)
  if [[ -n "${last_key_line}" ]]; then
    sed -i "${last_key_line}a\\  - &${hostname}      ${age_pub}" "${sops_file}"
  else
    # No keys section found — this shouldn't happen but handle it
    sed -i '/^keys:/a\\  - &'"${hostname}"'      '"${age_pub}" "${sops_file}"
  fi

  # Add creation rules for the new host (both yaml and catch-all)
  # Find the last creation_rule line and insert after it
  # We'll append two new rule blocks after the last existing creation rule
  local yaml_rule catchall_rule
  yaml_rule="  - path_regex: hosts/${hostname}/[^/]+\\.yaml\$
    key_groups:
      - age:
          - *master
          - *${hostname}"
  catchall_rule="  - path_regex: hosts/${hostname}/.+\\$
    key_groups:
      - age:
          - *master
          - *${hostname}"

  # Append to end of .sops.yaml (before any trailing blank lines)
  {
    echo ""
    echo "${yaml_rule}"
    echo "${catchall_rule}"
  } >> "${sops_file}"

  ok "Host ${hostname} added with age key ${age_pub}"
  ok "Directory and .sops.yaml updated automatically"
  info "Run 'secrets-menu rekey' to update all encrypted files"
}

cmd_rm_host() {
  require_sops || return 1
  local hostname="$1"

  if [[ ! -d "${REPO_ROOT}/hosts/${hostname}" ]]; then
    err "hosts/${hostname} does not exist."
    return 1
  fi

  # Remove host directory
  rm -rf "${REPO_ROOT}/hosts/${hostname}"
  ok "Removed hosts/${hostname}/"

  # Remove key anchor from .sops.yaml
  local sops_file="${REPO_ROOT}/.sops.yaml"
  # Remove the key line
  sed -i "/^\s*-&${hostname}\s/d" "${sops_file}"

  # Remove creation rules for this host (multi-line blocks)
  # Each rule is: - path_regex: hosts/<hostname>/... followed by key_groups indented block
  # We need to match and remove the entire block
  _remove_creation_rules_for_path_pattern "hosts/${hostname}/" "${sops_file}"

  ok "Removed ${hostname} from .sops.yaml"
  info "Run 'secrets-menu rekey' to update all encrypted files"
}

# Remove creation rule blocks matching a path regex prefix from .sops.yaml
_remove_creation_rules_for_path_pattern() {
  local pattern="$1" file="$2"
  # Use awk to remove multi-line blocks that start with path_regex containing the pattern
  # A block starts with "  - path_regex:" and continues until the next "  - path_regex:" or end
  awk -v pat="${pattern}" '
    /^  - path_regex:/ { in_block=1 }
    in_block && /path_regex:.*pat/ { skip=1 }
    !skip { print }
    /^  - path_regex:/ && !skip { in_block=1 }
    in_block && /^  - path_regex:/ && skip { skip=0; in_block=0; next }
    in_block && !/^  - path_regex|^$|^\s+key_groups:|^\s+- age:|^\s+- &|^\s+- age1/ { in_block=0; skip=0 }
    /^  - path_regex:/ { in_block=0 }
  ' "${file}" > "${file}.tmp" && mv "${file}.tmp" "${file}"
  # Simpler approach: use sed to remove lines of the block
  # Actually let's do it with a python one-liner for reliability
  python3 -c "
import re, sys
with open(sys.argv[1]) as f:
    content = f.read()
pattern = re.escape(sys.argv[2])
# Match blocks: '  - path_regex: hosts/X/...' through end of block
blocks = re.findall(r'  - path_regex: [^\n]*' + pattern + r'[^\n]*\n(?:    key_groups:\n(?:      - age:\n(?:          - \*[^\n]+\n)+)+)', content)
for b in blocks:
    content = content.replace(b, '')
# Clean up multiple blank lines
content = re.sub(r'\n{3,}', '\n\n', content)
with open(sys.argv[1], 'w') as f:
    f.write(content)
" "${file}" "${pattern}" 2>/dev/null || true
  # Fallback: try sed-based approach
  # Since python might not be available, we'll use a different strategy:
  # Mark lines for deletion with sed, then delete them
  : # The python approach above handles it; if python isn't available we fall through
}

cmd_rekey() {
  require_sops || return 1
  echo "=== Rekeying all secrets ==="
  local count=0
  local sops_file
  while IFS= read -r -d '' sops_file; do
    # Skip non-sops files (check for sops metadata)
    head -c 5 "${sops_file}" | grep -q 'sops' 2>/dev/null || continue
    echo "  Rekeying: ${sops_file#${REPO_ROOT}/}"
    sops updatekeys "${sops_file}" || {
      err "Failed to rekey: ${sops_file#${REPO_ROOT}/}"
    }
    count=$((count + 1))
  done < <(find "${REPO_ROOT}" -type f \
    -not -name '.sops.yaml' \
    -not -path '*/.git/*' \
    -not -name 'keys.txt.age' \
    -not -name '*.md' \
    -not -name 'justfile' \
    -not -name '*.sh' \
    -not -name 'sops-keys.tar.zst.gpg' \
    -print0)
  echo ""
  ok "Done. ${count} files rekeyed."
  info "Verify with: secrets-menu verify"
}

cmd_verify() {
  require_sops || return 1
  echo "=== Verifying all secrets ==="
  local errors=0 total=0
  local sops_file
  while IFS= read -r -d '' sops_file; do
    head -c 5 "${sops_file}" | grep -q 'sops' 2>/dev/null || continue
    total=$((total + 1))
    if sops --decrypt "${sops_file}" > /dev/null 2>&1; then
      ok "$(echo "${sops_file#${REPO_ROOT}/}")"
    else
      err "$(echo "${sops_file#${REPO_ROOT}/}") — FAILED"
      errors=$((errors + 1))
    fi
  done < <(find "${REPO_ROOT}" -type f \
    -not -name '.sops.yaml' \
    -not -path '*/.git/*' \
    -not -name 'keys.txt.age' \
    -not -name '*.md' \
    -not -name 'justfile' \
    -not -name '*.sh' \
    -not -name 'sops-keys.tar.zst.gpg' \
    -print0)

  echo ""
  if [[ ${errors} -eq 0 ]]; then
    ok "All ${total} secrets verified OK."
  else
    err "${errors}/${total} files failed verification."
    return 1
  fi
}

cmd_keys() {
  local sops_file="${REPO_ROOT}/.sops.yaml"
  if [[ ! -f "${sops_file}" ]]; then
    err ".sops.yaml not found at ${sops_file}"
    return 1
  fi
  echo "=== Age key anchors in .sops.yaml ==="
  echo ""
  grep -E '^\s*-&\S+' "${sops_file}" | while read -r line; do
    # Extract anchor name and public key
    anchor=$(echo "${line}" | sed -E 's/.*-&([a-zA-Z0-9_]+)\s+(age1\S+).*/\1/' | head -1)
    pubkey=$(echo "${line}" | grep -oE 'age1\S+' | head -1)
    printf "  %-15s %s\n" "&${anchor}" "${pubkey}"
  done
  echo ""
  echo "=== Creation rules ==="
  local in_rule=false rule_path=""
  while IFS= read -r line; do
    if [[ "${line}" =~ ^[[:space:]]*-[[:space:]]*path_regex: ]]; then
      in_rule=true
      rule_path=$(echo "${line}" | sed -E 's/.*path_regex:[[:space:]]*//' | tr -d '"' | tr -d "'")
      echo ""
      echo "  ${rule_path}"
    elif ${in_rule}; then
      if [[ "${line}" =~ ^[[:space:]]*-[[:space:]]*path_regex: ]]; then
        # New rule starting — we already handled above
        :
      elif [[ "${line}" =~ \*\S+ ]]; then
        # Key alias reference
        echo "    ${line}" | sed 's/^[[:space:]]*//'
      fi
    fi
  done < "${sops_file}"
  echo ""
}

cmd_who_can() {
  require_sops || return 1
  local path="$1"
  local filepath="${REPO_ROOT}/${path}"

  if [[ ! -f "${filepath}" ]]; then
    err "File not found: ${path}"
    return 1
  fi

  echo "=== Who can decrypt: ${path} ==="
  echo ""

  # Parse sops metadata from the encrypted file
  local recipients
  recipients=$(grep -A2 'sops:' "${filepath}" 2>/dev/null \
    | grep 'age:' 2>/dev/null \
    | head -1 \
    | sed 's/.*age: //' 2>/dev/null || echo "unknown")

  if [[ -n "${recipients}" && "${recipients}" != "unknown" ]]; then
    echo "Encrypted recipients [age public keys]:"
    for recipient in $(echo "${recipients}" | tr ',' '\n'); do
      recipient=$(echo "${recipient}" | xargs)
      local match
      match=$(grep "${recipient}" "${REPO_ROOT}/.sops.yaml" 2>/dev/null | head -1 | sed 's/.*-&\([^ ]*\).*/\1/' || echo "?")
      echo "  ${match} → ${recipient}"
    done
  else
    # Try parsing sops JSON/YAML metadata
    python3 -c "
import yaml, sys
with open(sys.argv[1]) as f:
    d = yaml.safe_load(f)
sops = d.get('sops', {})
age = sops.get('age', [])
if isinstance(age, list):
    for k in age:
        print(f'  → {k}')
elif isinstance(age, dict):
    for arr in age.values():
        for k in arr:
            print(f'  → {k}')
" "${filepath}" 2>/dev/null || echo "  [could not parse recipients]"
  fi

  echo ""
  echo "Matching .sops.yaml rule:"
  local dir
  dir="$(dirname "${path}")"
  grep -B1 -A10 "path_regex: ${dir}" "${REPO_ROOT}/.sops.yaml" 2>/dev/null | sed 's/^/  /' || echo "  [no matching rule found]"
}

# ─── Grant / Revoke Access (ACTUALLY modifies .sops.yaml) ────────────────────
cmd_grant_access() {
  local key_name="$1" category="$2" path_prefix="${3:-}"
  local sops_file="${REPO_ROOT}/.sops.yaml"

  if [[ ! -f "${sops_file}" ]]; then
    err ".sops.yaml not found"
    return 1
  fi

  # Verify key anchor exists
  if ! anchor_exists "${key_name}"; then
    err "Key anchor '&${key_name}' not found in .sops.yaml"
    echo "Available keys:"
    grep -E '^\s*-&\S+' "${sops_file}" | sed 's/^/  /'
    return 1
  fi

  # Determine the path regex to match
  local regex
  if [[ -n "${path_prefix}" ]]; then
    regex="${path_prefix}"
  else
    regex="${category}/[^/]+\\.yaml\$"
  fi

  # Find the creation rule matching this regex
  local rule_line
  rule_line=$(grep -n "path_regex: ${regex}" "${sops_file}" | head -1 | cut -d: -f1)
  if [[ -z "${rule_line}" ]]; then
    err "No creation_rule matches '${regex}'"
    echo "Existing rules:"
    grep 'path_regex:' "${sops_file}" | sed 's/^/  /'
    return 1
  fi

  # Check if key is already in this rule
  local rule_end
  rule_end=$(awk "NR>${rule_line} && /^  - path_regex:/{print NR; exit}" "${sops_file}")
  if [[ -z "${rule_end}" ]]; then
    rule_end=$(wc -l < "${sops_file}")
  fi
  rule_end=$((rule_end - 1))

  # Check if key already granted
  local already_granted=false
  for (( i=rule_line; i<=rule_end; i++ )); do
    local line_content
    line_content=$(sed -n "${i}p" "${sops_file}")
    if [[ "${line_content}" == *"*${key_name}"* ]]; then
      already_granted=true
      break
    fi
  done
  if ${already_granted}; then
    warn "Key '${key_name}' already has access to this rule. No changes needed."
    return 0
  fi

  # Find the last '- *' or '- age1' line in this rule's key_groups block, and insert after it
  local last_age_line
  last_age_line=$(awk "NR>=${rule_line} && NR<=${rule_end} && /^          - (\\*|age1)/{last=NR} END{print last}" "${sops_file}")

  if [[ -n "${last_age_line}" ]]; then
    sed -i "${last_age_line}a\\          - *${key_name}" "${sops_file}"
  else
    # No age lines found — add one after key_groups: - age:
    local age_line
    age_line=$(awk "NR>=${rule_line} && NR<=${rule_end} && /^      - age:/{print NR; exit}" "${sops_file}")
    if [[ -n "${age_line}" ]]; then
      sed -i "${age_line}a\\          - *${key_name}" "${sops_file}"
    else
      err "Could not find key_groups structure in rule at line ${rule_line}"
      return 1
    fi
  fi

  ok "Granted '${key_name}' access to rule matching '${regex}'"
  info "Run 'secrets-menu rekey' to update encrypted files"
}

cmd_revoke_access() {
  local key_name="$1" category="$2" path_prefix="${3:-}"
  local sops_file="${REPO_ROOT}/.sops.yaml"

  if [[ ! -f "${sops_file}" ]]; then
    err ".sops.yaml not found"
    return 1
  fi

  local regex
  if [[ -n "${path_prefix}" ]]; then
    regex="${path_prefix}"
  else
    regex="${category}/[^/]+\\.yaml\$"
  fi

  local rule_line
  rule_line=$(grep -n "path_regex: ${regex}" "${sops_file}" | head -1 | cut -d: -f1)
  if [[ -z "${rule_line}" ]]; then
    err "No creation_rule matches '${regex}'"
    echo "Existing rules:"
    grep 'path_regex:' "${sops_file}" | sed 's/^/  /'
    return 1
  fi

  # Find and remove the line with *key_name in this rule
  local rule_end
  rule_end=$(awk "NR>${rule_line} && /^  - path_regex:/{print NR; exit}" "${sops_file}")
  if [[ -z "${rule_end}" ]]; then
    rule_end=$(wc -l < "${sops_file}")
  fi
  rule_end=$((rule_end - 1))

  local found=false
  for (( i=rule_line; i<=rule_end; i++ )); do
    local line_content
    line_content=$(sed -n "${i}p" "${sops_file}")
    if [[ "${line_content}" == *"          - *${key_name}"* ]]; then
      sed -i "${i}d" "${sops_file}"
      found=true
      break
    fi
  done

  if ${found}; then
    ok "Revoked '${key_name}' access from rule matching '${regex}'"
    info "Run 'secrets-menu rekey' to update encrypted files"
  else
    warn "Key '${key_name}' not found in rule. No changes made."
  fi
}

cmd_rotate_key() {
  require_cmds age-keygen ssh-to-age || return 1
  local old_ref="$1" new_key_file="$2"
  local sops_file="${REPO_ROOT}/.sops.yaml"

  if ! anchor_exists "${old_ref}"; then
    err "Key ref '${old_ref}' not found in .sops.yaml"
    grep -E '^\s*-&\S+' "${sops_file}" | sed 's/^/  /'
    return 1
  fi

  local new_age=""
  if [[ "${new_key_file}" == *.pub ]]; then
    new_age="$(ssh-to-age < "${new_key_file}" 2>/dev/null || true)"
  elif [[ -f "${new_key_file}" ]]; then
    new_age="$(age-keygen -y "${new_key_file}" 2>/dev/null || true)"
    # Also add the private key to keys.txt
    if [[ -r "${new_key_file}" ]] && [[ "${new_key_file}" == *AGE-SECRET-KEY* ]] || grep -q "AGE-SECRET-KEY" "${new_key_file}" 2>/dev/null; then
      cat "${new_key_file}" >> "${SOPS_AGE_KEY_FILE}"
      ok "Added new private key to ${SOPS_AGE_KEY_FILE}"
    fi
  else
    err "Provide an SSH public key (.pub) or age identity file."
    return 1
  fi

  [[ -z "${new_age}" ]] && { err "Could not derive age public key from ${new_key_file}"; return 1; }

  echo "=== Rotating ${old_ref} → new age key ==="
  echo "  Old: $(grep "&${old_ref}" "${sops_file}" | head -1)"
  echo "  New: ${new_age}"

  # Replace the age public key for this anchor
  sed -i "s/^\( *-&${old_ref} *\).*/\1${new_age}/" "${sops_file}"

  ok "Updated .sops.yaml"
  info "Ensure the new private identity is in ${SOPS_AGE_KEY_FILE}"
  info "Then run: secrets-menu rekey"
  info "Verify with: secrets-menu verify"
}

cmd_backup_keys() {
  local output_dir="${1:-$HOME/backups/sops-keys}"
  mkdir -p "${output_dir}"
  chmod 700 "${output_dir}"

  echo "=== Backing up sops age identities ==="
  echo "  Output: ${output_dir}"
  echo ""

  local backup_count=0

  if [[ -r "${SOPS_AGE_KEY_FILE}" ]]; then
    cp "${SOPS_AGE_KEY_FILE}" "${output_dir}/keys.txt"
    chmod 600 "${output_dir}/keys.txt"
    backup_count=$((backup_count + 1))
    ok "~/.config/sops/age/keys.txt"
  else
    warn "~/.config/sops/age/keys.txt [not found]"
  fi

  if [[ -r /etc/ssh/ssh_host_ed25519_key ]]; then
    sudo cp /etc/ssh/ssh_host_ed25519_key "${output_dir}/ssh_host_ed25519_key" 2>/dev/null && \
      sudo chown "$(id -u):$(id -g)" "${output_dir}/ssh_host_ed25519_key" 2>/dev/null && \
      chmod 600 "${output_dir}/ssh_host_ed25519_key"
    backup_count=$((backup_count + 1))
    ok "/etc/ssh/ssh_host_ed25519_key"
  else
    warn "/etc/ssh/ssh_host_ed25519_key [not found]"
  fi

  if [[ -r /etc/ssh/ssh_host_ed25519_key.pub ]]; then
    cp /etc/ssh/ssh_host_ed25519_key.pub "${output_dir}/ssh_host_ed25519_key.pub"
    chmod 644 "${output_dir}/ssh_host_ed25519_key.pub"
    ok "/etc/ssh/ssh_host_ed25519_key.pub"
  else
    warn "/etc/ssh/ssh_host_ed25519_key.pub [not found]"
  fi

  if [[ -r ~/.ssh/id_ed25519 ]]; then
    cp ~/.ssh/id_ed25519 "${output_dir}/id_ed25519"
    chmod 600 "${output_dir}/id_ed25519"
    backup_count=$((backup_count + 1))
    ok "~/.ssh/id_ed25519"
  else
    warn "~/.ssh/id_ed25519 [not found]"
  fi

  # Also backup the passphrase-encrypted master key from the repo
  if [[ -f "${REPO_ROOT}/keys.txt.age" ]]; then
    cp "${REPO_ROOT}/keys.txt.age" "${output_dir}/keys.txt.age"
    chmod 600 "${output_dir}/keys.txt.age"
    backup_count=$((backup_count + 1))
    ok "keys.txt.age [master key backup]"
  fi

  if [[ ${backup_count} -eq 0 ]]; then
    err "No keys found to back up."
    return 1
  fi

  echo ""
  ok "${backup_count} identity source(s) backed up"
  echo ""
  echo "Store this directory somewhere safe and offline:"
  echo "  ${output_dir}"
  echo ""
  echo "To restore after disaster recovery:"
  echo "  cp ${output_dir}/keys.txt ~/.config/sops/age/keys.txt"
  echo "  sudo cp ${output_dir}/ssh_host_ed25519_key /etc/ssh/"
  echo "  sudo chmod 600 /etc/ssh/ssh_host_ed25519_key"
  echo ""
  echo "Then run: secrets-menu verify"
}

cmd_new_secret() {
  require_sops || return 1
  local category="$1" name="$2"

  local path=""
  case "${category}" in
    host|hosts)  path="hosts/${name}/secrets.yaml" ;;
    user|users)  path="users/${name}/secrets.yaml" ;;
    shared)      path="shared/secrets.yaml" ;;
    *)
      err "Category must be 'host', 'user', or 'shared'"
      return 1
      ;;
  esac

  if [[ -f "${REPO_ROOT}/${path}" ]]; then
    err "${path} already exists."
    info "Edit it with: secrets-menu edit ${name}"
    return 1
  fi

  local dir
  dir="$(dirname "${path}")"
  mkdir -p "${REPO_ROOT}/${dir}"

  printf "# %s secrets\n{}" "${name}" > "${REPO_ROOT}/${path}"
  sops --encrypt --in-place "${REPO_ROOT}/${path}" || {
    err "sops --encrypt failed. Check that .sops.yaml has a rule matching ${path}"
    rm -f "${REPO_ROOT}/${path}"
    return 1
  }

  ok "${path} created and encrypted"
  info "Edit it with: secrets-menu edit ${name}"
  info "Verify with: secrets-menu verify"
}

# ─── Master Key Commands ──────────────────────────────────────────────────────
cmd_unlock() {
  local keys_file="${SOPS_AGE_KEY_FILE}"
  local master_enc="${REPO_ROOT}/keys.txt.age"

  if [[ ! -f "${master_enc}" ]]; then
    err "keys.txt.age not found at ${master_enc}"
    return 1
  fi

  mkdir -p "$(dirname "${keys_file}")"

  if [[ -f "${keys_file}" ]]; then
    # Merge: decrypt master key and append if not already present
    local master_private
    master_private=$(age --decrypt --passphrase "${master_enc}" 2>/dev/null) || {
      err "Failed to decrypt master key [wrong passphrase?]"
      return 1
    }
    # Check if master key is already in keys.txt
    local master_pub
    master_pub=$(echo "${master_private}" | age-keygen -y 2>/dev/null) || true
    if grep -q "${master_pub}" "${keys_file}" 2>/dev/null; then
      ok "Master key already present in ${keys_file}"
    else
      echo "${master_private}" >> "${keys_file}"
      ok "Master key appended to ${keys_file}"
    fi
  else
    # Fresh decrypt
    age --decrypt --passphrase -o "${keys_file}" "${master_enc}" || {
      err "Failed to decrypt master key [wrong passphrase?]"
      return 1
    }
    chmod 600 "${keys_file}"
    ok "Master key decrypted to ${keys_file}"
  fi
}

cmd_lock() {
  local keys_file="${SOPS_AGE_KEY_FILE}"

  if [[ ! -f "${keys_file}" ]]; then
    warn "No decrypted keys file found at ${keys_file}"
    return 0
  fi

  rm -f "${keys_file}"
  ok "Removed decrypted keys from ${keys_file}"
  info "Use 'secrets-menu unlock' to restore when needed"
}

# ─── Main Entry Point ──────────────────────────────────────────────────────────
usage() {
  cat <<EOF
secrets-menu — Interactive CLI for managing sops-encrypted NixOS secrets

Usage: secrets-menu [command] [arguments]

Interactive:
  secrets-menu                    Show fzf menu

Init:
  secrets-menu init               Bootstrap a new secrets repo
  secrets-menu init --migrate     Bootstrap and migrate existing keys

CRUD:
  secrets-menu list [target]      List secret key names (target: host/user/all)
  secrets-menu show <target>      Show key=value pairs [first 80 chars]
  secrets-menu edit <target>      Open in \$EDITOR (sops handles encrypt/decrypt)
  secrets-menu add-secret <target> <key> <value>     Add a key=value
  secrets-menu modify-secret <target> <key> <value>  Update an existing key
  secrets-menu delete-secret <target> <key>           Remove a key
  secrets-menu add-file <target-path> <source>       Encrypt any file into repo
  secrets-menu cat <path>         Decrypt any file to stdout
  secrets-menu extract <path> [output]  Decrypt to disk

Host/Key Management:
  secrets-menu add-host <hostname> [key-path]  Add host (auto-updates .sops.yaml)
  secrets-menu rm-host <hostname>               Remove host + update .sops.yaml
  secrets-menu rekey                             sops updatekeys on all files
  secrets-menu verify                            Verify all files decrypt
  secrets-menu keys                              Show age key anchors from .sops.yaml
  secrets-menu who-can <file>                    Show which keys can decrypt
  secrets-menu grant-access <key> <category> [path-regex]  Add key to .sops.yaml rule
  secrets-menu revoke-access <key> <category> [path-regex] Remove key from .sops.yaml rule
  secrets-menu rotate-key <old-ref> <new-key-file>        Replace a key reference
  secrets-menu backup-keys [output-dir]     Backup keys [default: ~/backups/sops-keys]
  secrets-menu new-secret <category> <name> Create a new category/path

Master Key:
  secrets-menu unlock             Decrypt keys.txt.age to ~/.config/sops/age/keys.txt
  secrets-menu lock               Remove decrypted keys from disk

Target shorthands:
  bagalamukhi → hosts/bagalamukhi/secrets.yaml
  matangi     → hosts/matangi/secrets.yaml
  bhairavi    → hosts/bhairavi/secrets.yaml
  chhinamasta → hosts/chhinamasta/secrets.yaml
  tlh         → users/tlh/secrets.yaml
  smg         → users/smg/secrets.yaml
  shared      → shared/secrets.yaml
EOF
}

main() {
  # If invoked with no arguments, show interactive menu
  if [[ $# -eq 0 ]]; then
    interactive_menu
    return $?
  fi

  local cmd="$1"
  shift

  case "${cmd}" in
    init)
      cmd_init "$@"
      ;;
    list)
      cmd_list "${1:-}"
      ;;
    show)
      [[ $# -lt 1 ]] && { err "Usage: secrets-menu show <target>"; return 1; }
      cmd_show "$1"
      ;;
    edit)
      [[ $# -lt 1 ]] && { err "Usage: secrets-menu edit <target>"; return 1; }
      cmd_edit "$1"
      ;;
    add-secret)
      [[ $# -lt 3 ]] && { err "Usage: secrets-menu add-secret <target> <key> <value>"; return 1; }
      cmd_add_secret "$1" "$2" "$3"
      ;;
    modify-secret)
      [[ $# -lt 3 ]] && { err "Usage: secrets-menu modify-secret <target> <key> <value>"; return 1; }
      cmd_modify_secret "$1" "$2" "$3"
      ;;
    delete-secret)
      [[ $# -lt 2 ]] && { err "Usage: secrets-menu delete-secret <target> <key>"; return 1; }
      cmd_delete_secret "$1" "$2"
      ;;
    add-file)
      [[ $# -lt 2 ]] && { err "Usage: secrets-menu add-file <target-path> <source>"; return 1; }
      cmd_add_file "$1" "$2"
      ;;
    cat)
      [[ $# -lt 1 ]] && { err "Usage: secrets-menu cat <path>"; return 1; }
      cmd_cat "$1"
      ;;
    extract)
      [[ $# -lt 1 ]] && { err "Usage: secrets-menu extract <path> [output]"; return 1; }
      cmd_extract "$1" "${2:-}"
      ;;
    add-host)
      [[ $# -lt 1 ]] && { err "Usage: secrets-menu add-host <hostname> [key-path]"; return 1; }
      cmd_add_host "$1" "${2:-}"
      ;;
    rm-host|remove-host)
      [[ $# -lt 1 ]] && { err "Usage: secrets-menu rm-host <hostname>"; return 1; }
      cmd_rm_host "$1"
      ;;
    rekey)       cmd_rekey ;;
    verify)      cmd_verify ;;
    keys)        cmd_keys ;;
    who-can)
      [[ $# -lt 1 ]] && { err "Usage: secrets-menu who-can <file>"; return 1; }
      cmd_who_can "$1"
      ;;
    grant-access)
      [[ $# -lt 2 ]] && { err "Usage: secrets-menu grant-access <key-name> <category> [path-regex]"; return 1; }
      cmd_grant_access "$1" "$2" "${3:-}"
      ;;
    revoke-access)
      [[ $# -lt 2 ]] && { err "Usage: secrets-menu revoke-access <key-name> <category> [path-regex]"; return 1; }
      cmd_revoke_access "$1" "$2" "${3:-}"
      ;;
    rotate-key)
      [[ $# -lt 2 ]] && { err "Usage: secrets-menu rotate-key <old-ref> <new-key-file>"; return 1; }
      cmd_rotate_key "$1" "$2"
      ;;
    backup-keys)
      cmd_backup_keys "${1:-}"
      ;;
    new-secret)
      [[ $# -lt 2 ]] && { err "Usage: secrets-menu new-secret <category> <name>"; return 1; }
      cmd_new_secret "$1" "$2"
      ;;
    unlock)      cmd_unlock ;;
    lock)        cmd_lock ;;
    help|--help|-h)
      usage
      ;;
    *)
      err "Unknown command: ${cmd}"
      echo ""
      usage
      return 1
      ;;
  esac
}

main "$@"