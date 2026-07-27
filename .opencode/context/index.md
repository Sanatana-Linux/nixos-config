# Wiki Catalog

> Auto-maintained catalog of all context files. Last updated: 2026-07-15

---

## Frameworks — Architecture, Design, Conventions

| Page | Description |
|------|-------------|
| [[nixos-architecture]] | Project structure, enable-by-option module pattern, host configurations, kernel module conventions, Stylix theming |
| [[nixos-installation-guide]] | Complete installation workflow from live ISO through post-setup and secrets management |
| [[nixos-troubleshooting]] | Collection of issues and fixes — build failures, thermal, NVIDIA, ZSH, Neovim, console fonts |
| [[nixos-package-management]] | Searching for packages, declarative vs imperative install, nix-search-cli |
| [[nix-flake-templates]] | 42 dev environment templates (bun, go, rust, python, etc.) and usage workflow |
| [[zsh-keybindings]] | Custom ZSH keybindings — line/word navigation, history, completion menu, vi-mode |
| [[lenovo-legion-ec-wmi-interface-reference]] | EC, WMI, ACPI, and firmware interfaces for Lenovo Legion laptops (model: Legion Pro 5 16IRX9) |
| [[lenovo-legion-kernel-overlay-fixes]] | Two critical patches to the nixpkgs lenovo-legion package — sysfs path fix and upstream tracking |
| [[sea-greeter-display-manager]] | Sea-greeter LightDM WebKit greeter architecture, theming, HW acceleration |

## Decisions — ADRs

| Page | Description |
|------|-------------|
| [[decisions]] | Architecture Decision Records — Sea-greeter, fan control, thermals, NVIDIA, BIOS, Yazi, TLP, PCIe ASPM |

## External References — Nix Ecosystem Guides

| Page | Description |
|------|-------------|
| [[nix-ecosystem-reference]] | Context7-harvested official Nix docs — package manager, language, flakes, modules |
| [[nixos-and-flakes-book]] | Ryan Yin's "NixOS & Flakes Book" — beginner-friendly, focuses on flakes |
| [[nix-dev-best-practices]] | nix.dev official best practices guide |
| [[nixos-for-developers]] | Comprehensive guide to using NixOS for software development |
| [[nixos-hardware-lenovo-legion-16irx9h]] | nixos-hardware profile for Lenovo Legion 16IRX9H |
| [[flake-utils-plus]] | FUP library reference — painless flake configuration generation |
| [[impermanence]] | Impermanence module — ephemeral root with persistent state |
| [[nix-secrets-reference]] | EmergentMind's sops-nix secrets reference |
| [[nixpak-sandboxing]] | NixPak bubblewrap-based runtime sandboxing for Nix packages |
| [[nix-commands-reference]] | Common nix commands — flake management, build, switch, garbage collection, packaging |

## Research — Raw Sources & Problem Investigations

| Page | Description |
|------|-------------|
| [[research/lenovo-legion-ec-fan-control]] | Legion EC fan control investigation — sysfs interface, PWM ranges |
| [[research/nvme-heat-gpu-correlation]] | NVMe temperature / GPU correlation investigation |
| [[research/excessive-heat-fixes]] | Heat mitigation investigation — BIOS, TLP, kernel params |
| [[research/realtek-usb-wifi-nm-troubleshooting]] | Realtek USB WiFi NetworkManager debugging |
| [[research/bios-srep-vs-firmware-update-tradeoff]] | BIOS SREP chainload vs fwsetup tradeoff analysis |
| [[research/lanzaboote-secure-boot]] | Lanzaboote secure boot investigation |
| [[research/opencode-bun-segfault-config-keys]] | OpenCode Bun segfault from invalid config keys |
| [[research/lenovo-advanced-bios-srep]] | Lenovo Advanced BIOS SREP chainload, undervolt, and archival |
| [[research/yazi]] | Yazi file manager research |
| research/yazi/keymap-config | Yazi keymap configuration reference |
| [[research/nix-guides]] | Collection of Nix guides and tutorials |
| research/nix-guides/2026-05-17-ingested-nix-resources | Ingested Nix learning resources summary |
| research/nix-guides/xe-iaso-nix-flakes-series | Xe Iaso's Nix Flakes series |

## Session Artifacts

| Page | Description |
|------|-------------|
| [[session-2026-06-21-todo-sweep]] | TODO.md sweep + module reorganization — 9 items completed, directory restructuring |
