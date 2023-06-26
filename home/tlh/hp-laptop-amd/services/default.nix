{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    shadow = true;
    shadowOffsets = [(-40) (-20)];
    shadowOpacity = 0.55;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "_PICOM_SHADOW@:32c = 0"
      "_NET_WM_WINDOW_TYPE:a = '_NET_WM_WINDOW_TYPE_NOTIFICATION'"
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      "class_g = 'Conky'"
      "class_g = 'slop'"
      "window_type = 'combo'"
      "window_type = 'desktop'"
      "window_type = 'dnd'"
      "window_type = 'dock'"
      "window_type = 'dropdown_menu'"
      "window_type = 'menu'"
      "window_type = 'notification'"
      "window_type = 'popup_menu'"
      "window_type = 'splash'"
      "window_type = 'toolbar'"
      "window_type = 'utility'"
    ];

    fade = true;
    fadeDelta = 10;
    fadeSteps = [0.03 0.03];
    fadeExclude = [
      "window_type = 'combo'"
      "window_type = 'desktop'"
      "window_type = 'dock'"
      "window_type = 'dnd'"
      "window_type = 'notification'"
      "window_type = 'toolbar'"
      "window_type = 'unknown'"
      "window_type = 'utility'"
      "_PICOM_FADE@:32c = 0"
    ];

    activeOpacity = 0.95;
    inactiveOpacity = 0.95;
    menuOpacity = 0.95;
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
      popup_menu = {opacity = 1;};
      dropdown_menu = {opacity = 1;};
      desktop = {full-shadow = false;};
      normal = {full-shadow = false;};
    };

    settings = {
           animations = true;
      #change animation speed of windows in current tag e.g open window in current tag
      animation-stiffness-in-tag = 125;
      #change animation speed of windows when tag changes
      animation-stiffness-tag-change = 90.0;
      animation-window-mass = 0.4;
      animation-dampening = 15;
      animation-clamping = true;
      #open windows
      animation-for-open-window = "zoom";
      #minimize or close windows
      animation-for-unmap-window = "squeeze";
      #popup windows
      animation-for-transient-window = "slide-up"; #available options: slide-up, slide-down, slide-left, slide-right, squeeze, squeeze-bottom, zoom
      #set animation for windows being transitioned out while changings tags
      animation-for-prev-tag = "minimize";
      #enables fading for windows being transitioned out while changings tags
      enable-fading-prev-tag = true;
      #set animation for windows being transitioned in while changings tags
      animation-for-next-tag = "slide-in-center";
      #enables fading for windows being transitioned in while changings tags
      enable-fading-next-tag = true;




      shadow-radius = 40;
      shadow-color = "#000000";
      shadow-ignore-shaped = false;

      frame-opacity = 1.0;
      inactive-opacity-override = false;
      focus-exclude = [
        "class_g = 'Cairo-clock'"
        "class_g = 'Peek'"
        "class_g = 'slop'"
        "window_type = 'combo'"
        "window_type = 'desktop'"
        "window_type = 'dialog'"
        "window_type = 'dnd'"
        "window_type = 'dock'"
        "window_type = 'dropdown_menu'"
        "window_type = 'menu'"
        "window_type = 'tooltip'"
        "window_type = 'unknown'"
        "window_type = 'utility'"
      ];

      corner-radius = 12;
      rounded-corners-exclude = [
        "_PICOM_SHADOW@:32c = 0"
        "window_type = 'dock'"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_MAXIMIZED_VERT'"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_MAXIMIZED_HORZ'"
      ];

      blur-method = "dual_kawase";
      blur-kernel = "15x15gaussian";
      blur-deviation = 2.0;
      blur-strength = 12;
      blur-background = true;
      blur-background-frame = true;
      blur-background-fixed = true;
      blur-background-exclude = [
        "_GTK_FRAME_EXTENTS@:c"
        "window_type = 'desktop'"
        "class_g = 'slop'"
        "class_g = 'maim'"
        "class_g = 'scrot'"
        "window_type = 'tooltip'"
        "window_type = 'unknown'"
        "window_type = 'menu'"
        "window_type = 'utility'"
      ];

      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
      glx-no-rebind-pixmap = true;
      unredir-if-possible = true;       
      glx-no-stencil = true;
      use-damage = true;
      transparent-clipping = false;
      log-level = "warn";
    };
  };
}
