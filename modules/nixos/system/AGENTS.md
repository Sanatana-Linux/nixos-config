<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-06-09 -->

# modules/nixos/system/

## Purpose
Boot, systemd, networking, apps, desktop, multimedia, performance, runtimes, security, and virtualization.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports system submodules |
| `boot.nix` | Bootloader (systemd-boot), kernel packages, kernel params |
| `cron.nix` | Cron job management |
| `systemd.nix` | systemd tuning — timeout reduction, coredump disabled via `settings.Coredump.Storage = "none"` |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `apps/` | Application support (nix-ld, appimage, thunar, browsers, AI) |
| `assets/` | Boot-related assets (EFI binaries, icons) |
| `desktop/` | Desktop environments (AwesomeWM, XFCE, LightDM display manager) |
| `multimedia/` | Multimedia support |
| `networking/` | Network configuration (NetworkManager with iwd backend, Quad9 DNS, wifi) |
| `performance/` | System performance tuning (Cachy, OOMd, undervolt, zram) |
| `plymouth/` | Plymouth boot splash themes (see `plymouth/AGENTS.md`) |
| `runtimes/` | Language runtimes |
| `security/` | Security modules (firewall, SSH, fail2ban, doas, sudo, PAM, TPM) |
| `virtualization/` | VMs and containers (Docker, LXC, virt-manager, Waydroid, Quickemu) |

## For AI Agents

### Working In This Directory
- `boot.nix` sets `boot.kernelPackages` (this project uses xanmod)
- Kernel params for performance: `mitigations=off`, `preempt=full`
- systemd-boot is the bootloader (not GRUB)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->