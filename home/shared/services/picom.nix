{
  lib,
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    package = pkgs.picom;

    settings = {
      animations = true;
      animation-stiffness = 300.0;
      animation-dampening = 35.0;
      animation-clamping = false;
      animation-mass = 1;
      animation-for-workspace-switch-in = "auto";
      animation-for-workspace-switch-out = "auto";
      animation-for-open-window = "slide-down";
      animation-for-menu-window = "none";
      animation-for-transient-window = "slide-down";
      corner-radius = 12;
      rounded-corners-exclude = [
        "class_i = 'polybar'"
        "class_g = 'i3lock'"
        "class_g = 'awesome'"
        "class_g = 'dock'"
      ];
      round-borders = 3;
      round-borders-exclude = [];
      round-borders-rule = [];
      shadow = true;
      shadow-radius = 8;
      shadow-opacity = 0.4;
      shadow-offset-x = -8;
      shadow-offset-y = -8;
      fading = false;
      inactive-opacity = 0.95;
      frame-opacity = 0.9;
      inactive-opacity-override = false;
      active-opacity = 1.0;
      focus-exclude = [
      ];

      opacity-rule = [
        "100:class_g = 'i3lock'"
        "60:class_g = 'Dunst'"
        "95:class_g = 'kitty' && focused"
        "90:class_g = 'kitty' && !focused"
        "100:class_g = 'awesome'"
      ];

      #  blur-kern = "3x3box";
      blur = {
        method = "dual_kawase";
        strength = 6;
        #background = false;
        #background-frame = false;
        #background-fixed = false;
        # kern = "3x3box";
      };

      shadow-exclude = [
        "class_g = 'firefox-nightly'"
        "class_g = 'Dunst'"
        "class_g = 'awesome'"
      ];

      blur-background-exclude = [
        "class_g = 'Dunst'"
        "class_g = 'slop'"
        # "class_g = 'awesome'"
        # "class_g = 'Awesome'"
        # "window_type = 'dock'"
        # "window_type = 'popup_menu'"
        # "name = 'control_panel'"
        "window_type = 'desktop'"
        "class_g = 'Cairo-clock'"
        "class_g = 'pop_report'"
        "class_g = 'Gnome-screenshot'"
      ];

      backend = "egl";
      vsync = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
      use-damage = true;
      log-level = "info";

      wintypes = {
        normal = {
          fade = true;
          shadow = true;
        };
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 1;
          focus = true;
          full-shadow = false;
        };
        dock = {
          shadow = true;
          rounded-corners = false;
          opacity = 1.0;
        };
        dnd = {shadow = false;};
        popup_menu = {opacity = 1.0;};
        dropdown_menu = {opacity = 1.0;};
      };
    };
  };
}
