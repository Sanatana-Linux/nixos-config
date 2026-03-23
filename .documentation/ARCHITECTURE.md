# Architecture Overview

This document provides a comprehensive explanation of the NixOS configuration architecture, module system, and design principles used in this repository.

## Table of Contents

1. [Project Structure](#project-structure)
2. [The Module System](#the-module-system)
3. [Configuration Composition](#configuration-composition)
4. [Host Configurations](#host-configurations)
5. [Home Manager Integration](#home-manager-integration)
6. [Overlays and Packages](#overlays-and-packages)
7. [Kernel Modules and Parameters](#kernel-modules-and-parameters)

---

## Project Structure

```
/home/tlh/nixos/
├── .documentation/          # Project documentation
├── .github/                 # GitHub-specific files (README)
├── flake.nix               # Flake entry point
├── hosts/                  # Host-specific configurations
│   ├── bagalamukhi/       # Development workstation
│   ├── matangi/           # Secondary workstation
│   └── chhinamasta/       # Live ISO installer
├── home/                   # Home Manager user configurations
│   ├── tlh/               # Primary user (bagalamukhi)
│   ├── smg/               # Secondary user (matangi)
│   └── user/              # Live ISO user
├── modules/                # Reusable modules
│   ├── nixos/            # NixOS system modules
│   └── home-manager/     # Home Manager modules
├── overlays/              # Nixpkgs overlays
├── shell.nix              # Development shell
└── templates/             # Development environment templates
```

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `hosts/` | Machine-specific configurations (hardware, services, packages) |
| `modules/` | Reusable NixOS and Home Manager modules organized by category |
| `home/` | Per-user Home Manager configurations (shell, programs, desktop) |
| `overlays/` | Package modifications, custom versions, patches |
| `.documentation/` | Project documentation and guides |

---

## The Module System

This repository uses the **activate-by-enable-option** paradigm, which is the same pattern used by NixOS itself. This approach provides maximum modularity and composability.

### Why Activate-by-Enable-Option?

Unlike simple "activate-by-import" (where importing a module always enables it), the enable-option pattern allows you to:

1. **Import everything conditionally** - All modules are imported but only activated when explicitly enabled
2. **Compose modules intelligently** - One module can enable or configure another
3. **Detect conflicts early** - Multiple modules can compete for configuration, raising clear errors
4. **Document all options** - Every available option is machine-discoverable

### Module Template

Every module follows this structure:

```nix
{ config, lib, pkgs, ... }:
with lib;
{
  # 1. Define options
  options.modules.<category>.<name> = {
    enable = mkEnableOption "description of what this enables";
    # Additional options with types and defaults
  };

  # 2. Conditionally apply configuration
  config = mkIf config.modules.<category>.<name>.enable {
    # All NixOS options go here
    # packages, services, boot.kernelModules, etc.
  };
}
```

### Module Directory Organization

NixOS modules are organized in `modules/nixos/` with category directories:

- `ai/` - AI tools (Ollama, ComfyUI, etc.)
- `base/` - Core system (Nix settings, services)
- `desktop/` - Desktop environments (Xorg, AwesomeWM, XFCE)
- `environment/` - Environment variables
- `hardware/` - Hardware-specific (NVIDIA, Bluetooth, Lenovo)
- `packages/` - Package collections
- `performance/` - Performance tuning (CachyOS, ZRAM)
- `power/` - Power management
- `printer/` - Printing support
- `programs/` - Program configurations
- `security/` - Security (doas, TPM, SSH)
- `services/` - System services
- `shell/` - Shell configuration
- `system/` - System-level (boot, kernel)
- `users/` - User definitions
- `virtualization/` - Docker, LXC, Virt-Manager

Each category directory contains:
- A `default.nix` that imports all modules in that category
- Individual module files (e.g., `nvidia.nix`, `bluetooth.nix`)

### Example: Hardware Module

```nix
# modules/nixos/hardware/nvidia.nix
{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA GPU support";
    cudaSupport = mkEnableOption "CUDA support";
  };

  config = mkIf config.modules.hardware.nvidia.enable {
    # Hardware configuration
    hardware.graphics = {
      enable = true;
      nvidia = {
        enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        # ... more nvidia options
      };
    };

    # Kernel parameters specific to NVIDIA
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];

    # Initrd modules for early KMS
    boot.initrd.kernelModules = ["nvidia-drm"];
  };
}
```

---

## Configuration Composition

### How a System Configuration is Built

1. **Flake defines outputs** (`flake.nix`)
   - Defines `nixosConfigurations` for each host
   - Defines `homeConfigurations` for each user

2. **Host imports modules** (`hosts/<name>/default.nix`)
   ```nix
   imports = [
     ./modules/nixos/base/default.nix
     ./modules/nixos/hardware/default.nix
     ./modules/nixos/desktop/default.nix
     # ... more module categories
   ];
   ```

3. **Modules define options** - Each module provides options via `mkEnableOption`

4. **Host enables features** - The host configuration enables what it needs:
   ```nix
   modules = {
     hardware = {
       nvidia.enable = true;
       bluetooth.enable = true;
       openrgb.enable = true;
     };
     desktop = {
       awesomewm.enable = true;
       xorg.enable = true;
     };
   };
   ```

5. **NixOS merges everything** - All enabled modules contribute their configuration

### Merging Strategy

Nix uses a sophisticated merging strategy for configurations:

- **Lists merge**: Multiple modules can add to a list (e.g., `boot.kernelModules`)
- **Attributes merge**: Nested attributes combine deeply
- **Last-defined-wins**: For simple values, the last definition wins
- **mkMerge**: For complex merging, use `lib.mkMerge` to combine multiple attribute sets

Example of merging kernel modules:
```nix
# In nvidia.nix
boot.kernelModules = ["nvidia" "nvidia-drm"];

# In openrgb.nix  
boot.kernelModules = ["i2c-dev" "i2c-i801"];

# Result: boot.kernelModules = ["nvidia" "nvidia-drm" "i2c-dev" "i2c-i801"]
```

---

## Host Configurations

Each host in `hosts/` represents a distinct machine with its own:

- Hardware configuration
- Enabled services
- Installed packages
- User accounts

### Host Structure

```nix
# hosts/bagalamukhi/default.nix
{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    # Import all module categories
    inputs.nixosModules.base
    inputs.nixosModules.hardware
    # ...
  ];

  # Host-specific module configuration
  modules = {
    hardware = {
      nvidia.enable = true;
      bluetooth.enable = true;
      lenovo.enable = true;
    };
    desktop = {
      awesomewm.enable = true;
      xorg.enable = true;
    };
  };

  # Network configuration
  networking = {
    hostName = "bagalamukhi";
    networkmanager.enable = true;
  };

  # Users
  users.users.tlh = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
  };

  # System packages (beyond what modules provide)
  environment.systemPackages = with pkgs; [
    # host-specific packages
  ];
}
```

### Available Hosts

| Host | Primary User | Purpose |
|------|-------------|---------|
| `bagalamukhi` | `tlh` | Development workstation (Lenovo Legion) |
| `matangi` | `smg` | Secondary workstation (Lenovo Legion) |
| `chhinamasta` | `user` | Live ISO installer |

---

## Home Manager Integration

Home Manager manages user-level configuration separately from system configuration:

- **Shell**: ZSH configuration, prompts, aliases
- **Programs**: Neovim, Kitty, GPG, SSH
- **Services**: GnuPG agent, screensaver, picom
- **Desktop**: GTK theme, X11 resources

### Integration Flow

1. **System config** builds the system packages and services
2. **Home config** builds user dotfiles and user-level services
3. **Both apply** on `nixos-rebuild switch`

### Example: User Configuration

```nix
# home/tlh/default.nix
{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.homeManagerModules.shell
    inputs.homeManagerModules.programs
  ];

  home.username = "tlh";
  home.homeDirectory = "/home/tlh";

  programs = {
    zsh.enable = true;
    neovim.enable = true;
    gpg.enable = true;
  };

  # User-specific packages
  home.packages = with pkgs; [
    # user-specific packages
  ];
}
```

---

## Overlays and Packages

### Overlays Directory

The `overlays/` directory contains Nixpkgs overlays that modify packages:

- `additions/` - New packages not in nixpkgs
- `modifications/` - Patched or modified packages
- `stable-packages/` - Force stable versions
- `nur/` - NUR (Nix User Repository) overlays

### How Overlays Work

```nix
# overlays/default.nix
final: prev: {
  # Add a new package
  my-package = final.callPackage ./my-package { };

  # Override an existing package
  neovim = final.neovim.override {
    # custom configuration
  };

  # Use a specific version
  python312 = final.python312.overrideAttrs (old: {
    # modifications
  });
}
```

### Applying Overlays

Overlays are applied in the flake and available as `pkgs`:

```nix
# In any module
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Uses overlays automatically
    my-package
    (final.python312.withPackages ps: [ ps.requests ])
  ];
}
```

---

## Kernel Modules and Parameters

A key architectural principle: **kernel modules and parameters belong with the hardware modules that require them**, not in a central location.

### The Problem with Centralization

Bad (hard to maintain, unclear ownership):
```nix
# modules/nixos/system/boot.nix
boot.kernelModules = [
  "nvidia"      # Why? Which module needs this?
  "i2c-dev"     # Why? 
  "lenovo_legion" # Why?
];
```

Good (module owns its requirements):
```nix
# modules/nixos/hardware/nvidia.nix
config = mkIf cfg.enable {
  boot.initrd.kernelModules = ["nvidia" "nvidia-drm"];
};

# modules/nixos/hardware/openrgb.nix
config = mkIf cfg.enable (mkMerge [
  { boot.kernelModules = ["i2c-dev"]; }
  (mkIf (cfg.motherboard == "intel") {
    boot.kernelModules = ["i2c-i801"];
  })
]);

# modules/nixos/hardware/lenovo.nix
config = mkIf cfg.enable {
  boot.kernelModules = ["lenovo_legion" "acpi_call"];
};
```

### Using mkMerge for Conditional Configuration

The `lib.mkMerge` function allows multiple attribute sets to be merged, with conditional inclusion:

```nix
config = mkIf cfg.enable (mkMerge [
  # Always applied
  {
    boot.kernelModules = ["i2c-dev"];
    environment.systemPackages = [pkgs.openrgb];
  }
  
  # Conditionally applied
  (mkIf (cfg.motherboard == "intel") {
    boot.kernelModules = ["i2c-i801"];
  })
  
  (mkIf (cfg.motherboard == "amd") {
    boot.kernelModules = ["i2c-piix4"];
  })
]);
```

### Best Practices

1. **One module = one responsibility** - Each hardware feature owns its kernel requirements
2. **Use mkMerge** for conditional module loading based on hardware
3. **Add inline comments** - Explain what each module/parameter does
4. **Don't duplicate** - If multiple modules need the same thing, create a shared module

---

## Quick Reference

### Common Commands

```bash
# Build and switch to a host
sudo nixos-rebuild switch --flake .#bagalamukhi

# Test configuration without switching
sudo nixos-rebuild test --flake .#bagalamukhi

# Format code
nix fmt

# Build ISO
nix build .#nixosConfigurations.chhinamasta.config.system.build.isoImage

# Enter development shell
nix develop
```

### Module Options

Every module provides options under `modules.<category>.<name>.*`:

```nix
# Enable a module
modules.hardware.nvidia.enable = true;

# Module-specific options
modules.hardware.nvidia.cudaSupport = true;
```

### Adding a New Module

1. Create `modules/nixos/<category>/<name>.nix`
2. Add option definitions with `mkEnableOption`
3. Wrap configuration in `mkIf config.modules.<category>.<name>.enable`
4. Add to `modules/nixos/<category>/default.nix` imports
5. Enable in host configuration

---

## Further Reading

- [NixOS Modules](https://nixos.org/manual/nixos/stable/#ch-modules)
- [NixOS Options](https://nixos.org/manual/nixos/stable/#sec-option-declarations)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nix Flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html)
- [Nixpkgs Overlays](https://nixos.org/manual/nixpkgs/stable/#chap-overlays)