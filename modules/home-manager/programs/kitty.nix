{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.kitty;
in {
  options.modules.programs.kitty = {
    enable = mkEnableOption "Kitty terminal emulator";

    fontSize = mkOption {
      type = types.int;
      default = 12;
      description = "Font size for Kitty terminal";
    };

    fontFamily = mkOption {
      type = types.str;
      default = "Mplus Code 60";
      description = "Font family for Kitty terminal";
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
    programs.kitty = {
      enable = true;

    settings = {
      # Window settings
      window_padding_width = cfg.windowPadding;
      confirm_os_window_close = -1;
      focus_follows_mouse = "yes";

      # Cursor and selection
      cursor_shape = "block";
      copy_on_select = "yes";
      cursor_underline_thickness = "0.5";

      # Visual settings - background_opacity managed by Stylix
      sync_to_monitor = "yes";
      # background_opacity = toString cfg.backgroundOpacity;

      # Audio/visual bells
      visual_bell_duration = 0;
      window_alert_on_bell = "no";
      enable_audio_bell = "no";

      # Tab bar
      tab_bar_style = "separator";
      tab_separator = " ┇";
      tab_bar_margin_width = "3";
      tab_bar_margin_height = "3";
      tab_bar_edge = "top";

      # Color override for better readability - use lighter gray for dim text
      # Stylix uses color8 (bright black) for some text which is too dark (#69676c)
      # Override with lighter base04 (#8b888f) for better readability
      color8 = "#8b888f";  # base04 - lighter gray for dim text
    };

    # Font configuration disabled - managed by Stylix for consistency
    # font = {
    #   size = cfg.fontSize;
    #   name = cfg.fontFamily;
    # };

      shellIntegration = {
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
