{ pkgs }:

{
  programs.kitty = {
    enable = true;
    extraConfig = import ./settings.nix;
    settings = {
      window_padding_width = 5;
      confirm_os_window_close = 0;
      cursor_shape = "block";
      cursor_underline_thickness = "0.5";
      background_opacity = "0.65";
      tab_bar_style = "separator";
      tab_separator = " ┇";
      tab_bar_margin_width = "3";
      tab_bar_margin_height = "3";
      tab_bar_edge = "top";
    };
    font = {
      size = 10;
      name = "mplus Nerd Font Mono medium ";
    };
  };
}
