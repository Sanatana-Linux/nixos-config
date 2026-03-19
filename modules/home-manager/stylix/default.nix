{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.stylix;
in
{
  options.modules.stylix = {
    enable = mkEnableOption "Stylix theming at Home Manager level";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;

      # Terminal emulators
      targets.kitty.enable = true;
      targets.ghostty.enable = true;

      # Shell and CLI tools
      targets.bat.enable = true;
      targets.fzf.enable = true;
      targets.tmux.enable = true;
      targets.vivid.enable = true;

      # GUI applications
      targets.nixcord.enable = true;
      targets.feh.enable = true;
      targets.sioyek.enable = true;
      targets.zathura.enable = true;

      # Development tools
      targets.vscode.enable = true;
      targets.opencode.enable = true;

      # Desktop integration
      targets.xresources.enable = true;

      # Disabled targets (external configs or conflicting)
      targets.neovim.enable = false;
      targets.firefox.enable = false;
      targets.fish.enable = false;
      targets.zed.enable = false;
      targets.yazi.enable = false;
    };
  };
}
