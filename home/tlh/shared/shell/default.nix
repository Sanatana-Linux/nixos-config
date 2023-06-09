{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./xdg.nix
    ./starship.nix
    ./cli.nix
    ./nix.nix
    ./bin/default.nix
    ./zsh.nix
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
