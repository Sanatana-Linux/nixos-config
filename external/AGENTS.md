<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# external

## Purpose
Git submodules for external configurations managed outside the NixOS flake. Each submodule is linked into the target application's config directory via `mkOutOfStoreSymlink` or activation scripts.

## Key Files

| File | Description |
|------|-------------|
| `awesome/` | Awesome WM config (see `awesome/AGENTS.md`) |
| `nvim/` | Neovim config (see `nvim/AGENTS.md`) |
| `firefox/` | Firefox theme/userChrome (see `firefox/AGENTS.md`) |
| `base16_monokai_pro/` | Base16 Monokai Pro Spectrum color scheme |
| `README.md` | Submodule documentation |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `awesome/` | Awesome WM config — symlinked to `~/.config/awesome` (see `awesome/AGENTS.md`) |
| `nvim/` | Neovim config — symlinked to `~/.config/nvim` (see `nvim/AGENTS.md`) |
| `firefox/` | Firefox userChrome theme — symlinked to profile's `chrome/` dir (see `firefox/AGENTS.md`) |
| `base16_monokai_pro/` | Base16 color scheme for Stylix |

## For AI Agents

### Working In This Directory
- These are git submodules — update with `git submodule update --remote`
- External configs are linked via `mkOutOfStoreSymlink`, not copied
- Do not inline external config into Nix modules — the submodule IS the config
- Changes to submodule content should be committed within the submodule's own repo

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->