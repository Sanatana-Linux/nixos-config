{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./theme.nix
  ];

  # Restored modules configuration for feature parity - ONLY originally enabled modules
  modules = {
    packages = {
      essential.enable = true;
    };
    shell = {
      home.enable = true;
    };
    desktop = {
      enable = true;
    };
    programs = {
      higgs-boson-firefox.enable = true;
      kitty.enable = true;
      gpg.enable = true;
      zathura.enable = true;
      yazi.enable = true;
      # Note: neovim was commented out in original config, not enabling
    };
    services = {
      picom = {
        enable = true;
        # backend = "egl"; # Using default glx backend for consistency
      };
      xscreensaver.enable = true;
    };
  };

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
