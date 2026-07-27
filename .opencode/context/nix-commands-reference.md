---
title: "Nix Commands Reference"
type: concept
tags: [nix, commands, reference, flake, nixos-rebuild]
created: 2026-07-15
updated: 2026-07-15
sources: [.documentation/nix-commands.md]
status: active
---

# Nix Commands Reference

## Flake Management

```bash
# Check flake validity
nix flake check

# Update all flake inputs
nix flake update

# Update a single input
nix flake lock --update-input nixpkgs

# Show flake outputs
nix flake show

# Show flake metadata
nix flake metadata
```

## Build and Switch

```bash
# Build toplevel (no switch)
nix build '.#nixosConfigurations.bagalamukhi.config.system.build.toplevel'

# Switch to new config
sudo nixos-rebuild switch --flake .#bagalamukhi

# Test without switching
sudo nixos-rebuild test --flake .#bagalamukhi

# Build ISO
nix build .#nixosConfigurations.chhinamasta.config.system.build.isoImage
```

## Running and Shell

```bash
# Run a flake app
nix run .#app-name

# Run a package from nixpkgs
nix run nixpkgs#python39 -- --version

# Temporary shell with packages
nix-shell -p nodejs

# Run command in nix-shell
nix-shell -p nodejs --run "node -v"

# Enter dev shell
nix develop
```

## Garbage Collection

```bash
# List store roots (find old builds)
nix-store --gc --print-roots

# Delete unused store paths
nix-collect-garbage

# Delete old boot entries too
sudo nix-collect-garbage -d

# Delete specific store path
nix store delete /nix/store/path/...
```

## Packaging

```bash
# Get SHA256 for a source
nix flake prefetch github:user/repo/rev

# Format flake
nix fmt
```
