<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-27 | Updated: 2026-04-27 -->

# legion-rgb-control

## Purpose
Rust application for controlling the 4-zone RGB keyboard lighting on 2020–2023 Lenovo Legion laptops. Fetched from GitHub (4JX/L5P-Keyboard-RGB v0.19.6), it uses `cargo make build-release` for compilation and depends on X11, GStreamer, libusb1, dbus, udev, libvpx, and other system libraries. Licensed GPL3.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Rust crate derivation via `rustPlatform.buildRustPackage` — includes a vendored `Cargo.lock` with 4 patched dependency hashes, uses `cargo-make` for the build phase, and requires bindgen/pkg-config for native C library linking. |
| `Cargo.lock` | Vendored Cargo lockfile with output hashes for confy, hbb_common, photon-rs, and tokio-socks crates. |

## For AI Agents

### Working In This Directory
- Custom packages defined here are exposed via `pkgs/` in flake outputs
- Use overlays for patches/overrides to existing packages, not pkgs/
- The `Cargo.lock` must be updated alongside `default.nix` when upgrading the package version

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->