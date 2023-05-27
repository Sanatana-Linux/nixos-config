{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./xdg.nix
    ./zsh.nix
    ./starship.nix
    ./cli.nix
    ./git.nix
    ./nix.nix
    ./bin/default.nix
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

    #file = { };
  };
}
