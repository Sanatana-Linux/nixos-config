<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# user

## Purpose
Generic user home-manager configuration for host chhinamasta (live USB ISO). Nearly identical to tlh's config — full awesome WM desktop with Stylix theming, shell toolchain, Firefox+autoconfig, Kitty, and standard services. Uses username "user" with homeDirectory "/home/user". Designed as the live-session user with full desktop capabilities.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Home-manager config enabling stylix, essential packages, full shell suite (home/environment/zsh/starship/cli-tools/nix/xdg/scripts), awesome desktop, 8 programs (fastfetch, firefox+autoconfig, kitty, gpg, zathura, yazi, vesktop, neovim), gnome-keyring with 3 components, picom, xscreensaver. Uses sd-switch for systemd service starts. stateVersion "24.11". |

## For AI Agents

### Working In This Directory
- User modules are imported by host configs — each host only imports the users it needs
- Enable-by-option pattern: modules are toggled with `modules.<cat>.<name>.enable = true`
- stateVersion should never change after first install

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->