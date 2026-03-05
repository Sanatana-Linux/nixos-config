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
      firefox = {
        enable = true;
        higgs-boson = true;
      };
      kitty.enable = true;
      gpg.enable = true;
      zathura.enable = true;
      yazi.enable = true;
    };
    services = {
      picom.enable = true;
      xscreensaver.enable = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.f2k-packages
      inputs.nixpkgs-f2k.overlays.default
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = ["secrets" "ssh" "pkcs11"];
  };
  programs.home-manager.enable = true;

  home = {
    username = "user";
    homeDirectory = "/home/user";
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
