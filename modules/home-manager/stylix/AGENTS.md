<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# stylix/

## Purpose
Home-manager level Stylix theming integration. Enables Stylix with `autoEnable = true` and configures per-target overrides: terminal color8 fix for readability (kitty, ghostty, xresources), enables CLI tool targets (bat, fzf, tmux, vivid), enables GUI targets (nixcord, feh, sioyek, zathura, opencode), and disables targets that conflict with external configs or custom setup (GTK, neovim, firefox, yazi).

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Stylix enable option, per-target enable/disable/override config |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- `stylix.autoEnable = true` means all supported targets get themed by default — the module explicitly disables conflicting ones
- GTK is disabled (`targets.gtk.enable = false`) because `desktop/gtk.nix` uses `mkForce` for custom theming
- Neovim, Firefox, and Yazi are disabled because they use external config submodules
- The `color8` override (`#8b888f`) brightens the black color for terminal readability — this is applied to kitty, ghostty, and xresources
- System-level Stylix is configured in `modules/nixos/stylix/` — this module handles only home-manager targets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->