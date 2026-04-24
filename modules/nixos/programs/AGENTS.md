<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-22 | Updated: 2026-04-22 -->

# programs/

## Purpose
NixOS system-level program modules. Each program gets its own `.nix` file with an enable option under `modules.programs.<name>`. Covers programs that need system-level configuration beyond just installing a package (e.g. binfmt registration, library paths, service setup).

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports all sibling `.nix` modules via imports |
| `appimage.nix` | AppImage support with optional binfmt registration |
| `java.nix` | Java runtime with configurable `package` option (defaults to `pkgs.jre`) |
| `network-manager-applet.nix` | NetworkManager system tray applet |
| `nix-ld.nix` | nix-ld runtime linker for dynamically linked binaries; includes extensive library list (CUDA, SDL, GTK, Xorg, GStreamer, etc.) |
| `shotcut.nix` | Shotcut video editor wrapped with frei0r filter path fix |
| `thunar.nix` | Thunar file manager with plugins, thumbnail support, and GVFS |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| *(none)* | — |

## For AI Agents

### Working In This Directory
- `nix-ld.nix` has the largest library list in the repo — it provides shared libs for unpackaged binaries (CUDA, SDL, GTK, Xorg, GStreamer, audio codecs, etc.)
- `shotcut.nix` uses `symlinkJoin` + `makeWrapper` to inject the frei0r plugin path — this is the pattern for fixing programs with missing plugin paths
- `java.nix` exposes a `package` option so hosts can choose between JRE and JDK
- Adding a new program: create `<name>.nix` with `options.modules.programs.<name>.enable`, add it to `default.nix` imports

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->