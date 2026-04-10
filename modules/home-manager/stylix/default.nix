{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.stylix;
in {
  options.modules.stylix = {
    enable = mkEnableOption "Stylix theming at Home Manager level";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;

      # Terminal emulators - override color8 (bright black) for readability
      targets.kitty = {
        enable = true;
        colors.override = {
          color8 = "#8b888f";
        };
      };
      targets.ghostty = {
        enable = true;
        colors.override = {
          color8 = "#8b888f";
        };
      };

      # Shell and CLI tools
      targets.bat.enable = true;
      targets.fzf.enable = true;
      targets.tmux.enable = true;
      targets.vivid.enable = true;

      # GUI applications - DISABLE GTK to prevent theme conflicts
      targets.nixcord.enable = true;
      targets.feh.enable = true;
      targets.sioyek.enable = true;
      targets.zathura.enable = true;
      targets.gtk.enable = false; # Disabled - using custom GTK config

      # Development tools

      targets.opencode.enable = true;

      # Desktop integration
      targets.xresources = {
        enable = true;
        colors.override = {
          color8 = "#8b888f";
        };
      };

      # Disabled targets (external configs or conflicting)
      targets.neovim.enable = false;
      targets.firefox.enable = false;
      targets.yazi.enable = false;
    };
  };
}
