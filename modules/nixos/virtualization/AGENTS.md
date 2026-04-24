<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/virtualization/

## Purpose
Virtualization and container support — Docker, LXC, libvirt/QEMU, Waydroid, and Quickemu.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports virtualization submodules |
| `core.nix` | Shared virtualization base (libvirt, qemu) |
| `docker.nix` | Docker engine and docker-compose |
| `lxc.nix` | LXC/LXD container support |
| `virt-manager.nix` | virt-manager GUI for libvirt VMs |
| `waydroid.nix` | Waydroid Android container |
| `quickemu.nix` | Quickemu VM launcher |

## For AI Agents

### Working In This Directory
- `core.nix` provides the base; other modules depend on it
- Docker users need to be added to the `docker` group
- Waydroid requires Wayland session and kernel binderfs support

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->