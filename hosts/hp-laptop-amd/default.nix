{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  bhairava-grub-theme,
  ...
}: {
  disabledModules = [
    # Disable the default Awesome WM module
    # "services/x11/window-managers/awesome.nix"
  ];

  imports = [
    # Shared configuration across all machines
    ../shared

    # Select the user configuration
    ../shared/users/tlh.nix

    # Specific configuration
    ./hardware-configuration.nix
  ];

  boot = {
    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
    ];

    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        bhairava-grub-theme = {enable = true;};
      };
    };
  };

  environment = {
    variables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };

    systemPackages = with pkgs; [
      acpi
      mesa
      mesa-demos
      libva
      libdbusmenu
      libdbusmenu-gtk3
      dbus-broker
      dbus-glib
      dbus
      lua53Packages.ldbus
      lua54Packages.ldbus
      luajitPackages.ldbus
      polkit_gnome
      libva-utils
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        mesa
        mesa-demos
        glfw
      ];
    };
  };

  networking = {
    hostName = "hp-laptop-amd";
    networkmanager.enable = true;
    useDHCP = false;
  };

  services = {
    acpid.enable = true;
    logind.lidSwitch = "suspend";
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 0; # dummy value
        STOP_CHARGE_THRESH_BAT0 = 1; # battery conservation mode
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    upower.enable = true;

    xserver = {
      libinput = {
        enable = true;
        touchpad = {naturalScrolling = false;};
      };
    };
  };

  # Use custom Awesome WM module
  #v services.xserver.windowManager.awesome.enable = true;

  services.xserver = {
    enable = true;
    exportConfiguration = true;

    displayManager = {
      defaultSession = "none+awesome";
      lightdm = {
        enable = true;
      };
    };
    windowManager.awesome = {
      enable = true;
      package = awesome.override {
        lua = luajit;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
