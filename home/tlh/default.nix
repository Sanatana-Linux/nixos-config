{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../shared/X
    ../shared/desktop
    ../shared/pkgs
    ../shared/programs/yazi/default.nix
    ../shared/programs/aichat.nix
    ../shared/programs/vscode.nix
    ../shared/programs/firefox.nix
    ../shared/programs/gpg/default.nix
    ../shared/programs/zathura/default.nix
    ../shared/programs/kitty/default.nix
    ../shared/programs/neovim/default.nix
    ../shared/programs/ghostty.nix
    ../shared/programs/ranger/default.nix
    ../shared/programs/zathura/default.nix
    ../shared/services/default.nix
    ../shared/services/picom.nix
    ../shared/shell
  ];

  systemd.user.startServices = "sd-switch";

  # we have manix & internet for this
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
}
