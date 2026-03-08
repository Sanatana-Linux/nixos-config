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
      "$HOME/.local/share/pnpm"
      "$HOME/.local/share/gem/ruby/3.1.0/bin"
      "$HOME/.local/share/flatpak/exports/share"
      "$HOME/.cargo/bin"
      "$HOME/.yarn/bin"
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
