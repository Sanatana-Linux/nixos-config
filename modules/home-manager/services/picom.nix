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

        # ---- Backend: GLX for NVIDIA power management ----
        # GLX is NVIDIA's mature X11 rendering path with proper GPU power
        # state management — allows the dGPU to reach P8 at idle. EGL on
        # NVIDIA pins clocks at P0 (~30W) even at idle desktop.
        # xrender does NOT support dual_kawase blur — use GLX or EGL for blur.
        backend = "glx";

        # ---- Performance-critical: enable damage tracking ----
        # use-damage = false forces picom to redraw the entire screen every frame.
        # Setting it to true (which is now the default in picom-pijulius) means only
        # changed regions get repainted, dramatically reducing CPU/GPU load.
        use-damage = true;

        # ---- VSync — off to work around NVIDIA vblank duplicate bug ----
        # On NVIDIA PRIME sync laptops, the driver generates duplicate vblank
        # events (see dmesg/journactl for "Duplicate vblank event"). This causes
        # picom to re-composite each frame twice — doubling GPU compositing work
        # and keeping the dGPU pinned at P0 with ~30W draw. PRIME sync already
        # provides tear-free output at the hardware level, so vsync in picom is
        # redundant and only adds GPU load.
        vsync = false;

        # ---- Unredirect fullscreen windows ----
        # When a window goes fullscreen (e.g. games, video players), picom can skip
        # compositing it entirely, reducing overhead significantly.
        unredirect-fullscreen = true;

        # ---- Corner radius — awesome handles this natively ----
        # Picom corner-radius is redundant on awesomewm and adds per-frame
        # GPU compositing work. Disabled to reduce dGPU idle draw.

        # ---- Shadows  ----
        shadow = true;
        shadow-radius = 8;
        shadow-opacity = 0.5;
        shadow-offset-x = 8;
        shadow-offset-y = 8;

        # ---- Opacity ----
        fading = true;
        inactive-opacity = 0.90;
        frame-opacity = 0.9;
        inactive-opacity-override = false;
        active-opacity = 1.0;
        focus-exclude = [];

        opacity-rule = [
          "100:class_g = 'i3lock'"
          "100:class_g = 'firefox'"
          "100:class_g = 'firefox-nightly'"
          "60:class_g = 'Dunst'"
          "85:class_g = 'kitty' && focused"
          "80:class_g = 'kitty' && !focused"
          "95:class_g = 'awesome'"
        ];

        # ---- Blur (keep functionality, reduce overhead) ----
        blur = {
          method = "dual_kawase";
          strength = 8;
        };

        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-client-opacity = true;
        detect-transient = true;
        detect-client-leader = true;

        shadow-exclude = [
          "class_g = 'firefox'"
          "class_g = 'firefox-nightly'"
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
          "_GTK_FRAME_EXTENTS@"
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
            blur = true;
          };
          tooltip = {
            fade = true;
            shadow = true;
            opacity = 0.98;
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
