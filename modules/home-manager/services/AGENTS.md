<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/home-manager/services/

## Purpose
User-level systemd services managed by home-manager — compositing, screen locking, keyring, and SSH agent.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports service submodules |
| `picom.nix` | Picom compositor (transparency, effects, shadows) |
| `xscreensaver.nix` | XScreenSaver screen locker |
| `gnome-keyring.nix` | GNOME Keyring daemon |
| `ssh-agent.nix` | SSH agent service |
| `polkit-agent.nix` | Polkit authentication agent |
| `poweralertd.nix` | Power alert notifications |

## For AI Agents

### Working In This Directory
- Picom conflicts with some WM compositors — only enable when not running a composited WM
- xscreensaver is X11-only; for Wayland, use swaylock or hyprlock
- SSH agent needs keys added after login: `ssh-add ~/.ssh/id_ed25519`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->