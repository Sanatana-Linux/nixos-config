<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# smg

## Purpose
Secondary user home-manager configuration for host matangi. Runs XFCE desktop with Stylix explicitly disabled, reduced program set (firefox, yazi, kitty, neovim), and custom picom settings (no shadows, rounded-corners/blur excludes for dock/desktop/GTK frames). Includes polkit-agent service. Explicitly imports shared home-manager modules and force-installs kitty via both home.packages and programs.kitty.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Home-manager config enabling essential packages, full shell suite (home/environment/zsh/starship/cli-tools/nix/xdg/scripts), desktop without Stylix, 4 programs (firefox, kitty, yazi, neovim), picom with custom shadow/blur excludes, xscreensaver, polkit-agent. Custom picom.settings override shadows to false. stateVersion "24.11". |

## For AI Agents

### Working In This Directory
- User modules are imported by host configs — each host only imports the users it needs. Located at `modules/home-manager/users/smg/`.
- Enable-by-option pattern: modules are toggled with `modules.<cat>.<name>.enable = true`
- stateVersion should never change after first install

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->