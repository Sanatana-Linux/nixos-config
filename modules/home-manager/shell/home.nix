{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.home;
in {
  options.modules.shell.home = {
    enable = lib.mkEnableOption "shared shell configuration";
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.local/share/gem/ruby/3.1.0/bin"
      "$HOME/.local/share/flatpak/exports/share"
      "$HOME/.npm-global/bin"
      "$HOME/bin"
      "$HOME/go/bin"
      "$HOME/Workspace/go/bin"
      "$HOME/node_modules/.bin"
      "$GOPATH/bin"
      "$GOBIN"
      "/home/linuxbrew/.linuxbrew/bin"
      "/home/linuxbrew/.linuxbrew/sbin"
      "/run/user/1000/fnm_multishells/87711_1736929409043/bin"
      "${pkgs.nodejs}/bin"
      "${pkgs.nodePackages_latest.pnpm}/bin"
      "${pkgs.nodejs_20}/bin"
      "${pkgs.gnutar}/bin"
      "${pkgs.git}/bin"
      "${pkgs.python311}/bin"
      "${pkgs.python312}/bin"
    ];

    home.sessionVariables = {
      EDITOR = lib.mkDefault "nvim";
      BROWSER = lib.mkDefault "firefox";
      TERMINAL = lib.mkDefault "kitty";
      GOPATH = lib.mkDefault "$HOME/go";
      GOBIN = lib.mkDefault "$HOME/go/bin";
      PNPM_HOME = lib.mkDefault "$HOME/.local/share/pnpm";
      FNM_DIR = lib.mkDefault "$HOME/.fnm";
      FNM_VERSION_FILE_STRATEGY = lib.mkDefault "local";
      FNM_RESOLVE_ENGINES = lib.mkDefault "true";
      FNM_COREPACK_ENABLED = lib.mkDefault "true";
      FNM_NODE_DIST_MIRROR = lib.mkDefault "https://nodejs.org/dist";
    };
  };
}
