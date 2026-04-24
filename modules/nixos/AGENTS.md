<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/

## Purpose
NixOS system-level modules. Each module declares an enable option under `modules.<category>.<name>` and provides system configuration when enabled. Imported by host configs via `../../modules/nixos/<category>`.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `ai/` | AI/ML tools (ollama, comfyui) |
| `base/` | Base system config (nix, fhs, services, permitted packages) |
| `desktop/` | Desktop environment (awesomewm, LightDM/sea-greeter, XFCE, wallpapers) |
| `environment/` | System environment variables |
| `hardware/` | Hardware support (NVIDIA, Intel, bluetooth, networking, sound, tpm, udev) |
| `packages/` | System package sets |
| `performance/` | Performance tuning (cachy scheduler, oomd, undervolt, zram) |
| `power/` | Power management (laptop) |
| `printer/` | Printer drivers (Brother) |
| `programs/` | System programs (appimage, java, nix-ld, shotcut, thunar) |
| `security/` | Security (doas, sudo, firewall, fail2ban, pam, ssh) |
| `shell/` | System shell configuration and variables |
| `stylix/` | System-wide theming (colors, fonts, cursor via stylix) |
| `system/` | Boot, systemd, plymouth |
| `users/` | User account modules (tlh, smg, user) — **import per-host only** |
| `virtualization/` | VMs and containers (docker, lxc, virt-manager, waydroid, quickemu) |

## For AI Agents

### Working In This Directory
- Every module must follow the enable-by-option pattern
- `default.nix` in each category re-exports sibling `.nix` files via imports
- Hardware modules may require kernel packages — always use `config.boot.kernelPackages` (not `pkgs.linuxPackages`)
- User modules (`users/`) must **never** be imported globally — only per-host

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->