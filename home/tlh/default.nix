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
    ../shared/programs/nemo/default.nix
    ../shared/programs/aichat.nix
    ../shared/programs/ghostty.nix
    ../shared/programs/joshuto.nix
    ../shared/programs/firefox.nix
    ../shared/programs/gpg/default.nix
    ../shared/programs/zathura/default.nix
    ../shared/programs/kitty/default.nix
    ../shared/programs/neovim/default.nix
    ../shared/programs/ranger/default.nix
    ../shared/programs/zathura/default.nix
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
      inputs.neovim-nightly-overlay.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowUnsupportedSystem = true;
      allowBroken = true;
    };
  };

  programs.home-manager.enable = true;

  home = {
    username = "tlh";
    homeDirectory = "/home/tlh";
    stateVersion = "24.11";
  };
  # Installation of AwesomeWM configuration if not present
  activation.installAwesomeWMConfig = ''
    if [ ! -d /home/tlh/.config/awesome ]; then
      git clone https://github.com/Sanatana-Linux/nixos-awesomewm /home/tlh/.config/awesome
      chmod -R +w /home/tlh/.config/awesome
      chown -R tlh /home/tlh/.config/awesome
      mkdir -p /home/tlh/.cache/awesome/json/
      touch  /home/tlh/.cache/awesome/json/settings.json
    fi
  '';

  # Installation of Neovim configuration if not present
  activation.installNvimConfig = ''
    if [ ! -d /home/tlh/.config/nvim ]; then
      git clone https://github.com/Thomashighbaugh/nvim-forge /home/tlh/.config/nvim
      chmod -R +w "/home/tlh/.config/nvim"
      chown -R tlh /home/tlh/.config/nvim
    fi
  '';
}
