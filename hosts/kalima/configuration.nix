# vim:tabstop=2 shiftwidth=2 expandtab
{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
    "${toString modulesPath}/modules/system/profiles/all-hardware.nix"
    "${toString modulesPath}/modules/system/profiles/base.nix"
    "${toString modulesPath}/modules/system/profiles/installation-device.nix"
    inputs.home-manager.nixosModules.home-manager
    # Shared configuration across all machines
    ../shared/default.nix

    # Select the user configuration
    ../shared/users/tlh.nix

    # bluetooth support
    ../shared/hardware/bluetooth.nix

    # nvidia support
    ../shared/hardware/nvidia.nix

    # common hardware support
    ../shared/hardware/common.nix

    # AwesomeWM
    ../shared/desktop/default.nix
    ../shared/desktop/awesomewm.nix

    # Packages
    ./pkgs.nix
  ];

  security.sudo.enable = true;
  environment.etc."nixos".source = /etc/nixos;
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = ["tlh"];
        groups = ["wheel"];
        noPass = true;
        keepEnv = true;
        persist = false;
      }
    ];
  };

  # unstable kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # bash gets starship as I do not want
  programs.bash = {
    promptInit = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
  };

  # Pick only one of the below networking options.
  #networking.networkmanager.enable = true;
  networking.nameservers = ["8.8.8.8" "4.4.8.8"];
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus14";
    keyMap = "us";
    #    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.dpi = 96;
  services.xserver.displayManager = {
    defaultSession = "none+awesome";
    lightdm = {
      enable = true;
      greeters.gtk.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "tlh";
    };
  };

  services.blueman.enable = true;

  # Defines my account, on first boot I change the passwd as root, don't worry!
  users.users.liveuser = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "input"];
    initialPassword = "password";
  };

  # shell
  users.defaultUserShell = pkgs.zsh;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    bat
    btop
    cmake
    coreutils
    curl
    exa
    fd
    feh
    file
    fzf
    fzy
    gcc
    gh
    git
    glib
    gnumake
    gnutls
    home-manager
    htop
    jq
    libtool
    mesa-demos
    mu
    ncdu
    neovim
    nix-index
    nix-tree
    nmap
    nodejs
    openjdk
    pciutils
    ps_mem
    psftools
    python3
    ranger
    ripgrep
    rnix-lsp
    smartmontools
    sqlite
    trash-cli
    unrar
    unzip
    xarchiver
    xclip
    xorg.xev
    yt-dlp
    zip
    zsh
  ];

  fonts = {
    fonts = with pkgs; [
      norwester-font
      mplus-outline-fonts.githubRelease
      profont
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "hintslight";
      };

      subpixel.lcdfilter = "default";

      defaultFonts = {
        monospace = ["mplus Nerd Font Mono Medium "];
        sansSerif = ["Rounded Mplus 1c Medium"];
        serif = ["Rounded Mplus 1c Medium"];
      };
    };
  };

  # Change Console Colors to match theme

  console.colors = ["1c1c1c" "ff3d81" "85ff94" "f0ffaa" "00caff" "660ed0" "00eaff" "b6b6b6" "f83d80" "4dd564" "ffff73" "0badff" "b92b27" "8265ff" "d1d1d1"];
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

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;

  isoImage.squashfsCompression = "gzip -Xcompression-level 9";
}
