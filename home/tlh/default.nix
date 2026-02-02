{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../shared/X
    ./theme.nix
    ../shared/pkgs
    ../shared/programs/yazi/default.nix
    # ../shared/programs/aichat.nix
    ../shared/programs/firefox.nix
    ../shared/programs/gpg/default.nix
    ../shared/programs/zathura/default.nix
    ../shared/programs/kitty/default.nix
    # ../shared/programs/neovim/default.nix
    ../shared/services/default.nix
    ../shared/services/picom.nix
    ../shared/shell
  ];

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
      outputs.overlays.unstable-packages
      outputs.overlays.f2k-packages
      outputs.overlays.chaotic-packages
      inputs.nixpkgs-f2k.overlays.default
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      # allowUnsupportedSystem = true;
      allowBroken = true;
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = ["secrets" "ssh" "pkcs11"];
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
