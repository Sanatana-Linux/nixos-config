{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.ghostty;
in {
  options.modules.programs.ghostty = {
    enable = mkEnableOption "Ghostty terminal emulator";

    fontSize = mkOption {
      type = types.int;
      default = 12;
      description = "Font size for Ghostty terminal";
    };

    fontFamily = mkOption {
      type = types.str;
      default = "OperatorMono Nerd Font";
      description = "Font family for Ghostty terminal";
    };

    backgroundOpacity = mkOption {
      type = types.float;
      default = 0.65;
      description = "Background opacity (0.0 to 1.0)";
    };

    windowPadding = mkOption {
      type = types.int;
      default = 5;
      description = "Window padding width";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      settings = {
        font-size = cfg.fontSize;
        font-family = cfg.fontFamily;
        background-opacity = cfg.backgroundOpacity;
        window-padding-x = cfg.windowPadding;
        window-padding-y = cfg.windowPadding;

        cursor-style = "block";
        cursor-style-blink = false;

        shell-integration = "zsh";
      };
    };
  };
}
