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
./programs/gpg/default.nix
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

  nix = {
    package = lib.mkForce pkgs.nixVersions.git;
    settings = {
      experimental-features = ["recursive-nix" "auto-allocate-uids" "nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.default
      inputs.nixpkgs-f2k.overlays.default
      inputs.nur.overlay
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
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.11";
  };
}