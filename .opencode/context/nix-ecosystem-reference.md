# Nix Ecosystem Reference

> Harvested: 2026-04-27 | Source: Context7 MCP (official docs)

## Nix Package Manager (`/nixos/nix`)

### Flake Basics

```nix
{
  description = "A flake for building Hello World";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildPhase = "gcc -o hello ./hello.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
      };
  };
}
```

### Enable Experimental Features

```nix
# nix.conf
experimental-features = nix-command flakes
```

### Common Build Commands

```bash
nix build                          # default package from current flake
nix build nixpkgs#hello           # package from nixpkgs
nix build nixpkgs#hello --print-out-paths  # print store path
nix build "nixpkgs#openssl^*"     # all outputs of a package
nix build --file release.nix build.x86_64-linux  # non-flake expression
nix build --profile /nix/var/nix/profiles/system \
    ~/my-configurations#nixosConfigurations.machine.config.system.build.toplevel
```

### Derivation Basics

```nix
# Raw derivation
derivation {
  name = "hello";
  system = "x86_64-linux";
  builder = "/bin/bash";
  args = [ "-c" "echo 'Hello, World!' > $out" ];
}

# Preferred: stdenv.mkDerivation
{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  pname = "hello"; version = "1.0"; src = ./src;
  buildInputs = [ pkgs.gcc ];
  buildPhase = '' gcc -o hello hello.c '';
  installPhase = '' mkdir -p $out/bin; cp hello $out/bin/ '';
  meta = { description = "A simple hello world program"; license = pkgs.lib.licenses.mit; };
}
```

---

## NixOS (`/websites/nixos_manual_nixos_stable`)

### Module Structure

```nix
{ config, pkgs, lib, ... }:
with lib;
{
  options = {
    foo = mkOption {
      type = types.bool;
      default = false;
      description = "Enable foo";
    };
  };
  config = mkIf config.foo {
    # definition
  };
}
```

### Service Module Pattern

```nix
{ options, config, lib, pkgs, ... }:
let
  cfg = config.services.foo;
  settingsFormat = pkgs.formats.json {};
in {
  options.services.foo = {
    enable = lib.mkEnableOption "foo service";
    settings = lib.mkOption {
      type = settingsFormat.type;
      default = {};
      description = "Configuration for foo";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc."foo.json".source =
      settingsFormat.generate "foo-config.json" cfg.settings;
    users.users.${cfg.settings.user} = { isSystemUser = true; };
  };
}
```

### Rebuild Commands

```bash
nixos-rebuild switch --flake .#hostname   # build + activate
nixos-rebuild boot --flake .#hostname     # build, activate on next boot
nixos-rebuild build --flake .#hostname    # build only
nixos-rebuild vm --flake .#hostname       # test in VM
```

---

## Nix Flakes (`/ryan4yin/nixos-and-flakes-book`)

### Complete Outputs Structure

```nix
{ inputs, ... }:
outputs = { self, ... }@inputs: {
  packages."<system>"."<name>" = derivation;
  packages."<system>".default = derivation;
  apps."<system>"."<name>" = { type = "app"; program = "<store-path>"; };
  formatter."<system>" = derivation;
  overlays."<name>" = final: prev: {};
  overlays.default = {};
  nixosModules."<name>" = { config }: { options = {}; config = {}; };
  nixosConfigurations."<hostname>" = {};
  devShells."<system>"."<name>" = derivation;
  devShells."<system>".default = derivation;
  templates."<name>" = { path = "<store-path>"; description = "..."; };
};
```

### Flake NixOS Configuration

```nix
{
  description = "A simple NixOS flake";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; };
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
```

### Special Args for Inputs

```nix
{
  inputs = { nixpkgs.url = "..."; helix.url = "github:helix-editor/helix/master"; };
  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
```

### Dev Shell

```nix
{ inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; };
  outputs = { self, nixpkgs, ... }: let system = "x86_64-linux"; in {
    devShells."${system}".default = let pkgs = import nixpkgs { inherit system; };
    in pkgs.mkShell {
      packages = with pkgs; [ nodejs_24 nodePackages.pnpm ];
      shellHook = '' echo "node `node --version`" '';
    };
  };
}

# Usage: nix develop
```

---

## Agenix (`/ryantm/agenix`)

### CLI Commands

```bash
agenix -e secret1.age                        # create/edit secret (uses $EDITOR)
agenix -e secret1.age -i ~/.ssh/id_ed25519  # with specific identity
agenix -d secret1.age                        # decrypt to stdout
echo "my-password" | agenix -e db-password.age  # pipe non-interactive
agenix --rekey                               # rekey all secrets after key changes
RULES=/path/to/custom/secrets.nix agenix --rekey  # custom secrets.nix
```

### NixOS Configuration

```nix
{
  age.identityPaths = [
    "/var/lib/persistent/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];
  # IMPORTANT: Use string paths, NOT nix paths (would copy key to nix store)
}
```

---

## Sops-nix (`/mic92/sops-nix`)

### Flake Integration

```nix
{
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  outputs = { self, nixpkgs, sops-nix }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
  };
}
```

### NixOS Configuration

```nix
{
  sops.defaultSopsFile = ./secrets/example.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  sops.secrets.example-key = {};
  sops.secrets."myservice/my_subdir/my_secret" = {};
}
```

### YAML Secrets

```bash
sops secrets.yaml
```

```nix
{ sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets.github_token = { format = "yaml"; sopsFile = ./secrets.yaml; };
}
```

### .sops.yaml Rules

```yaml
keys:
  - &admin_alice 2504791468b153b8a3963cc97ba53d1919c5dfd4
  - &admin_bob age12zlz6lvcdk6eqaewfylg35w0syh58sm7gh53q5vvn7hd7c6nngyseftjxl
creation_rules:
  - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
    key_groups:
    - pgp: [*admin_alice]
      age: [*admin_bob]
```

---

## Home-Manager (`/nix-community/home-manager`)

### Flake Integration (NixOS Module)

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jdoe = ./home.nix;
        }
      ];
    };
  };
}
```

### User Configuration Basics

```nix
{ config, pkgs, ... }: {
  home.username = "jdoe";
  home.homeDirectory = "/home/jdoe";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [ htop ripgrep fd jq tree curl wget ];
  home.sessionVariables = { EDITOR = "vim"; };
}
```

### Dotfile Management

```nix
{
  home.file.".vimrc".text = '' set number '';
  home.file.".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty.toml;
  home.file.".config/nvim" = { source = ./dotfiles/nvim; recursive = true; };
  home.file.".local/bin/git-cleanup" = { executable = true; text = ''#!/usr/bin/env bash ...''; };
  home.file.".config/my-app/config.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/my-app/config.yaml";
  xdg.configFile."starship.toml".source = ./dotfiles/starship.toml;
}
```

---

## Nixpkgs (`/nixos/nixpkgs`)

### stdenv.mkDerivation

```
Function: stdenv.mkDerivation
Parameters:
  - pname (string, required) — package name
  - version (string, required) — package version
  - src (derivation, required) — source code derivation
  - doCheck (boolean, optional) — run checkPhase
  - meta (attrset, optional) — description, license, maintainers
Returns: derivation path in Nix store
```

### Overlays

```nix
final: prev: {
  htop = prev.htop.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [ ./htop-fix.patch ];
  });
  myTool = final.callPackage ./my-tool.nix {};
  ffmpeg = prev.ffmpeg.override { withVdpau = false; withVaapi = true; };
  python3 = prev.python3.override {
    packageOverrides = pyFinal: pyPrev: {
      requests = pyPrev.requests.overridePythonAttrs (old: { doCheck = false; });
    };
  };
}
```

### Flake Overlay Usage

```nix
{
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ (import ./overlays) ];
    };
  };
}
```

---

## Lanzaboote (`/nix-community/lanzaboote`)

### Basic Setup

```nix
{
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
      includeMicrosoftKeys = true;
    };
  };
  environment.systemPackages = [ pkgs.sbctl ];
}
```

### Flake Integration

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, lanzaboote, ... }: {
    nixosConfigurations.my-secure-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        lanzaboote.nixosModules.lanzaboote
        ({ pkgs, lib, ... }: {
          boot.loader.systemd-boot.enable = lib.mkForce false;
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
            configurationLimit = 50;
            settings = { timeout = 5; editor = null; };
          };
          environment.systemPackages = [ pkgs.sbctl ];
        })
      ];
    };
  };
}
```

### sbctl Commands

```bash
sbctl enroll-keys --microsoft    # enroll with MS keys (recommended)
sbctl enroll-keys --tpm-eventlog # enroll with TPM checksums
bootctl status                   # check firmware/Secure Boot status
```

---

## Disko (`/nix-community/disko`)

### Basic GPT Layout

```nix
{
  disko.devices = {
    disk.vdb = {
      device = "/dev/disk/by-id/some-disk-id";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00"; size = "100M";
            content = {
              type = "filesystem"; format = "vfat";
              mountpoint = "/boot"; mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem"; format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
```

### LUKS + LVM

```nix
{
  disko.devices = {
    disk.main = {
      type = "disk"; device = "/dev/vdb";
      content = {
        type = "gpt";
        partitions = {
          ESP = { size = "500M"; type = "EF00"; content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; mountOptions = [ "umask=0077" ]; }; };
          luks = {
            size = "100%";
            content = {
              type = "luks"; name = "crypted";
              settings = { keyFile = "/tmp/secret.key"; allowDiscards = true; };
              content = { type = "lvm_pv"; vg = "pool"; };
            };
          };
        };
      };
    };
    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        root = { size = "100%"; content = { type = "filesystem"; format = "ext4"; mountpoint = "/"; }; };
        home = { size = "10M"; content = { type = "filesystem"; format = "ext4"; mountpoint = "/home"; }; };
      };
    };
  };
}
```

### Flake Integration

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, disko }: {
    nixosConfigurations.mymachine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix disko.nixosModules.disko { disko.devices = {}; } ];
    };
  };
}
```

### Installer Workflow

```bash
lsblk                                                      # identify disk
nix flake init --template github:nix-community/disko-templates#single-disk-ext4
nano /tmp/disk-config.nix                                  # set device
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount /tmp/disk-config.nix
nixos-generate-config --no-filesystems --root /mnt
mv /tmp/disk-config.nix /mnt/etc/nixos/
nixos-install
reboot
```
