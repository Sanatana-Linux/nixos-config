<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-27 -->

# modules/nixos/

## Purpose
NixOS system-level modules. Each module declares an enable option under `modules.<category>.<name>` and provides system configuration when enabled. Imported by host configs via `../../modules/nixos/<category>`.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `base/` | Base system config (nix, fhs, services, permitted packages, shell, environment variables) |
| `hardware/` | Hardware drivers — GPU (nvidia, intel), bluetooth, keyboard, sound, thunderbolt, udev, Lenovo (lenovo, power, cooling, fan-control), devices (android, iphone, logitech, printer) |
| `packages/` | System package sets (categories + security) |
| `stylix/` | System-wide theming (colors, fonts, cursor via stylix) |
| `system/` | System services — boot, cron, systemd, networking, apps (appimage, java, nix-ld, network-manager-applet, shotcut, thunar, ai/ollama/comfyui), desktop (awesomewm, lightdm, xfce), performance (cachy, oomd, undervolt, zram), security (doas, fail2ban, firewall, pam, ssh, sudo, tpm) |
| `users/` | User account modules (tlh, smg, user) — **import per-host only** |
| `virtualization/` | VMs and containers (docker, lxc, virt-manager, waydroid, quickemu) |

## For AI Agents

### Working In This Directory
- Every module must follow the enable-by-option pattern
- `default.nix` in each category re-exports sibling `.nix` files via imports
- Hardware modules may require kernel packages — always use `config.boot.kernelPackages` (not `pkgs.linuxPackages`)
- User modules (`users/`) must **never** be imported globally — only per-host

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->