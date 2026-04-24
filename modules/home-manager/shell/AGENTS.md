<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/home-manager/shell/

## Purpose
Shell and CLI environment configuration — zsh, starship prompt, XDG directories, environment variables, and custom scripts.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports shell submodules |
| `zsh.nix` | Zsh configuration (aliases, keybindings — not here, see `zsh/` dir) |
| `starship.nix` | Starship prompt configuration |
| `xdg.nix` | XDG user directories and default applications |
| `cli-tools.nix` | CLI utility packages (eza, bat, ripgrep, fd, etc.) |
| `nix.nix` | Nix CLI configuration for the user |
| `home.nix` | Home-manager session variables |
| `environment.nix` | Environment variables and PATH entries |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `zsh/` | Zsh config files (aliases, completions, keybindings) |
| `starship/` | Starship theme config |
| `scripts/` | Custom user scripts |

## For AI Agents

### Working In This Directory
- Shell modules affect interactive user experience — test changes by logging in again
- XDG directories must be consistent between home-manager and NixOS-level settings
- Scripts in `scripts/` should be executable and added to PATH

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->