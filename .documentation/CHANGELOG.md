# NixOS Configuration Changelog

This document tracks changes to the NixOS configuration in this repository.

## Format

Each entry follows this format:
- **YYYY-MM-DD**: Brief description of the change

---

## Changes

- **2026-03-09**: Wrap OpenRGB package to force XCB backend on X11
  - Modified `modules/nixos/hardware/openrgb.nix` to wrap the `openrgb` binary
  - Sets `QT_QPA_PLATFORM=xcb` environment variable in the wrapper
  - Fixes crash/error where Qt attempts to use Wayland backend on X11 systems
  - Wrapped package `openrgb-wrapped` is used in `environment.systemPackages` and `services.hardware.openrgb`
  - Added `meta.mainProgram = "openrgb"` to fix `getExe` warning
  - Added `QT_QPA_PLATFORM=xcb` to `modules/nixos/desktop/awesomewm.nix` for system-wide X11 enforcement when using AwesomeWM
  - Added `QT_QPA_PLATFORM=xcb` and `GDK_BACKEND=x11` to `modules/nixos/desktop/xfce.nix` for consistent X11 backend usage in XFCE environment

- **2026-03-08**: Update NVIDIA configuration for Bagalamukhi
  - Enabled `forceFullCompositionPipeline = true` in `modules/nixos/hardware/nvidia.nix`
  - Enabled `dynamicBoost.enable = true`
  - Confirmed `modesetting.enable` and `package` settings are correct
  - Note: This change modifies the shared NVIDIA module; users should verify compatibility before rebuilding other hosts (Matangi)

- **2026-03-08**: Fix `node2nix` build failure — add `nodejs` to `nativeBuildInputs`
  - `node2nix-1.11.0` in nixpkgs-unstable fails to build in the Nix sandbox because `npm` is not available (nixpkgs bug: `nodejs` missing from outer derivation's `nativeBuildInputs`)
  - Added `node2nix` override in `modifications` overlay (`overlays/default.nix`) to append `nodejs` to `nativeBuildInputs`

- **2026-03-08**: Override `lenovo-legion-module` kernel module to use fork with Legion 5 16IRX9 83DG support
  - Added overlay in `modifications` (overlays/default.nix) that extends `linuxPackages_latest` to replace `lenovo-legion-module` src with fork `jlbyh2o/LenovoLegionLinux@4cc42952` (branch: `add-legion-5-16irx9-83dg-nmcn`)
  - The fork adds the Legion 5 16IRX9 83DG (NMCN BIOS) to the driver allowlist, enabling the `lenovo_legion` kernel module on both bagalamukhi and matangi

- **2026-03-08**: Remove redundant local gnome-keyring home-manager wrapper module
  - Deleted `modules/home-manager/services/gnome-keyring.nix` — thin wrapper over upstream `services.gnome-keyring` that provided no added value and caused confusion (missing `enableSSH` option was added expecting the wrapper to handle it)
  - Removed from `modules/home-manager/services/default.nix` imports
  - `home/tlh` and `home/smg`: removed `modules.services.gnome-keyring` block; gnome-keyring is now managed directly via `services.gnome-keyring` in the host's NixOS module (already present in system config)
  - `home/user` already used `services.gnome-keyring` directly — no change needed

- **2026-03-08**: Overlay cleanup and synchronization across host and home-manager configs
  - Removed unused overlays: `master-packages`, `f2k-packages`, `chaotic-packages` from `overlays/default.nix`
  - Removed unused flake inputs: `master` (nixpkgs/master), `nixpkgs-f2k`, `antigravity-nix`
  - Removed `fortuneteller2k.cachix.org` substituter and trusted public key (no longer needed without nixpkgs-f2k)
  - Removed duplicate `nix-community.cachix.org` trusted public key entry
  - Host configs (bagalamukhi, matangi): now apply `additions`, `modifications`, `stable-packages`, `inputs.nur.overlays.default`
  - Home configs (tlh, smg, user): now apply `additions`, `modifications`, `stable-packages`, `inputs.nur.overlays.default`
  - All host and home overlay sets are now consistent; `chhinamasta` ISO remains overlay-free intentionally
  - Note: `chaotic` is still used via `inputs.chaotic.nixosModules.default` for binary cache infrastructure (not as an overlay)

- **2026-03-08**: Package sub-options no longer default enabled
  - Removed `default = true` from all package module sub-options in `packages.nix`
  - Host configs now explicitly enable each package sub-option they need
  - Updated bagalamukhi with full package sub-option enablements
  - Updated matangi with full package sub-option enablements
  - Updated chhinamasta (live ISO) with minimal sub-options (fonts, network basics, shell basics)
  - Added `ventoy-1.1.10` to permitted insecure packages
  - Fixed garbage terminal output pasted into awesomewm.nix

- **2026-03-08**: Moved host-specific packages to appropriate modules
  - Added `grub2` to `boot.nix` module
  - Added `i2c-tools` to `openrgb.nix` module
  - Added `peakperf` to `performance/default.nix` module
  - Added `xssproxy` to `awesomewm.nix` module (ldbus already present)
  - Removed duplicate `intel-media-driver` from `nvidia.nix` (already in `intel.nix`)
  - Consolidated `pathsToLink` in `environment/default.nix` (added /share/applications, /share/xdg-desktop-portal)
  - Cleaned up bagalamukhi and matangi host configs - removed all packages now provided by modules
  - Cleaned up nvidia.nix - removed useless `gamingOptimizations` option, nested CUDA under `.cuda.enable`, PRIME under `.prime.*`

- **2026-03-08**: Consolidated kernel and networking configuration into proper modules
  - Created `modules/nixos/system/kernel.nix` with `lenovo-legion.enable` profile option
  - Lenovo Legion profile includes shared kernel params, modules, extraModulePackages for both bagalamukhi and matangi
  - Updated `modules/nixos/hardware/networking.nix` with `hostName` option and firewall/wifi sub-options
  - Refactored bagalamukhi and matangi host configs to use new module options instead of inline configuration
  - Removed duplicate timezone/base settings from host configs (defaults in modules)
  - Fixed duplicate `tcp_fastopen` sysctl definition (kept in doas.nix, removed from networking.nix)
  - Fixed deprecated packages: neofetch→fastfetch, python312Full→python312, removed pandoc-cli, tree-sitter-jsonc, xorg.rgb, helvum
  - Fixed missing `unstable-packages` overlay reference in home configs (changed to `stable-packages`)
  - Live ISO (chhinamasta) unaffected - does not enable lenovo-legion profile

- **2026-03-08**: Consolidated all package modules into single unified packages.nix
  - Merged 12 separate package modules (archives, core, development, devtools, fonts, gui, guilibs, multimedia, network, python, shell, system) into `modules/nixos/packages/packages.nix`
  - Implemented nested category structure under `modules.packages.*` with sensible groupings
  - Merged redundant `development.nix` into `devtools` structure, renamed to `development`
  - Moved `guilibs` under `gui.libs.*` for better organization
  - Fixed misplaced packages in multimedia.creators:
    - `beautysh` → development.linters
    - `gi-docgen`, `gibo` → development.webDevelopment
    - `gsettings-desktop-schemas`, `gnome.nixos-gsettings-overrides`, `pantheon.granite` → gui.libs.desktopIntegration
    - `libdrm`, `libgee`, `libplacebo`, `libtheora`, `libvpl`, `libwebcam`, `lv2` → multimedia.videoTools / gui.libs
    - `p7zip`, `lrzip` → archives.specializedFormats
    - `imgpatchtools`, `lsix`, `redoflacs` → multimedia.imageTools
    - `pygobject3` → gui.libs.pythonBindings
  - Preserved fonts.fontconfig settings critical for font cache functionality
  - Maintained minimal presets for live ISO (chhinamasta)
  - Updated all host configurations to use new nested option structure
  - Removed old individual module files

- **2026-03-08**: Refactored multimedia module to use feature-based options instead of host checking
  - Modified `modules/nixos/packages/multimedia.nix` to use `stableVideoEditors` option instead of checking `config.networking.hostName`
  - Removed `isMatangi` and `isBagalamukhi` local variables from the module to align with "activate by enable option" paradigm
  - Enabled `stableVideoEditors = true;` in `hosts/matangi/default.nix` to maintain existing functionality
  - This change allows seamless integration of these stable video editing packages into future host configurations

- **2026-03-08**: Cleaned up patches and removed android translation layer
  - Removed `android-translation-layer-fixes.nix` overlay and associated patches
  - Removed unused patches: `fix-bionic-arm64-tls*.patch` and `wolfssl-disable-tests.patch`
  - Moved needed `olive-editor-qt610-fix.patch` directly to `modules/nixos/packages/` where it's conceptually required
  - Updated `overlays/default.nix` to reference the new patch location
  - Removed the now-empty top-level `patches` directory

- **2026-03-08**: Refactored assets directories to be colocated with their respective modules
  - Removed redundant `assets` directory from the repository root
  - Moved EFI files from `assets/bios/` to `modules/nixos/system/assets/`
  - Updated EFI file references in `modules/nixos/system/boot.nix`
  - Moved wallpapers from `assets/wallpaper/` to `modules/nixos/desktop/assets/`
  - Updated wallpaper references in `modules/nixos/desktop/xorg.nix`
  - Kept `.assets` directory as it contains hidden installation and setup scripts

- **2026-03-07**: Reorganized documentation with comprehensive sops-nix guide and restored post-installation steps
  - Created `.documentation/sops-nix-guide.md` - comprehensive guide to secrets management with sops-nix
  - Covers: how sops-nix works, key types (PGP/age), .sops.yaml structure, repository layout, NixOS integration
  - Documents workflows: editing secrets, adding secrets, adding new hosts, user environment variables
  - Includes security considerations, best practices, common pitfalls, and troubleshooting
  - Updated `.documentation/quickstart.md` with restored post-installation steps from installation-not-encrypted.md
  - Added: set ownership/git config, initialize own git repo, apply configuration changes
  - Reorganized secrets section with "First Time Secrets Setup" and "Adding New Host to Existing Secrets Repository" subheaders
  - Links to comprehensive sops-nix-guide.md for detailed information
  - Removed `.assets/SECRETS_BOOTSTRAP_DESIGN.md` (converted to proper documentation)

- **2026-03-07**: CRITICAL: Reverted NVIDIA configuration to PRIME sync mode
  - Changed `modules/nixos/hardware/nvidia.nix` back to PRIME sync mode (offload.enable = false, sync.enable = true)
  - Removed forceFullCompositionPipeline setting that was causing display issues
  - Added "Hardware-Specific Rules" section to AGENTS.md with NVIDIA configuration warning
  - **CRITICAL WARNING**: NEVER switch NVIDIA PRIME mode to offload - causes screen flashing, tearing, and compositor instability on both bagalamukhi and matangi

- **2026-03-07**: Enhanced AGENTS.md with documentation management guidelines
  - Added comprehensive "Documentation Management" section to AGENTS.md
  - Renamed "Changelog Management" to subsection under "Documentation Management"
  - Added "Documentation File Updates" guidelines: when to update existing docs, create new docs, or remove outdated docs
  - Specified criteria for creating new documentation (installation workflows, significant features, complex patterns, troubleshooting)
  - Specified criteria for updating existing documentation (module changes, installation changes, new commands, structure changes)
  - Specified what NOT to document (minor internal changes, simple bug fixes, routine package updates)

- **2026-03-07**: Created installation quickstart documentation
  - Created `.documentation/quickstart.md` with single-command installation workflow from live ISO
  - Documented complete post-installation secrets management setup with direct commands (no wrapper scripts)
  - Includes: nix-shell environment setup, curl command to download install.sh from GitHub, step-by-step sops configuration
  - Documented both sops-nix secrets management and GPG-encrypted .env alternatives
  - Included troubleshooting section for common installation and secrets issues
  - Added quick reference commands for daily workflow
  - Removed redundant installation documentation files (installation-with-encryption.md, installation-not-encrypted.md)
  - Updated README.md to link only to quickstart, encrypted-root, and live-usb docs

- **2026-03-07**: CRITICAL FIX - Removed redundant unstable flake input and fixed NVIDIA hybrid graphics issues
  - **Flake input cleanup**:
    - Removed redundant `unstable` flake input (line 7) - nixpkgs is already nixos-unstable
    - Removed `nixpkgs-unstable` input that pointed to master (nonsensical duplication)
    - Default nixpkgs IS unstable, no need for separate pkgs.unstable namespace
    - Removed `unstable-packages` overlay from overlays/default.nix
    - Updated both host configs to remove unstable-packages overlay reference
    - Kept stable and master overlays for specific package needs
  - **Video editor packages corrected**:
    - Fixed olive-editor to use `pkgs.stable.olive-editor` (not pkgs.unstable)
    - Stable versions provide better reliability for long video editing sessions
    - All matangi video packages (olive, shotcut, openshot) now use stable
  - **NVIDIA hybrid graphics fixes** (affects both bagalamukhi and matangi with Intel + NVIDIA 4070):
    - **Changed PRIME mode from sync to offload** - sync forces all rendering through NVIDIA causing compositor issues
    - **Removed forceFullCompositionPipeline** - this was causing flashing windows and context menus in GIMP and other apps
    - **Added PRIME offload environment variables**: `__NV_PRIME_RENDER_OFFLOAD=1`, `__VK_LAYER_NV_optimus=NVIDIA_only`
    - **Enabled nvidia-offload command** for explicit GPU selection when needed
    - Intel GPU now handles desktop/compositing (no tearing/flashing), NVIDIA available for demanding apps
    - CUDA packages already included in nvidia module when cudaSupport=true
    - Video editors can now properly utilize NVIDIA GPU via offload
  - **Impact**: 
    - Cleaner flake with no redundant inputs
    - Fixes flashing windows/context menus in GIMP on bagalamukhi
    - Video editors on matangi can now properly use NVIDIA GPU acceleration
    - Better power efficiency with hybrid graphics
    - Maintains identical hardware support for both hosts (14th gen i9 + RTX 4070 mobile)

- **2026-03-07**: CRITICAL FIX - Restored feature parity for matangi configuration after module refactoring
  - **Root cause**: matangi was missing critical packages and services that were present in original configuration before the module refactor
  - **Missing critical services restored**:
    - Added `networking.networkmanager.enable = true` (was completely missing - matangi had no network management!)
    - Added `services.udev.enable = true` for hardware device management
    - Added full networking configuration: nameservers [1.1.1.1, 8.8.8.8, 8.8.4.4, 9.9.9.9], NetworkManager settings (dns="default", unmanaged=["docker0","rndis0"], wifi.powersave=true), firewall disabled, TCP sysctl optimizations
    - Disabled `systemd.services.NetworkManager-wait-online.enable` for faster boot
  - **Missing critical packages restored**:
    - Added `packages.archives.enable = true` for archive handling utilities
    - Added `packages.system.performance.enable = true` (includes sysz, htop, iostat, etc.)
    - Added `packages.system.desktop.enable = true` (X11 utilities, dbus tools)
    - Added `packages.system.hardware.enable = true` (hardware monitoring tools)
    - Added `packages.system.filesystem.enable = true` (filesystem utilities)
    - Added `packages.system.multimedia.enable = true` (media processing tools)
  - **Missing overlays configuration restored**:
    - Added `nixpkgs.overlays` configuration to both matangi and bagalamukhi host files
    - Overlays: additions, modifications, unstable-packages, stable-packages, f2k-packages, chaotic-packages, antigravity-nix
    - Required for `pkgs.stable.*` and `pkgs.unstable.*` package references in modules
  - **Home-manager module loading fixed**:
    - Added `sharedModules = [./modules/home-manager]` to matangi's flake configuration
    - Ensures home-manager modules are properly loaded for smg user
  - **Video editing packages corrected for matangi**:
    - Updated multimedia module to use `pkgs.unstable.olive-editor` (as in original config, not stable)
    - Added `pkgs.stable.shotcut` and `pkgs.stable.openshot-qt` for matangi
    - Packages are matangi-specific (not enabled on bagalamukhi)
  - **Verified**: NetworkManager enabled, CUPS enabled, sysz available, all overlays loaded, configuration evaluates successfully
  - **Impact**: Restores matangi to same functionality as BEFORE refactor (not matching bagalamukhi, maintaining host-specific differences)

- **2026-03-07**: Created Brother laser printer module for matangi
  - Created `modules/nixos/printer/brother.nix` with CUPS and Brother driver support
  - Refactored `modules/nixos/printer/default.nix` to use imports pattern instead of inline configuration
  - Module includes options for: enable, drivers (default: brlaser), user, enableAvahi
  - Default driver set to `brlaser` only (matching original configuration)
  - Additional drivers can be added via `modules.printer.brother.drivers = [ pkgs.brlaser pkgs.otherdriver ];`
  - Enables CUPS printing service with Brother-specific drivers
  - Enables Avahi for network printer discovery (nssmdns4 + openFirewall)
  - Adds configured user to `lp` and `scanner` groups
  - Enabled on matangi with `modules.printer.brother.enable = true` and `user = "smg"`
  - Verified evaluation: CUPS enabled with brlaser driver, all Avahi settings enabled
  - Maintains all prior printer functionality while adding configurability

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


