<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-06-29 | Updated: 2026-06-29 -->

# modules/nixos/system/virtualization/

## Purpose
Virtualization and container support — Docker, LXC, libvirt/QEMU, Waydroid, and Quickemu.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports virtualization submodules |
| `docker.nix` | Docker engine and docker-compose |
| `lxc.nix` | LXC/LXD container support |
| `qemu-base.nix` | Shared virtualization base (libvirt, qemu) |
| `virt-manager.nix` | virt-manager GUI for libvirt VMs |
| `waydroid.nix` | Waydroid Android container |
| `quickemu.nix` | Quickemu VM launcher |

## Option Paths

All options are under `modules.system.virtualization.*`:

- `modules.system.virtualization.core.enable` — Core virtualization (Docker, containerd, libvirt)
- `modules.system.virtualization.docker.enable` — Docker container runtime
- `modules.system.virtualization.lxc.enable` — LXC/LXD container virtualization
- `modules.system.virtualization.virt-manager.enable` — Virtual machine management with virt-manager
- `modules.system.virtualization.waydroid.enable` — Android apps with Waydroid
- `modules.system.virtualization.quickemu.enable` — Quickemu simple QEMU wrapper

## For AI Agents

### Working In This Directory
- `core.nix` provides the base; other modules depend on it
- Docker users need to be added to the `docker` group
- Waydroid requires Wayland session and kernel binderfs support

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->