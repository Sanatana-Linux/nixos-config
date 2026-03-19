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

      targets.kitty.enable = true;
      targets.firefox.enable = false;
      targets.zathura.enable = true;
      targets.vscode.enable = true;
      targets.fish.enable = false;
      targets.bat.enable = true;
      targets.feh.enable = true;
      targets.zed.enable = false;
    };
  };
}
