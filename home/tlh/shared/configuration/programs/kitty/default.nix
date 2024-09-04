{
  pkgs,
  outputs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    # TODO implement color theme and add the below
    #extraConfig = import ./settings.nix;
    settings = {
      window_padding_width = 5;
      confirm_os_window_close = 0;
      focus_follows_mouse = "yes";
      cursor_shape = "block";
      copy_on_select = "yes";
      hide_window_decorations = "yes";
      update_check_interval = 0;
      visual_bell_duration = 0;
      window_alert_on_bell = "no";
      cursor_underline_thickness = "0.5";
      background_opacity = "0.65";
      tab_bar_style = "separator";
      tab_separator = " ┇";
      tab_bar_margin_width = "3";
      tab_bar_margin_height = "3";
      tab_bar_edge = "top";
      enable_audio_bell = "no";
    };
    font = {
      size = 10;
      name = "Agave Nerd Font Mono Bold";
    };
  };
}
