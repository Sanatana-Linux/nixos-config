# Example host configuration showing the new module architecture
# This demonstrates how to use the "activate by enable option" pattern
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import the module system
    outputs.nixosModules.default
    inputs.home-manager.nixosModules.home-manager

    # Hardware configuration would go here
    # ./hardware-configuration.nix
  ];

  # Configure modules by enabling them with options
  modules = {
    # Base system modules
    base.enable = true;

    # Hardware modules
    hardware = {
      bluetooth.enable = true;
      intel.enable = true; # or nvidia.enable = true;
      sound.enable = true;
      networking.enable = true;
      android.enable = true; # For Android development
    };

    # Desktop environment
    desktop = {
      xfce.enable = true;
      # newm.enable = false;  # Alternative Wayland compositor
    };

    # Programs
    programs = {
      thunar.enable = true;
      nix-ld.enable = true;
    };

    # Services
    services = {
      pipewire.enable = true;
      systemd.enable = true;
    };

    # Performance optimizations
    performance = {
      zram.enable = true;
      oomd.enable = true;
    };

    # Package collections
    packages = {
      core.enable = true;
      development.enable = true;
      gui.enable = true;
      multimedia.enable = true;
      network.enable = true;
      shell.enable = true;
    };
  };

  # Home Manager configuration
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs;};
    backupFileExtension = "bak";

    users.tlh = {pkgs, ...}: {
      imports = [
        outputs.homeManagerModules.default
      ];

      # Configure home-manager modules
      modules = {
        # Shell configuration
        shell = {
          zsh.enable = true;
          starship.enable = true;
        };

        # Programs
        programs = {
          firefox.enable = true;
          # More programs can be enabled here
        };

        # Services would go here
        # services = {
        #   picom.enable = true;
        # };
      };

      # Standard home-manager config
      home = {
        username = "tlh";
        homeDirectory = "/home/tlh";
        stateVersion = "23.11";
      };

      programs.home-manager.enable = true;
    };
  };

  # System configuration
  system.stateVersion = "23.11";

  # User account
  users.users.tlh = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "video"];
  };
}
