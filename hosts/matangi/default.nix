{
  inputs,
  lib,
  config,
  pkgs,
  bhairava-grub-theme,
  ...
}: {
  imports = [
    # Hardware-specific configuration
    ./hardware-configuration.nix
  ];

  # Enable modules using the new "activate by enable option" paradigm
  modules = {
    system.boot.enable = true;
    base = {
      enable = true;
      timezone = "America/New_York";
      nix.enable = true;
    };
    shell = {
      enable = true;
      zsh = true;
    };
    users.smg.enable = true;
    packages = {
      core.enable = true;
      devtools.enable = true;
      fonts.enable = true;
      gui.enable = true;
      multimedia = {
        enable = true;
        creators = true; # gimp, olive-editor, etc.
      };
      network.enable = true;
      shell.enable = true;
      system.enable = true;
    };

    # Desktop Environment
    desktop = {
      xorg.enable = true;
      xfce.enable = true;
    };

    power.laptop.enable = true;
    programs.nix-ld.enable = true; # Allow running dynamically linked binaries like opencode
    performance = {
      default.enable = true;
      undervolt.enable = true; # Intel CPU undervolting + P-State limits
    };

    # Services
    services = {
      core.enable = true; # FWUPD, fstrim, journald, dbus
      ssh.enable = true; # OpenSSH server
    };

    security.doas.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    pathsToLink = ["/share/zsh" "/share/applications" "/share/xdg-desktop-portal"];
    systemPackages = with pkgs; [
      cpufrequtils
      config.boot.kernelPackages.acpi_call
      nvme-cli
      grub2
      mesa
      mesa-demos
      plymouth
      kdePackages.plymouth-kcm
      lenovo-legion
      i2c-tools
      peakperf
      intel-media-driver
      linuxHeaders
      luajitPackages.ldbus
      xssproxy
    ];
  };

  system.stateVersion = "24.11";
}
