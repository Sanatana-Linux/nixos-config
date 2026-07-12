<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# tlh

## Purpose
Primary user home-manager configuration for hosts bagalamukhi and bhairavi. Enables full desktop experience with awesome WM, Stylix theming, shell toolchain (zsh/starship/cli-tools), browser (Firefox with autoconfig), terminal (Kitty), and services (gnome-keyring, picom, xscreensaver). Disables all manual formats in favor of tealdeer and online references.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Home-manager config enabling stylix, essential packages, full shell suite (home/environment/zsh/starship/cli-tools/nix/xdg/scripts), awesome desktop, 8 programs (fastfetch, firefox+autoconfig, kitty, gpg, zathura, yazi, vesktop, neovim), gnome-keyring with 3 components, picom, xscreensaver. Uses sd-switch for systemd service starts. stateVersion "24.11". |

## For AI Agents

### Working In This Directory
- User modules are imported by host configs — each host only imports the users it needs. Located at `modules/home-manager/users/tlh/`.
- Enable-by-option pattern: modules are toggled with `modules.<cat>.<name>.enable = true`
- stateVersion should never change after first install

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->