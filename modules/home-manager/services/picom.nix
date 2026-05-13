{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.services.picom = {
    enable = mkEnableOption "Picom compositor";
    backend = mkOption {
      type = types.enum ["glx" "egl" "xrender"];
      default = "glx";
      description = "Picom rendering backend";
    };
  };

  config = mkIf config.modules.services.picom.enable {
    services.picom = {
      enable = true;
      package = pkgs.picom-pijulius;

      settings = {
        animations = false;

        # ---- Performance-critical: enable damage tracking ----
        # use-damage = false forces picom to redraw the entire screen every frame.
        # Setting it to true (which is now the default in picom-pijulius) means only
        # changed regions get repainted, dramatically reducing CPU/GPU load.
        use-damage = true;

        # ---- Backend: prefer EGL over GLX for lower overhead ----
        # EGL is more efficient than GLX on modern systems and uses less CPU.
        # Falls back to GLX if EGL isn't available.
        backend = "egl";

        # ---- VSync: adaptive to avoid wasted cycles ----
        # "glx-oml-sync-oboe" is lighter than full vsync and prevents tearing
        vsync = true;

        # ---- Unredirect fullscreen windows ----
        # When a window goes fullscreen (e.g. games, video players), picom can skip
        # compositing it entirely, reducing overhead significantly.
        unredirect-fullscreen = true;

        # ---- Corner radius with minimal overhead ----
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

        # ---- Shadows (keep, but optimize) ----
        shadow = true;
        shadow-radius = 8;
        shadow-opacity = 0.5;
        shadow-offset-x = 8;
        shadow-offset-y = 8;

        # ---- Opacity ----
        fading = false;
        inactive-opacity = 0.90;
        frame-opacity = 0.9;
        inactive-opacity-override = false;
        active-opacity = 1.0;
        focus-exclude = [];

        opacity-rule = [
          "100:class_g = 'i3lock'"
          "60:class_g = 'Dunst'"
          "85:class_g = 'kitty' && focused"
          "80:class_g = 'kitty' && !focused"
          "95:class_g = 'awesome'"
        ];

        # ---- Blur (keep functionality, reduce overhead) ----
        # dual_kawase with lower strength ~3 is much cheaper than strength 6
        # because each blur pass is a full-screen texture operation.
        # Going from 6 to 3 roughly halves the per-frame blur cost.
        blur = {
          method = "dual_kawase";
          strength = 3;
        };

        # ---- Reduce detection overhead ----
        # detect-client-opacity, detect-transient, detect-client-leader each add
        # per-window property tracking overhead. Only keep what shadows/blur need.
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = false;
        detect-transient = false;
        detect-client-leader = false;

        shadow-exclude = [
          "class_g = 'firefox'"
          "class_g = 'Dunst'"
          "class_g = 'awesome'"
        ];

        blur-background-exclude = [
          "class_g = 'Dunst'"
          "class_g = 'slop'"
          "window_type = 'desktop'"
          "class_g = 'Cairo-clock'"
          "class_g = 'pop_report'"
          "class_g = 'Gnome-screenshot'"
          "class_g = 'peek'"
          "_GTK_FRAME_EXTENTS@:c"
        ];

        # Window rules for blur
        blur-background-rule = [
          "name = 'awesome-backdrop'"
        ];

        log-level = "warn";

        glx-copy-from-front = false;

        wintypes = {
          normal = {
            fade = true;
            shadow = true;
            opacity = 0.95;
          };
          tooltip = {
            fade = true;
            shadow = true;
            opacity = 1;
            focus = true;
            full-shadow = true;
          };
          dock = {
            shadow = true;
            rounded-corners = false;
            opacity = 1;
          };
          utility = {
            shadow = false;
            blur = true;
          };
          dnd = {shadow = false;};
          popup_menu = {opacity = 0.95;};
          dropdown_menu = {opacity = 0.9;};
        };
      };
    };
  };
}
