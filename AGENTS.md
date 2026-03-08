# AGENTS.md - NixOS Configuration Codebase

## Repository Guidelines
**IMPORTANT:** All modifications must be made to THIS repository (`/home/tlh/nixos`) only. Never modify files in `/etc/nixos` or system directories. This flake-based configuration is self-contained and manages the entire system configuration through this repository.

## Host-Specific Information
This repository manages three NixOS hosts, each with a specific primary user:
- **bagalamukhi** - Primary user: `tlh` (current development system)
- **matangi** - Primary user: `smg`
- **chhinamasta** - Primary user: `user` (live ISO installer)

## Build, Lint, and Test Commands
- **Build system config:** `sudo nixos-rebuild switch --flake .#<host>` (replace `<host>` with bagalamukhi, matangi, chhinamasta)
- **Test config (no switch):** `sudo nixos-rebuild test --flake .#<host>`
- **Run a single test:** Use `nixos-rebuild test --flake .#<host>` after editing relevant files; for module/unit tests, see documentation/debugging/
- **Enter dev shell:** `nix develop` (uses shell.nix)
- **Format code:** `nix fmt` (Alejandra, see flake.nix)
- **Build ISO:** `nix build .#nixosConfigurations.<host>.config.system.build.isoImage`

## Code Style Guidelines
- **Formatting:** Always run `nix fmt` before committing.
- **Imports:** Inputs first, then local modules; see hosts/shared/default.nix:8-16.
- **Attribute sets:** Multi-line, trailing semicolons.
- **Naming:** kebab-case for files/dirs, camelCase for Nix attrs.
- **Function signatures:** Multi-line, named params in curly braces.
- **Comments:** Use `#` for lines; prefer descriptive attribute names over comments.
- **Types:** Use explicit types for Nix options and module arguments.
- **Error handling:** Use `lib.mkIf` for conditionals; pass inputs via `specialArgs`.
- **Testing:** Always run `nixos-rebuild test` before switching; check debugging/ for more.

## Architecture
- Hosts: `hosts/` (machine configs)
- Modules: `hosts/shared/`, `modules/` (reusable)
- Home Manager: `home/` (user configs)
- Overlays: `overlays/` (package mods)
- Templates: `templates/` (dev envs)

## Module Structure and Organization
**CRITICAL:** All modules MUST follow the "activate by enable option" paradigm. Every module must:
1. **Provide an enable option** using `mkEnableOption` (e.g., `modules.hardware.iphone.enable`)
2. **Wrap all configuration** in `mkIf config.modules.<category>.<name>.enable { ... }`
3. **Be nested in the appropriate subdirectory** under `modules/nixos/` or `modules/home-manager/`

### Module Directory Structure
NixOS modules belong in `modules/nixos/` with the following categories:
- `ai/` - AI tools and services
- `base/` - Core system configuration (timezone, nix settings)
- `desktop/` - Desktop environment configurations (xorg, xfce, etc.)
- `environment/` - System environment variables and paths
- `hardware/` - Hardware-specific modules (bluetooth, iphone, android, nvidia, etc.)
- `packages/` - Package collections (core, devtools, fonts, gui, multimedia, etc.)
- `performance/` - Performance tuning and optimization
- `power/` - Power management (laptop, desktop)
- `printer/` - Printing services
- `programs/` - Program-specific configurations
- `security/` - Security modules (doas, fail2ban, tpm, etc.)
- `services/` - System services (ssh, core services, etc.)
- `shell/` - Shell configurations
- `system/` - System-level settings (boot, kernel)
- `users/` - User account definitions
- `virtualization/` - Virtualization support (docker, podman, libvirt)

Home Manager modules belong in `modules/home-manager/` with categories:
- `desktop/` - User desktop settings
- `packages/` - User package collections
- `programs/` - User program configurations
- `services/` - User services (gnome-keyring, etc.)
- `shell/` - User shell configurations

### Module Template
When creating new modules, follow this template:
```nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.<category>.<name> = {
    enable = mkEnableOption "<description>";
    # Additional options here
  };

  config = mkIf config.modules.<category>.<name>.enable {
    # All configuration goes here
  };
}
```

### Module Import Rules
- Each category directory MUST have a `default.nix` that imports all modules in that directory
- Add new modules to the appropriate `default.nix` imports list
- Example: `modules/nixos/hardware/default.nix` imports `./iphone.nix`, `./bluetooth.nix`, etc.

## Changelog Management
All significant changes to the configuration must be documented in `.documentation/CHANGELOG.md`. When making changes, add entries as unordered list items with the following format:
- **YYYY-MM-DD**: Brief description of the change
  - Detailed sub-items for each specific change

Changes to document include:
- Package additions or removals
- Module structure changes
- Host configuration updates
- Build system modifications
- Breaking changes or deprecations

**IMPORTANT:** Always update the changelog IMMEDIATELY after making configuration changes. Add entries at the top of the "Changes" section, using today's date (Sat Mar 07 2026).
