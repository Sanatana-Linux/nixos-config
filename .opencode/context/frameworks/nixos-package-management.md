---
title: "NixOS Package Management"
type: concept
tags: [packages, searching, installing, nixpkgs, nix-search]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/searching-and-installing-packages.md]
status: active
---

# NixOS Package Management

## Core Concept

NixOS manages packages **declaratively** — packages are listed in configuration files and applied via `nixos-rebuild switch`. This differs from imperative package managers (apt, pacman) where packages are installed at runtime from the terminal.

Packages that are used temporarily or experimentally can be installed imperatively, but regularly-used packages should be added to the NixOS configuration for proper management.

## Searching for Packages

| Method | Command / Location |
|--------|-------------------|
| **CLI search** | `om search <package-name>` (wraps `nix search nixpkgs`) |
| **Web search** | [search.nixos.org/packages](https://search.nixos.org/packages) (set channel to "unstable") |
| **NUR** | [nur.nix-community.org](https://nur.nix-community.org/) — community packages |
| **GitHub** | Search [nixpkgs](https://github.com/NixOS/nixpkgs) directly for edge cases |

### CLI Search Options

```bash
# Basic search
om search <package-name>

# Search within a category
om search #gnome3 vala

# OR search
om search "package1 | package2"

# AND/OR combined
om search "git 'frontend | gui'"

# Exclude terms
om search "neovim --exclude 'python | gui'"
```

## Installing Imperatively (Temporarily)

| Method | Lifespan |
|--------|----------|
| `nix-shell -p <pkg>` | Terminal session only |
| `nix-env -iA nixos.<pkg>` | Until garbage collection |
| `nix profile install <pkg>` | Until explicitly removed |

> **Important**: If you find yourself relying on a temporarily-installed package, let the maintainer know so it can be added to the configuration permanently (which also enables configuration options).

## Declarative Installation

For permanent installation, add to the host config or appropriate module:

```nix
# Host config
environment.systemPackages = with pkgs; [ package-name ];

# Or enable a package module
modules.packages.development.enable = true;
```

The configuration categorizes packages by function (development, multimedia, network, GUI, etc.) under `modules/packages/` with nested enable options.
