{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.home;
in {
  # Import the shell configuration modules at the top level
  imports = [
    ./home/xdg.nix
    ./home/starship.nix
    ./home/cli.nix
    ./home/nix.nix
    ./home/bin/default.nix
    ./home/zsh.nix
  ];

  options.modules.shell.home = {
    enable = lib.mkEnableOption "shared shell configuration";
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "$HOME/.config/emacs/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.npm-global/bin"
      "$HOME/bin"
      "$HOME/go/bin"
      "$GOPATH/bin"
      "/home/linuxbrew/.linuxbrew/bin"
      "/home/linuxbrew/.linuxbrew/sbin"
      "${pkgs.nodejs}/bin"
      "${pkgs.nodePackages_latest.pnpm}/bin"
      "${pkgs.nodejs_20}/bin"
      "${pkgs.nodejs_20}/bin"
      "${pkgs.gnutar}/bin"
      "${pkgs.git}/bin"
      "${pkgs.python311}/bin"
      "${pkgs.python312}/bin"
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      GOPATH = "$HOME/go";
      GOBIN = "$HOME/go/bin";
      PNPM_HOME = "$HOME/.local/share/pnpm";
      FNM_DIR = "$HOME/.fnm";
      FNM_VERSION_FILE_STRATEGY = "local";
      FNM_RESOLVE_ENGINES = "true";
      FNM_COREPACK_ENABLED = "true";
      FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland-egl";
    };
  };
}
