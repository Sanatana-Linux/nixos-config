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
    stylix.enable = true;
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
      monokaiProSkeudos.enable = true;
    };
    programs = {
      fastfetch.enable = true;
      higgs-boson-firefox.enable = true;
      kitty.enable = true;
      gpg.enable = true;
      zathura.enable = true;
      yazi.enable = true;
      vesktop.enable = true;
      # Note: neovim was commented out in original config, not enabling
    };
    services = {
      gnome-keyring = {
        enable = true;
        components = ["secrets" "ssh" "pkcs11"];
      };
      # Polkit authentication agent for GUI dialogs (mounting encrypted drives, etc.)
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
