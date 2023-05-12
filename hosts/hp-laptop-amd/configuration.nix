{ config, inputs, pkgs, lib, ... }:

let
  core-packages =
    import ../../modules/system/profiles/core/pkgs.nix { inherit pkgs; };

  development-packages =
    import ../../modules/system/profiles/development/pkgs.nix { inherit pkgs; };

  interface-packages =
    import ../../modules/system/profiles/interface/pkgs.nix { inherit pkgs; };

  fonts-packages =
    import ../../modules/system/profiles/fonts/pkgs.nix { inherit pkgs; };

  laptop-packages =
    pkgs.callPackage ../../modules/system/profiles/core/laptop/pkgs.nix {
      inherit pkgs;
    };

  networking-packages =
    import ../../modules/system/profiles/networking/pkgs.nix { inherit pkgs; };

  shell-packages =
    pkgs.callPackage ../../modules/system/profiles/shell/pkgs.nix {
      inherit pkgs;
    };

  sound-packages =
    import ../../modules/system/profiles/sound/pkgs.nix { inherit pkgs; };

  virtualisation-packages =
    import ../../modules/system/profiles/virtualisation/pkgs.nix {
      inherit pkgs;
    };

in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/profiles/fonts
    ../../modules/system/profiles/development
    ../../modules/system/profiles/interface
    ../../modules/system/profiles/networking
    ../../modules/system/profiles/shell
    ../../modules/system/profiles/sound
    ../../modules/system/profiles/virtualisation
    ../../modules/system/profiles/bluetooth
    ../../modules/system/profiles/security
    ../../modules/system/profiles/core/laptop

  ];

  # use grub with os-prober support
  boot = {
    initrd.systemd.enable = true;
    # unstable kernel   
    kernelPackages = pkgs.linuxPackages_latest;
    # Boot Loader
    loader = {
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
        bhairava-grub-theme = { enable = true; };

      };
    };
  };

  programs.zsh.enable = true;
  # time zone
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    dpi = 96;
    libinput.enable = true;
    displayManager = {
      defaultSession = "none+awesome";
      lightdm = {
        enable = true;
        background = ../../modules/system/programs/lightdm/wallpaper.png;
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.colloid-gtk-theme;
            name = "Colloid-Dark";
          };
          cursorTheme = {
            package = pkgs.phinger-cursors;
            name = "Phinger Cursors (light)";
          };
          iconTheme = {
            package = pkgs.tela-circle-icon-theme;
            name = "Tela";
          };
          indicators = [ "~session" "~spacer" ];
        };
      };
      #autoLogin = {
      #  enable = true;
      #  user = "tlh";
      #};
    };

    windowManager.awesome = {
      enable = true;
      package = pkgs.awesome-luajit-git;

      luaModules = lib.attrValues {
        inherit (pkgs.luaPackages)
          cjson dkjson ldbus luasec lgi ldoc lpeg lpeg_patterns luafilesystem
          luasocket luasystem stdlib luaposix argparse vicious;
      };
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

  # List packages installed in system profile. 
  environment.systemPackages = core-packages ++ development-packages
    ++ interface-packages ++ laptop-packages ++ networking-packages
    ++ shell-packages ++ sound-packages ++ virtualisation-packages
    ++ (with pkgs; [
      awesome-luajit-git
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

