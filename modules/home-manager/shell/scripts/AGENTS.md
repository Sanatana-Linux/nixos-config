<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# scripts/

## Purpose
Custom shell scripts packaged as Nix derivations and added to the user's PATH via home-manager. Each script is defined as a `writeScriptBin` derivation in its own `.nix` file, imported and aggregated by `default.nix`.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Module entry — imports all scripts, adds them to `home.packages` when `modules.shell.scripts.enable = true` |
| `om.nix` | `om` — NixOS administration wrapper (rebuild, clean, sync, search, build-iso, build-qcow, etc.) |
| `gita.nix` | `gita` — Quick git add/commit/push with timestamped message |
| `nixfetch.nix` | `nixfetch` — NixOS system info display (OS, kernel, DE/WM, package count) with Nix logo |
| `mountbox.nix` | `mountbox` — Mount Dropbox and Google Drive remotes via rclone |
| `iso-open.nix` | `iso-open` — Mount and extract ISO file contents to local directory |
| `icon-viewer.nix` | `icon-viewer` — Icon font viewer (generate MD/HTML reference, rofi search, clipboard copy) |
| `panes.nix` | `panes` — Terminal color palette display (8-color ANSI swatch) |
| `shrooms.nix` | `shrooms` — Colorful mushroom ASCII art terminal banner |
| `nixpkgs.sh` | `ns` — Nixpkgs search script (sourced via `readFile`) |

## For AI Agents

### Working In This Directory
- Each script gets its own `.nix` file using `pkgs.writeScriptBin "name" ''script''`
- Scripts are imported in `default.nix` with `{inherit pkgs;}` — no lib/config needed
- To add a new script: create `new-script.nix`, import it in `default.nix`, add to `home.packages` list
- The `ns` script is the only one sourced from a raw `.sh` file via `builtins.readFile`
- `om` is the primary NixOS management script — changes here affect all admin workflows

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->