{...}: {
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    shadow = false;
    shadowOffsets = [(-1) (-1)];

    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    fade = true;
    fadeDelta = 3;
    fadeSteps = [0.06 0.06];
    fadeExclude = [];

    activeOpacity = "0.999";
    inactiveOpacity = "0.999";
    menuOpacity = "0.999";
    opacityRules = ["70:class_g = 'splash'"];

    wintypes = {
      tooltip = {
        fade = true;
        shadow = true;
        focus = true;
        full-shadow = true;
      };
      dock = {shadow = false;};
      dnd = {shadow = false;};
      popup_menu = {opacity = 0.99999;};
      dropdown_menu = {opacity = 0.99;};
      desktop = {full-shadow = false;};
      normal = {full-shadow = false;};
    };

    settings = {
      shadow-radius = 40;
      shadow-color = "#000000";
      shadow-ignore-shaped = false;
      shadow-opacity = ".55";
      shadow-offset-x = "-40";
      shadow-offset-y = "-20";

      focus-exclude = ["class_g = 'Peek'" "class_g = 'Cairo-clock'"];

      corner-radius = 12;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_MAXIMIZED_VERT'"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_MAXIMIZED_HORZ'"
      ];

      blur-method = "dual_kawase";
      blur-kernel = "11x11gaussian";
      blur-deviation = "1.0";
      blur-strength = "2";
      blur-background = false;
      blur-background-frame = true;
      blur-background-fixed = true;
      blur-background-exclude = [
        "class_g = 'slop'"
        "class_g = 'firefox'"
        "_GTK_FRAME_EXTENTS@:c"
        "window_type = 'desktop'"
        "window_type = 'menu'"
      ];
      # Opacity
      inactive-opacity = 0.99999;
      frame-opacity = 0.99999;
      inactive-opacity-override = false;
      active-opacity = 0.99999;
      inactive-dim = 0.0;

      mark-ovredir-focused = true;
      glx-no-stencil = true;
      use-damage = true;
      mark-wmwin-focused = true;
      mark-oredir-focused = true;
      detect-client-opacity = true;
      detect-rounded-corners = true;
      detect-transient = true;
      detect-client-leader = true;
      resize-damage = 1;
      transparent-clipping = true;

      log-level = "warn";
    };
  };
}
