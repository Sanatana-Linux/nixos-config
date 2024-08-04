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
      "${config.home.homeDirectory}/.local/share/gem/ruby/3.1.0/bin"
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
      "${config.home.homeDirectory}/Workspace/go/bin"
      "$GOBIN"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.yarn/bin"
      "/var/lib/flatpak/exports/share"
    ];

    sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/Workspace/go";
      GOBIN = "${config.home.homeDirectory}/Workspace/go/bin";
      SHELL = "${pkgs.zsh}/bin/zsh";
    };

    #file = { };
  };
}
