---
name: ultimate-nixos
description: Comprehensive Nix ecosystem guidance — derivations, modules, overlays, flakes, packaging, and security — adapted to the ShizNix repository's enable-by-option module pattern, unified flake, cachyos kernel, and sops-nix secrets. Use when packaging software, designing modules, managing overlays, or reasoning about the Nix evaluation/build model.
tags: [nix, nixpkgs, derivations, modules, overlays, packaging, security]
license: MIT
---

# Nix Ecosystem (NixOS, nixpkgs, nix-darwin)

Think in layers: **Nix language** evaluates expressions into **derivations**, which build into **store paths**. Everything else — NixOS, nix-darwin, Home Manager, flakes — is configuration that produces derivations.

## ShizNix Mental Model

```text
                    Nix language
                         |
                    evaluates to
                         |
                    derivations
                    /    |    \
               NixOS  (nix-darwin unused)  standalone
                |                |
            nixos-rebuild      nix build / nix develop
                |
            /etc/nixos (this repo: flake.nix)
                |
             nixpkgs (package set)
                |
          Home Manager (user env, NixOS module)
```

- **This repo**: unified multi-host flake. `flake.nix` defines inputs + `nixosConfigurations` for bagalamukhi, matangi, bhairavi, chhinamasta. Not flake-parts, not nix-darwin.
- **Derivations in ShizNix**: custom packages live in `pkgs/<name>/default.nix`, registered via `overlays/` additions overlay.

## Principles

### Reproducibility
Pin all inputs via `flake.lock`. Avoid `<nixpkgs>`, `nix-channel`, and hash-less `builtins.fetchTarball`. The same config on the same lockfile must produce the same system.

### Declarative configuration
Describe desired state, not steps. Prefer module options over post-activation scripts. If an option doesn't exist, write a module (see `nixos-module` skill) rather than a shell script.

### Modularity (ShizNix convention)
Every module declares `options.modules.<category>.<name>.enable = lib.mkEnableOption` and guards config with `lib.mkIf cfg.enable`. Compose via category `default.nix` imports. See `.opencode/rules/nix-module-patterns.md`.

### Security first
Secrets via sops-nix/age, never plaintext in the store. Sandbox services with systemd options. See `nix-secrets` skill and `.opencode/rules/nix-secrets-management.md`.

### Minimal rebuilds
Use `nixos-rebuild build` to test before switching. Understand rebuild cost — changes in `pkgs/` or `overlays/` trigger wider rebuilds than module config tweaks.

## ShizNix Red Flags

- Guessing option/attribute names instead of checking the pinned nixpkgs.
- `with pkgs;` at top of a file (pollutes scope).
- `<nixpkgs>` lookup paths in a flake repo.
- Overlays inside home-manager user config when home-manager uses `useGlobalPkgs = true` (ignored; belongs in `overlays/` or system `nixpkgs.overlays`).
- Baking secrets into the store.
- Using `pkgs.system` (deprecated) instead of `pkgs.stdenv.hostPlatform.system`.
- Editing `external/` submodules.

## Derivation & Packaging (ShizNix)

Custom packages go in `pkgs/<name>/default.nix`:

```nix
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "my-package";
  version = "1.0.0";
  src = fetchurl { url = "..."; sha256 = "..."; };
  # installPhase, meta, etc.
  meta = with lib; {
    description = "...";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
```

Register in `overlays/default.nix` under `additions` (`final: prev: { my-package = final.callPackage ../pkgs/my-package { }; }`).

For pre-compiled binaries, see `nix-packaging-best-practices` skill.

## Module System (ShizNix)

```nix
{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.modules.<category>.<name>;
in {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "description";
    someOption = mkOption { type = types.str; default = "x"; };
  };
  config = mkIf cfg.enable { /* ... */ };
}
```

- Register module in the category's `default.nix` imports.
- `git add` the new file.
- Use `lib.mkDefault`/`mkForce`/`mkMerge` deliberately; avoid `//`.

## Overlays (ShizNix)

`overlays/` is split into additions, modifications, cachyos-patches, stable-packages. Use:
- `pkgs/` for new packages (via additions overlay).
- `overlays/` modifications for patching existing nixpkgs packages.
- `final: prev: { ... }` scope — never mutate `pkgs` in place.

## Security Hardening (ShizNix)

- Base: see `modules/nixos/system/security/` (firewall, ssh, doas, fail2ban, tpm).
- Secrets: sops-nix. Never commit plaintext secrets.
- Services: prefer systemd sandboxing options.

## Quick Task Map

| Task | Where to look |
|------|---------------|
| Package new software | `pkgs/`, `overlays/`, `nix-packaging-best-practices` |
| Configure a host | `hosts/<host>/default.nix` + modules |
| Write a module | `nixos-module` skill + `.opencode/rules/nix-module-patterns.md` |
| Manage secrets | `nix-secrets` skill + `.opencode/rules/nix-secrets-management.md` |
| Update flake inputs | `nix-flake-ops` skill |
| Debug build/eval | `nixos-debug` skill |
| Deploy multi-host | `nixos-ops` skill |
