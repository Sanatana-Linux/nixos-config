<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# modules/nixos/system/apps/

## Purpose
System-level application modules. Each module declares an enable option under `modules.system.apps.<name>` and provides system configuration when enabled.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports apps submodules |
| `appimage.nix` | AppImage support (appimage-run wrapper) |
| `java.nix` | Java runtime (JDK, OpenGL compatibility) |
| `nix-ld.nix` | Nix-ld FHS compatibility for running non-Nix binaries |
| `network-manager-applet.nix` | NetworkManager tray applet |
| `shotcut.nix` | Shotcut video editor |
| `thunar.nix` | Thunar file manager (with bulk rename, archive support) |

## For AI Agents

### Working In This Directory
- Every module uses `options.modules.system.apps.<name>.enable` guarded by `mkIf`
- `nix-ld.nix` here provides the app-level nix-ld wrapper (separate from `modules.nixos.base.fhs` which enables the base FHS compatibility)
- `java.nix` sets `programs.java.enable` and configures OpenGL fallbacks

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->