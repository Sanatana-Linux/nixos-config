# vim:tabstop=2 shiftwidth=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let

  core-packages = import ../../modules/system/profiiles/core/pkgs.nix { inherit pkgs; };

  development-packages =
    import ../../modules/system/profiiles/development/pkgs.nix { inherit pkgs; };

  interface-packages =
    import ../../modules/system/profiiles/interface/pkgs.nix { inherit pkgs; };

  fonts-packages = import ../../modules/system/profiiles/fonts/pkgs.nix { inherit pkgs; };

  laptop-packages = pkgs.callPackage ../../modules/system/profiiles/core/laptop/pkgs.nix {
    inherit pkgs;
  };

  networking-packages =
    import ../../modules/system/profiiles/networking/pkgs.nix { inherit pkgs; };

  shell-packages =
    pkgs.callPackage ../../modules/system/profiiles/shell/pkgs.nix { inherit pkgs; };

  sound-packages = import ../../modules/system/profiiles/sound/pkgs.nix { inherit pkgs; };

  virtualisation-packages =
    import ../../modules/system/profiiles/virtualisation/pkgs.nix { inherit pkgs; };

  material-symbols = pkgs.callPackage ../../pkgs/material-symbols.nix { };

in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/profiiles/fonts
    ../../modules/system/profiiles/development
    ../../modules/system/profiiles/interface
    ../../modules/system/profiiles/networking
    ../../modules/system/profiiles/shell
    ../../modules/system/profiiles/sound
    ../../modules/system/profiiles/virtualisation

  ];

  # use grub with os-prober support
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };

  # unstable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # time zone
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  #  services.xserver.videoDrivers = [ "xorg.xf86amdgpu" ];

  services.xserver.dpi = 96;

  services.blueman.enable = true;
  #  services.xserver.displayManager.startx.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager = {
    defaultSession = "none+awesome";
    lightdm = {
      enable = true;
      greeters.mini.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "tlh";
    };
  };

  # Defines my account, on first boot I change the passwd as root, don't worry!
  users.users.tlh = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "networkmanager" "libvirtd" "video" "audio" "input" ];
    initialPassword = "tlh123";
  };

  # Just not hardcore enough I guess, this makes NixOS much less painful
  users.mutableUsers = true;

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = lib.attrValues {
      inherit (pkgs.luaPackages)
        cjson dkjson ldbus luasec lgi ldoc lpeg luadbi-mysql luaposix argparse
        vicious;
    };
  };

  # List packages installed in system profile. 
  environment.systemPackages = core-packages ++ development-packages
    ++ interface-packages ++ laptop-packages ++ networking-packages
    ++ shell-packages ++ sound-packages ++ virtualisation-packages
    ++ (with pkgs;
      [
        home-manager

      ]);

  system.stateVersion = "22.05";

  # enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # allow unfree pkgs through configuration.nix
  nixpkgs.config.allowUnfree = true;

  # Because sometimes, I don't want to wait a day to use my computer
  nixpkgs.config.allowBroken = true;

}

