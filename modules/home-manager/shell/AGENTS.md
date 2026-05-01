<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-27 -->

# modules/home-manager/shell/

## Purpose
Interactive shell configuration — zsh, starship prompt, CLI tools, and custom scripts. Environment/session modules (home vars, XDG, Nix CLI) have moved to `../environment/`.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports shell submodules |
| `cli-tools.nix` | CLI utility packages (eza, bat, ripgrep, fd, etc.) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `zsh/` | Zsh config files — aliases, completions, keybindings (see `zsh/AGENTS.md`) |
| `starship/` | Starship theme config (see `starship/AGENTS.md`) |
| `scripts/` | Custom user scripts (see `scripts/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Shell modules affect interactive user experience — test changes by logging in again
- Scripts in `scripts/` should be executable and added to PATH

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->