{
  pkgs,
  lib,
  config,
  ...
}: let
  extract = import ./bin/extract {inherit pkgs;};
  gita = import ./bin/gita {inherit pkgs;};
  nux = import ./bin/nux {inherit pkgs;};
  preview = import ./bin/preview {inherit pkgs;};
  run = import ./bin/run {inherit pkgs;};
  updoot = import ./bin/updoot {inherit pkgs;};
  vfio = import ./bin/vfio {inherit pkgs;};
in {
  imports = [
    ./xdg.nix
    ./zsh.nix
    ./starship.nix
    ./cli.nix
    ./git.nix
    ./nix.nix
  ];

  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/Workspace/go/bin"
    ];

    sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/Workspace/go";
      GOBIN = "${config.home.homeDirectory}/Workspace/go/bin";
    };
    home.packages = with pkgs; [extract gita nux preview run updoot vfio];
    #file = { };
  };
}
