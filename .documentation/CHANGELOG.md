# NixOS Configuration Changelog

This document tracks changes to the NixOS configuration in this repository.

## Format

Each entry follows this format:
- **YYYY-MM-DD**: Brief description of the change

---

## Changes

- **2026-03-06**: Restored pre-refactor packages to current module-based configuration
  - Added Android/APK development tools to `devtools.nix` (abootimg, android-tools, apkeep, apksigner, apktool, bundletool, dex2jar, simg2img) under new `androidDevelopment` option
  - Added Nix utilities to `devtools.nix` (manix, nix-index, nixos-generators) under new `nixUtilities` option (enabled by default)
  - Added system compilers to `devtools.nix` (clang, gcc-unwrapped, patchelf) under new `systemCompilers` option
  - Added system utilities to `system.nix` (acpi, binutils, file, iw, pciutils, usbmuxd, usbutils, whois, wirelesstools, yad, zip)
  - Added shell tools to `shell.nix`:
    - Modern tools: btop, silver-searcher (ag)
    - System utilities: beep, clipster, jdupes
    - File management: deer, ranger, tree
    - Download tools: aria2 (renamed from aria), rclone, speedtest-cli (under new `downloadTools` option)
    - ZSH plugins: pure-prompt, zsh-autocomplete, zsh-edit, zsh-navigation-tools, zsh-you-should-use (under new `zshPlugins` option)
  - Added window management utilities to `gui.nix` (maim, picom, wmctrl) under new `windowManagement` option
  - Added image tools to `multimedia.nix` (ascii-image-converter, jp2a, pngquant)
  - Added video editor to `multimedia.nix` (openshot-qt)
  - Note: `sysz` (systemd service manager) was already present in `system.nix` - no changes needed
  - Updated `AGENTS.md` with changelog documentation guidelines
  - **Fix**: Added `qtwebengine-5.15.19` to `nixpkgs.config.permittedInsecurePackages` in `modules/nixos/hardware/nvidia.nix` to resolve build errors
  - **Fix**: Enabled `system.performance`, `system.desktop`, `system.hardware`, `system.filesystem`, and `system.multimedia` sub-options in `hosts/bagalamukhi/default.nix` to ensure all system packages including sysz are available


