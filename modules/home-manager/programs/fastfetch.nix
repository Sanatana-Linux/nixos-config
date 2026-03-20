{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.programs.fastfetch;
in
{
  options.modules.programs.fastfetch = {
    enable = mkEnableOption "Fastfetch system information tool";
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "${config.home.homeDirectory}/.config/fastfetch/sanatana.txt";
          type = "ascii";
        };
        
        display = {
          separator = " ";
          key = {
            width = 15;
          };
        };

        modules = [
          "title"
          "separator"
          "os"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "de"
          "wm"
          "theme"
          "icons"
          "font"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "resolution"
          "memory"
          "disk"
          "localip"
          "break"
          "colors"
        ];
      };
    };

    # Copy custom Sanatana Linux ASCII art to user's fastfetch config directory
    home.file.".config/fastfetch/sanatana.txt".source = "${./sanatana.txt}";
    
    # Copy custom Nix logo as alternative
    home.file.".config/fastfetch/nix.png".source = "${./nix.png}";
  };
}
