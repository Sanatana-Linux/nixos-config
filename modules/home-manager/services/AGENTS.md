<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-07-04 -->

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
- Picom uses GLX backend (not EGL) — NVIDIA's GLX driver has proper GPU power state management (allows P8 at idle), while EGL pins clocks at P0 (~30W)
- vsync is disabled — PRIME sync already handles tear-free output at the hardware level; picom vsync + NVIDIA vblank duplicate bug doubles compositing work and keeps the dGPU pinned at P0
- Blur uses `dual_kawase` with strength 4 (balanced quality/performance); awesomewm handles corner rounding natively
- Picom conflicts with some WM compositors — only enable when not running a composited WM
- xscreensaver is X11-only; for Wayland, use swaylock or hyprlock
- SSH agent needs keys added after login: `ssh-add ~/.ssh/id_ed25519`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->