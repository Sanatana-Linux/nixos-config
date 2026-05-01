#!/usr/bin/env bash
set -euo pipefail

RED="\033[1;31m"; GREEN="\033[1;32m"; BOLD=$(tput bold); NORMAL=$(tput sgr0)
error()   { echo -e " ${RED}*${NORMAL}  $@"; }
success() { echo -e " ${GREEN}*${NORMAL}  $@"; }

SECRETS_DIR="$(cd "$(dirname "$0")" && pwd)"
HOSTNAME="${1:-}"

[[ -z "$HOSTNAME" ]] && { error "Usage: $0 <hostname>"; exit 1; }

echo "=== Post-Install Secrets Integration for: ${BOLD}${HOSTNAME}${NORMAL} ==="

echo "[1/6] Checking for sops-nix secret files..."
SOP_NIX_CFG="$SECRETS_DIR/../hosts/${HOSTNAME}/sops.nix"
if [[ ! -f "$SOP_NIX_CFG" ]]; then
  error "No sops.nix config found for host '${HOSTNAME}' at hosts/${HOSTNAME}/sops.nix"
  exit 1
fi
success "Found sops.nix config for ${HOSTNAME}"

echo "[2/6] Generating SSH host keys if missing..."
if [[ ! -f /etc/ssh/ssh_host_ed25519_key ]]; then
  ssh-keygen -A
  success "Generated SSH host keys"
else
  success "SSH host keys already exist"
fi

echo "[3/6] Extracting age public key from SSH host key..."
AGE_KEY=$(cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age 2>/dev/null)
if [[ -z "$AGE_KEY" ]]; then
  error "ssh-to-age failed. Is it installed? (nix-shell -p ssh-to-age)"
  exit 1
fi
echo "  Age public key: ${AGE_KEY}"

echo "[4/6] Checking secrets submodule status..."
cd "$SECRETS_DIR"
if [[ ! -f .sops.yaml ]]; then
  error "secrets submodule not initialized. Run: git submodule update --init external/secrets"
  exit 1
fi

NEEDS_REBUILD=false

if ! grep -qF "$AGE_KEY" .sops.yaml; then
  echo ""
  echo "  >>> The age key in .sops.yaml does not match the current host key."
  echo "  >>> This is normal for a first-time setup or after SSH host key regeneration."
  echo ""
  echo "  Please:"
  echo "    1. Update the age key in external/secrets/.sops.yaml to:"
  echo "       $AGE_KEY"
  echo "    2. Run 'just rekey' from external/secrets/"
  echo "    3. Commit and push the changes"
  echo "    4. Run this script again"
  echo ""
  error "Age key mismatch. See instructions above."
  exit 1
fi
success "Age key matches .sops.yaml"

echo "[5/6] Testing sops decryption..."
SOP_FILE="$SECRETS_DIR/hosts/${HOSTNAME}/secrets.yaml"
if [[ -f "$SOP_FILE" ]]; then
  if sops --decrypt "$SOP_FILE" > /dev/null 2>&1; then
    success "Secrets decrypt successfully"
  else
    error "Failed to decrypt secrets for ${HOSTNAME}"
    exit 1
  fi
else
  echo "  No secrets file found at ${SOP_FILE} — skipping decryption test"
fi

echo "[6/6] Rebuilding NixOS configuration with secrets..."
cd /etc/nixos
nixos-rebuild switch --flake ".#${HOSTNAME}" --impure
success "Secrets integration complete! ${HOSTNAME} is now configured with sops-nix."
