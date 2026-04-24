<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/home-manager/

## Purpose
Shared home-manager modules following the same enable-by-option pattern as NixOS modules. These configure user-level programs, shell, desktop preferences, and services. Imported by per-user configs in `home/<user>/default.nix`.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `desktop/` | Desktop config (awesome WM, GTK, X11) |
| `packages/` | User package sets (essential) |
| `programs/` | User programs (firefox, kitty, neovim, ghostty, yazi, fastfetch, etc.) |
| `services/` | User services (picom, xscreensaver, gnome-keyring, ssh-agent, polkit) |
| `shell/` | Shell config (zsh, starship, xdg, scripts, cli-tools) |
| `stylix/` | Home-manager stylix integration |

## For AI Agents

### Working In This Directory
- Home-manager modules use `config.home-manager.users.<name>` only within their `mkIf` block
- Never set `home-manager.users.<name>` for users not present on the current host
- Package options can be enabled conditionally: `packages = optionals cfg.<sub>.enable [ pkg ]`
- Some programs (firefox, neovim) have external config via git submodules in `external/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->