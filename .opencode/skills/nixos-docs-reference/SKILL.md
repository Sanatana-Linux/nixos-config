---
name: nixos-docs-reference
description: NixOS and Nix ecosystem reference index — links and pointers into official docs (nix.dev, NixOS Manual, Nix Pills) and how they map to the ShizNix repository. From marceloeatworld/nixos-ai-skill. Use when needing authoritative NixOS/Nix reference material or a general conceptual lookup.
tags: [nix, nixos, docs, reference, nixpkgs]
license: MIT
---

# NixOS Documentation Reference

Complete reference for NixOS and the Nix ecosystem, adapted for the ShizNix repository.

## Official Sources

- [nix.dev](https://nix.dev/) — tutorials, guides, best practices
- [NixOS Manual](https://nixos.org/manual/nixos/stable/) — from `NixOS/nixpkgs`
- [Nix Pills](https://nixos.org/guides/nix-pills/) — progressive learning series
- [Search NixOS options](https://search.nixos.org/options) — verify option names (channel: nixos-unstable)
- [Search NixOS packages](https://search.nixos.org/packages) — verify package names

## How to Use

1. Identify the topic; consult the relevant ShizNix context file or skill first.
2. Distinguish between **NixOS module options** (`services.nginx.enable = true;`) and **Nix language expressions** (`pkgs.mkDerivation { ... }`).
3. Show examples using current syntax and this repo's unified-flake approach.
4. For packaging, prefer `callPackage`; in ShizNix that maps to `pkgs/<name>/default.nix` registered via the additions overlay.
5. Beginners: start with Nix Pills / nix.dev. Troubleshooting: check `nixos-debug` skill and `.opencode/rules/nixos-debug`.

## Mapping to ShizNix

| Official concept | ShizNix location |
|------------------|------------------|
| NixOS modules / options | `modules/nixos/`, `modules/home-manager/` — enable-by-option |
| Flake anatomy | `flake.nix` (unified multi-host, 16 inputs) |
| Overlays | `overlays/` (additions, modifications, cachyos-patches, stable-packages) |
| Packaging | `pkgs/<name>/default.nix` |
| Secrets | sops-nix, `external/secrets/secrets.yaml` |
| Formatter | `alejandra` |
| Dev shell | `nix develop` (flake `devShells`) |

## Repository Context

The `.opencode/context/` directory holds durable project knowledge:
- `nix-nixos-home-manager-ecosystem.md` — full repo survey of Nix features
- `nix-nixos-home-manager-official-docs.md` — official docs reference (Context7)
- `decisions.md` — Architecture Decision Records (ADRs)

## Related Skills

- **ultimate-nixos** — comprehensive ecosystem reasoning
- **nix-ecosystem-guide** — foundational concepts
- **nixos-btw** — administration
