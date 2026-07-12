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
      };

      keybindings = {
        "shift+alt+up" = "move_window up";
        "shift+alt+left" = "move_window left";
        "shift+alt+right" = "move_window right";
        "shift+alt+down" = "move_window down";

        "kitty_mod+left" = "neighboring_window left";
        "kitty_mod+right" = "neighboring_window right";
        "kitty_mod+up" = "neighboring_window up";
        "kitty_mod+down" = "neighboring_window down";

        "alt+t" = "new_tab_with_cwd";
        "alt+v" = "launch --cwd=current --location=vsplit";
        "alt+h" = "launch --cwd=current --location=hsplit";
        "alt+n" = "next_tab";
        "alt+b" = "previous_tab";
        "alt+q" = "close_tab";
        "alt+shift+q" = "close_window";
        "alt+," = "move_tab_backward";
        "alt+." = "move_tab_forward";

        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";

        # clear the terminal screen
        "alt+k" = "combine : clear_terminal scrollback active";

        "kitty_mod+equal" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
        "kitty_mod+0" = "change_font_size all 0";
      };

      # Tab splitting keybindings
      extraConfig = ''
        # https://www.reddit.com/r/KittyTerminal/comments/1ijwbo1/comment/mbsof9t/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        enabled_layouts splits
        # Vertical split: kitty_mod + /
        map ctrl+shift+/ launch --location vsplit

        # Horizontal split: kitty_mod + -
        map ctrl+shift+- launch --location hsplit
      '';

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
