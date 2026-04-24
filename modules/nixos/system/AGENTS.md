<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/system/

## Purpose
Boot, systemd, and plymouth (boot splash) configuration.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports system submodules |
| `boot.nix` | Bootloader (systemd-boot), kernel packages, kernel params |
| `systemd.nix` | Custom systemd configuration |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `plymouth/` | Plymouth boot splash themes |
| `assets/` | Boot-related assets |

## For AI Agents

### Working In This Directory
- `boot.nix` sets `boot.kernelPackages` (this project uses xanmod)
- Kernel params for performance: `mitigations=off`, `preempt=full`
- systemd-boot is the bootloader (not GRUB)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->