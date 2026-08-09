---
name: nixos-btw
description: Administer NixOS and Nix without falling into imperative distro habits — flakes, home-manager, generations, overlays, sops-nix secrets, store hygiene, rebuild verbs, and rollback. Adapted to the ShizNix multi-host flake (bagalamukhi, matangi, bhairavi, chhinamasta). Use for any nixos-rebuild, flake, module, secrets, or Nix administration task.
tags: [nix, nixos, flakes, home-manager, administration, rebuild, rollback]
license: MIT
---

# NixOS BTW: NixOS, Nix, and Flakes Administration

Administer NixOS declaratively. The system is a value computed from configuration; every change becomes an immutable generation; rollback is a bootloader entry away. This skill keeps that model intact and layers in the practical stack for the **ShizNix** repository.

## ShizNix Context

- **Flake-based**: `flake.nix` → `nixosConfigurations` for 4 hosts: `bagalamukhi` (primary laptop, user tlh), `matangi` (Sara's laptop, user smg), `bhairavi` (VM, user tlh), `chhinamasta` (Live USB ISO, user user).
- **Enable-by-option modules**: `modules/nixos/<category>/<name>.nix` declare `options.modules.<category>.<name>.enable` guarded by `lib.mkIf`. See `.opencode/rules/nix-module-patterns.md`.
- **Kernel**: cachyos-bore (not stock linuxPackages). Do not swap casually — NVIDIA PRIME sync + NVMe APST tuning depend on it.
- **Secrets**: sops-nix, age-encrypted `external/secrets/secrets.yaml`. See `.opencode/rules/nix-secrets-management.md`.
- **Home-manager**: integrated as a NixOS module (not standalone). `home-manager switch` alone is not the workflow — `nixos-rebuild switch` handles it.
- **Formatter**: `alejandra .`.
- **Overlays**: `overlays/` (additions, modifications, stable-packages). Custom packages in `pkgs/`.

## AI Self-Check (before returning commands)

- [ ] **Flake, not channels.** This repo is flake-based. Never suggest `nix-channel` or `<nixpkgs>`. Use `nix flake ...` and `nixos-rebuild --flake .#<host>`.
- [ ] **Rebuild verb is intentional.** `switch` activates now + persists boot entry; `boot` persists only; `test` activates now but does not persist boot entry; `build`/`dry-build`/`dry-activate` never change the live system. Prefer `build`/`dry-build` before touching a live host.
- [ ] **Host matters.** `bhairavi` is the safe VM test host. Do not run `switch` on `bagalamukhi` (the user's primary laptop) casually — use `build` first, or ask.
- [ ] **`nix-env -i` is not the answer.** Never install into the user/system profile imperatively. Use `environment.systemPackages`, `home.packages`, or `nix shell`.
- [ ] **Secrets never in the store.** Everything under `external/secrets/` is age-encrypted and decrypted at activation by sops-nix. Never embed a secret in a Nix string — it becomes world-readable in `/nix/store`.
- [ ] **Don't touch `system.stateVersion`.** It anchors migration semantics. Set once per host; never bump casually.
- [ ] **New files must be `git add`ed.** Flakes only see tracked files. Untracked `.nix` files silently don't apply.
- [ ] **Known-good generation preserved.** Never `nix-collect-garbage -d` right after a rebuild without confirming the new generation boots.
- [ ] **Option names verified.** Check options against this nixpkgs tag (`nixos-unstable`) before suggesting. Drift happens.
- [ ] **`external/` is off-limits** unless explicitly instructed — it holds git submodules (awesome, nvim, firefox, secrets) managed in their own repos.

## Rebuild Workflow (ShizNix)

```bash
# Safe test on the VM host (no live system risk)
nixos-rebuild build --flake .#bhairavi

# Dry-run activation without switching
nixos-rebuild dry-activate --flake .#bagalamukhi

# Actual switch on a host
sudo nixos-rebuild switch --flake .#bagalamukhi   # requires --impure (sops absolute path)

# Format before/after
alejandra .
```

Note: sops-nix uses an absolute path to `external/secrets/secrets.yaml`, so pure eval fails. Builds that involve sops need `--impure`.

## Gather Current State (start narrow, widen only as needed)

```bash
# Flake state
nix flake metadata | head -20
nix flake check --no-build

# Generations
nix-env --list-generations -p /nix/var/nix/profiles/system | tail -5

# Services / failures
systemctl --failed
journalctl -b -p warning..alert | tail -30

# Store health
df -h /nix/store
nix-store --gc --print-roots | wc -l
```

## Troubleshooting

1. Confirm the lane: flake-based NixOS, host in question, cachyos kernel.
2. Identify failing layer: input state → evaluation → build → activation → runtime service.
3. Pull logs before changing config.
4. Change one layer at a time and retest.
5. Prefer rollback over reinstall — generations are the point.

```bash
# Build/eval errors are loudest in rebuild output
nixos-rebuild build --flake .#<host> --show-trace --print-build-logs 2>&1 | tail -200
```

Common failure modes specific to this repo:
- **Untracked file** → `git add <file>` before building.
- **`pkgs.system` deprecation** → use `pkgs.stdenv.hostPlatform.system`. See `.opencode/rules/nix-pkgs-system-deprecation.md`.
- **Overlay collision** → check `overlays/` for double definitions; use `lib.mkForce`/`mkDefault` deliberately.
- **sops decrypt failure** → age key not in `external/secrets/.sops.yaml`; see `.opencode/rules/nix-secrets-management.md`.
- **Module option not applied** → confirm module is imported in the category `default.nix` AND the host enables it.

## Default Decisions

- **Declarative first.** Everything that survives a rebuild belongs in the config.
- **Build before switch.** Especially on the primary host.
- **Generations are rollback.** Confirm the previous generation boots before GC.
- **Store hygiene is scheduled.** `nix.gc.automatic` + `nix.settings.auto-optimise-store = true;` beat manual sweeps.
- **Secrets via sops-nix only.**
- **Kernel changes are cross-layer.** Do not swap `boot.kernelPackages` casually.

## Related Skills

- **nixos-module** — writing enable-by-option modules
- **nixos-best-practices** — overlay scope / useGlobalPkgs
- **nix-flake-ops** — flake input maintenance
- **nixos-debug** — build/eval failure diagnosis
- **nix-secrets** — sops-nix operations
- **nixos-ops** — multi-host deployment
