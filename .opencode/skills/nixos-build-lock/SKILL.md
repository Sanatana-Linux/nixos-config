---
name: nixos-build-lock
description: Guard against concurrent NixOS builds/switches and enforce SOPS secrecy while working on the ShizNix flake. Adapted from jwiegley/claude-prompts/nixos. Use when about to build or switch a NixOS configuration in this repo.
tags: [nixos, build, lock, concurrency, sops, security]
license: MIT
---

# NixOS Build Lock & SOPS Safety

## Purpose

Prevent multiple NixOS build/switch jobs from running against the same system simultaneously, and reinforce the hard rule: **never decrypt SOPS secrets**.

## SOPS Secrets — Never Decrypt

Do not, under any circumstances, decrypt `external/secrets/secrets.yaml`. See `.opencode/rules/nix-secrets-management.md` for extensive notes on this important security consideration.

- Secrets are age-encrypted and decrypted at **activation time** by sops-nix.
- Never embed secret values in Nix strings (store paths are world-readable).
- Use the `sops` CLI only for editing encrypted values; never write decrypted output to disk.

## Build/Switch Lock

Before you intend to build or switch to a new configuration:

1. **Acquire the lock**: `touch /etc/nixos/.nixos-build`
2. **Do the build/switch**: `nixos-rebuild build --flake .#<host>` (or `switch`)
3. **Release the lock**: `rm /etc/nixos/.nixos-build`

If the lock file already exists (another build/switch in progress), **wait**:
- Poll every 10 seconds for up to 10 minutes
- Continue only once the file is removed

This guarantees only one build/switch job touches the system at a time.

## Workflow

```bash
# 1. Acquire the lock (abort if it already exists)
if [ -f /etc/nixos/.nixos-build ]; then
  echo "Another NixOS build is in progress; waiting..."
  for i in {1..60}; do
    sleep 10
    [ ! -f /etc/nixos/.nixos-build ] && break
  done
fi
touch /etc/nixos/.nixos-build

# 2. Build/switch (test on bhairavi first)
nixos-rebuild build --flake .#bhairavi          # safe test
# sudo nixos-rebuild switch --flake .#bagalamukhi --impure   # actual switch

# 3. Release the lock
rm -f /etc/nixos/.nixos-build
```

## Research & Tooling

- Use web search / documentation for NixOS research.
- Use `context7` (or the `context7-docs` skill) when code examples might help.
- Use the repository's `nix-build` / `nix-flake` / `nix-format` OpenCode tools rather than ad-hoc shell where possible.

## Related Skills

- **nixos-btw** — general administration (includes rebuild verbs)
- **nixos-ops** — multi-host deployment
- **nix-secrets** — sops-nix operations
