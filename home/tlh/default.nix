{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
  ];

  # Restored modules configuration for feature parity - ONLY originally enabled modules
  modules = {
    packages = {
      essential.enable = true;
    };
    shell = {
      home.enable = true;
      environment.enable = true;
      zsh.enable = true;
      starship.enable = true;
      cli-tools.enable = true;
      nix.enable = true;
      xdg.enable = true;
      scripts.enable = true;
    };
    desktop = {
      enable = true;
    };
    stylix.enable = true;
    programs = {
      fastfetch.enable = true;
      higgs-boson-firefox.enable = true;
      kitty.enable = true;
      gpg.enable = true;
      zathura.enable = true;
      yazi.enable = true;
      # Note: neovim was commented out in original config, not enabling
    };
    services = {
      gnome-keyring = {
        enable = true;
        components = ["secrets" "ssh" "pkcs11"];
      };
      # Polkit authentication agent for GUI dialogs (mounting encrypted drives, etc.)
      polkit-agent.enable = true;
    };
  };

  # Enable PanchaKosha quickshell + MangoWC for this user
  programs = {
    quickshell = {
      mangowc = {
        enable = true;
      };
    };
  };

  wayland = {
    windowManager = {
      mangowc = {
        enable = true;
      };
    };
  };
  # Note: quickshell greeter assets are provided by the PanchaKosha flake; users get them
  # via the PanchaKosha Home Manager module when that flake is enabled.

  systemd.user.startServices = "sd-switch";

  # we have tealdeer & internet for this. Rendered in more readable formats
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      # allowUnsupportedSystem = true;
      allowBroken = true;
    };
  };

  programs.home-manager.enable = true;

  home = {
    username = "tlh";
    homeDirectory = "/home/tlh";
    stateVersion = "24.11";
    activation = {
      installConfig = ''
        # Ensure quickshell configuration is present for MangoWC sessions
        if [ ! -d "${config.home.homeDirectory}/.config/quickshell" ]; then
          mkdir -p "${config.home.homeDirectory}/.config/quickshell"
        fi
        # Keep awesome clone for users that still use it
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone https://github.com/Sanatana-Linux/nixos-awesomewm ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone https://github.com/Thomashighbaugh/nvim-forge ${config.home.homeDirectory}/.config/nvim
        fi
      '';
    };
  };
}
