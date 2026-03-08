# NixOS Configuration Changelog

This document tracks changes to the NixOS configuration in this repository.

## Format

Each entry follows this format:
- **YYYY-MM-DD**: Brief description of the change

---

## Changes

- **2026-03-07**: Created centralized permitted insecure packages module for both hosts
  - Created `modules/nixos/base/permitted-packages.nix` with enable option and extensible packages list
  - Configured `qtwebengine-5.15.19` as permitted insecure package (required by Qt-based applications)
  - Module sets both `allowUnfree = true` and `permittedInsecurePackages` to ensure proper nixpkgs.config merging
  - Enabled on both matangi and bagalamukhi via `modules.base.permittedPackages.enable = true`
  - Removed duplicate `allowUnfree` from matangi/default.nix (now managed by module)
  - Removed duplicate `permittedInsecurePackages` from nvidia.nix (now centrally managed)
  - Verified evaluation: both hosts properly merge all nixpkgs.config attributes across modules
  - Additional insecure packages can be added via `modules.base.permittedPackages.packages = ["package-name"];`

- **2026-03-07**: Enhanced AGENTS.md with comprehensive module and workflow guidelines
  - Added "Host-Specific Information" section with primary users for each host (bagalamukhi/tlh, matangi/smg, chhinamasta/user)
  - Added "Module Structure and Organization" section documenting the "activate by enable option" paradigm
  - Documented all module categories under `modules/nixos/` (ai, base, desktop, environment, hardware, packages, performance, power, printer, programs, security, services, shell, system, users, virtualization)
  - Documented all module categories under `modules/home-manager/` (desktop, packages, programs, services, shell)
  - Added module template showing required `mkEnableOption` and `mkIf` pattern
  - Added module import rules requiring `default.nix` in each category directory
  - Enhanced changelog management section with reminder to use today's date (Sat Mar 07 2026) and update immediately after changes

- **2026-03-07**: Created iPhone/iOS device access module
  - Created `modules/nixos/hardware/iphone.nix` for iOS device USB access
  - Added packages: libimobiledevice, ifuse, ideviceinstaller, usbmuxd
  - Enabled services.usbmuxd for iOS device communication
  - Created plugdev group for device access (smg user automatically added via ifTheyExist)
  - Enabled iPhone module on matangi/smg configuration

- **2026-03-06**: Fixed kernel 6.19 build failure caused by VFIO_VIRQFD dependency conflict
  - Removed explicit `VFIO_VIRQFD = module` setting from `modules/nixos/hardware/intel.nix:109`
  - Kernel 6.19 changed VFIO_VIRQFD dependencies, making it incompatible as a module
  - Now auto-configured by kernel build system based on parent option dependencies
  - Resolves error: "option not set correctly: VFIO_VIRQFD (wanted 'm', got 'y')"

- **2026-03-06**: Created dedicated TPM 2.0 module and removed redundancy
  - Created `modules/nixos/hardware/tpm.nix` with comprehensive TPM 2.0 support
  - Added options: `enable`, `enableAbrmd` (default: false), `enableTctiEnvironment` (default: true), `enablePkcs11` (default: true), `initrdSupport` (default: true)
  - Configuration includes: security.tpm2 settings, boot.initrd.kernelModules for TPM, and TPM-related packages (libtpms, tpm2-pytss, ssh-tpm-agent, swtpm, tpm2-abrmd, tpm2-tools, tpm2-tss, tpmmanager)
  - Removed redundant TPM configuration from `modules/nixos/security/doas.nix` (security.tpm2 block and 8 TPM packages)
  - Enabled TPM module on bagalamukhi only (TPM 2.0 hardware present)
  - Verified: tpm2-abrmd.service running, TPM 2.0 detected (Intel INTC, revision 1.38)

- **2026-03-06**: Enhanced bluetooth module with comprehensive reconnection settings
  - Restructured `modules/nixos/hardware/bluetooth.nix` with improved configuration options
  - Added `powerOnBoot` option (default: true) to power on Bluetooth adapter on boot
  - Added `fastConnectable` option (default: true) for quicker device connections
  - Added `autoEnable` option (default: true) to automatically enable Bluetooth adapter
  - Added `reconnectAttempts` option (default: 7) for number of reconnection attempts
  - Added `reconnectIntervals` option (default: "1,2,3,4,8") for reconnection timing pattern
  - Changed `experimentalFeatures` default from true to false for stability
  - Removed simple `autoConnect` option in favor of comprehensive Policy settings
  - Enabled bluetooth on matangi host (was already enabled on bagalamukhi)
  - Configuration now includes General.FastConnectable and Policy (ReconnectAttempts, ReconnectIntervals, AutoEnable)

- **2026-03-06**: Added fail2ban security module and refactored SSH keyring configuration
  - Created `modules/nixos/security/fail2ban.nix` module with activate-by-enable-option pattern
  - Added configurable options: `maxRetry` (default: 5), `banTime` (default: 1h), `findTime` (default: 10m), `enableSSH` (default: true)
  - Enabled fail2ban on both bagalamukhi and matangi hosts
  - Created `modules/home-manager/services/gnome-keyring.nix` module to split SSH agent configuration
  - Added `enableSSH` option to gnome-keyring module for per-user SSH agent control
  - Enabled SSH agent (gnome-keyring) for tlh user on bagalamukhi
  - Disabled SSH agent (gnome-keyring) for smg user on matangi
  - Fixed throttled service configuration by adding mandatory `[GENERAL]`, `[BATTERY]`, and `[AC]` sections with `Update_Rate_s` parameters

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


