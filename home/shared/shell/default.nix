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
      "${config.home.homeDirectory}/.local/share/pnpm"
      "${config.home.homeDirectory}/node_modules/.bin"
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
      "/run/user/1000/fnm_multishells/87711_1736929409043/bin"
    ];

    sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/Workspace/go";
      PERLPATH = "/run/current-system/sw/bin/perl";
      GOBIN = "${config.home.homeDirectory}/Workspace/go/bin";
      SHELL = "${pkgs.zsh}/bin/zsh";
      PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
      FNM_MULTISHELL_PATH = "/run/user/1000/fnm_multishells/87711_1736929409043";
      FNM_VERSION_FILE_STRATEGY = "local";
      FNM_DIR = "/home/tlh/.local/share/fnm";
      FNM_LOGLEVEL = "info";
      FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist";
      FNM_COREPACK_ENABLED = "true";
      FNM_RESOLVE_ENGINES = "true";
      FNM_ARCH = "x64";
    };
  };
}
