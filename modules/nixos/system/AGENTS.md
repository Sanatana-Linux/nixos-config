<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-07-04 -->

# modules/nixos/system/

## Purpose
Boot, systemd, networking, apps, desktop, multimedia, performance, security, users, and virtualization.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports system submodules |
| `boot.nix` | Bootloader (GRUB with Bhairava theme), kernel packages (cachyos-bore), kernel params, Plymouth splash |
| `cron.nix` | Cron job management |
| `systemd.nix` | systemd tuning — timeout reduction, coredump disabled via `settings.Coredump.Storage = "none"` |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `apps/` | Application support (nix-ld, appimage, thunar, browsers, AI, runtimes) |
| `assets/` | Boot-related assets (EFI binaries, icons) |
| `desktop/` | Desktop environments (AwesomeWM, XFCE, LightDM display manager) |
| `multimedia/` | Multimedia support |
| `networking/` | Network configuration (NetworkManager with iwd backend, Quad9 DNS, wifi) |
| `performance/` | System performance tuning (Cachy, OOMd, undervolt, zram) |
| `plymouth/` | Plymouth boot splash themes (see `plymouth/AGENTS.md`) |
| `security/` | Security modules (firewall, SSH, fail2ban, doas, sudo, PAM, TPM) |
| `users/` | Per-host user account modules (tlh, smg, user) — **import per-host only** |
| `virtualization/` | VMs and containers (Docker, LXC, virt-manager, Waydroid, Quickemu) |

## For AI Agents

### Working In This Directory
- `boot.nix` sets `boot.kernelPackages` (this project uses cachyos-bore kernel)
- Kernel params: `reboot=acpi` (ACPI reset), `nvme_core.default_ps_max_latency_us=5500` (NVMe APST), `pcie_aspm=force` (override BIOS ASPM), `intel_pstate=passive` (acpi-cpufreq for idle power), plus NVIDIA kernel params for GSP firmware and dynamic power management
- Bootloader is GRUB (not systemd-boot) with optional Bhairava GRUB theme and UEFI firmware settings boot entry
- Plymouth splash is enabled with zstd-compressed initrd

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->