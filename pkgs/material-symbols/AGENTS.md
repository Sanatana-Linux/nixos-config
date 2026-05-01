<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# material-symbols

## Purpose
Google Material Symbols variable icon fonts (TTF + WOFF2) packaged for NixOS. Uses a sparse checkout of the `variablefont` directory from google/material-design-icons on GitHub, renames axes descriptors out of filenames, and installs fonts to standard font directories. Licensed ASL-2.0.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | No-compiler derivation via `stdenvNoCC.mkDerivation` — sparse-checks out `variablefont/` from GitHub, uses `util-linux.rename` to strip `[FILL,GRAD,opsz,wght]` from filenames, installs TTF and WOFF2 files. Version pinned to unstable-2023-01-07 by commit hash. |

## For AI Agents

### Working In This Directory
- Custom packages defined here are exposed via `pkgs/` in flake outputs
- Use overlays for patches/overrides to existing packages, not pkgs/
- To update icons, change the `rev` and `sha256` in `default.nix` to a newer commit

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->