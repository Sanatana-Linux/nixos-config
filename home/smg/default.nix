{
  lib,
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports =
    [
      ./X
      ./desktop
      ./pkgs
      ./programs/yazi/default.nix
      ./programs/vscode.nix
      ./programs/firefox.nix
      ./programs/zathura/default.nix
      ./programs/kitty/default.nix
      ./programs/neovim/default.nix
      ./programs/ranger/default.nix
      ./programs/zathura/default.nix

      ./services
      ./shell
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  systemd.user.startServices = "sd-switch";

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.default
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
    username = "smg";
    homeDirectory = "/home/smg";
    stateVersion = "24.11";
  };
}
