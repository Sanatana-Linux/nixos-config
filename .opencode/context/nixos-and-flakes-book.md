# NixOS & Flakes Book

> Source: https://nixos-and-flakes.thiscute.world/ | Author: Ryan Yin | License: CC BY-SA 4.0

An unofficial beginner-friendly open-source book focused exclusively on NixOS with Flakes (not traditional Nix config).

## Book Structure

| Section | Topics |
|---------|--------|
| **Preface** | Why Flakes docs are scarce, book origin story |
| **Get Started** | Nix intro, advantages/disadvantages, installation |
| **The Nix Language** | Basic syntax and concepts |
| **NixOS with Flakes** | Getting started, flake.nix explained, module system combo, home-manager, modularization, updates, tips |
| **Nixpkgs Advanced** | callPackage, overriding, overlays, multiple nixpkgs instances |
| **Nix Store & Binary Cache** | Binary cache servers, hosting your own |
| **Best Practices** | Running downloaded binaries, simplifying commands, dotfiles debugging, NIX_PATH, remote deployment, debugging derivations |
| **Other Flakes Usage** | Inputs, outputs, new CLI, module system & custom options, testing |
| **Dev Environments** | nix shell/develop, dev envs, packaging, cross-compilation, distributed builds |
| **FAQ** | Common questions |

## Key Philosophy

Nix is a **declarative package manager** — users declare desired state, Nix handles the rest. NixOS is "OS as Code" — the entire OS state is described in Nix config files.

NixOS manages **static** system state declaratively. Dynamic data (DBs, user files, `/home`) are NOT managed by NixOS rollbacks. home-manager fills the gap for user-level `/home` config.

## Core Motivations

- **Reproducibility** — one command to restore full environment on fresh hosts
- **Rollback** — restore to any previous generation
- **Multi-host** — sync config across desktops, servers, dev boards
- **Cross-arch** — same config for amd64, aarch64, riscv64

## Reference Commands

```bash
sudo nixos-rebuild switch --flake .    # build + activate
sudo nixos-rebuild boot --flake .      # build, activate on next boot
sudo nixos-rebuild build --flake .     # build only
nixos-rebuild vm --flake .            # test in VM
```
