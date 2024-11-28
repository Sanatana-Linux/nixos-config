{
  colors,
  pkgs,
  outputs,
  ...
}: {
  services.picom = {
    enable = true;
    package = pkgs.picom-next;
    activeOpacity = 1.0;
    backend = "glx";
    fade = true;
    fadeDelta = 3;
    fadeSteps = [0.03 0.03];

    opacityRules = [
      "85:class_g = 'kitty' && !focused"
      "93:class_g = 'kitty' && focused"
      "85:class_g = 'ncmpcpppad' && !focused"
      "93:class_g = 'ncmpcpppad' && focused"
      "85:class_g = 'neofetchpad' && !focused"
      "93:class_g = 'neofetchpad' && focused"
      "93:class_g = 'awesome'"
    ];
    settings = {
      animations = true;
      animation-stiffness = 300.0;
      animation-dampening = 22.0;
      animation-clamping = true;
      animation-mass = 1;
      animation-for-open-window = "slide-up";
      animation-for-menu-window = "slide-down";
      animation-for-transient-window = "slide-down";
      animation-for-prev-tag = "zoom";
      enable-fading-prev-tag = true;
      animation-for-next-tag = "zoom";
      enable-fading-next-tag = true;
      corner-radius = 12;
      shadow = true;
      shadow-radius = 15;
      shadow-offset-x = -15;
      shadow-offset-y = -15;
      shadow-exclude = [
        "window_type = 'desktop'"
        "class_g ~= 'awesome'"
        "class_g ~= 'slop'"
      ];
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "name ~= 'slop'"
        "class_i ~= 'slop'"
      ];
      blur-background-exclude = [
        "class_g ~= 'slop'"
        "class_g ~= 'maim'"
        "class_g ~= 'Shutter'"
        "window_type = 'desktop'"
        "class_g ~= 'discord'"
        "class_g ~= 'firefox'"
        "class_i ~= 'slop'"
        "class_g ~= 'firefox'"
        "class_i ~= 'Spotify'"
        "name ~= 'slop'"
        "name ~= 'Shutter'"
        "name ~= 'maim'"
      ];
      blur = {
        method = "dual_kawase";
        strength = 5.0;
        deviation = 1.0;

        kernel = "11x11gaussian";
      };

      blur-background = false;
      blur-background-frame = true;
      blur-background-fixed = true;
      xrender-sync-fence = true;
      use-damage = true;
      unredir-if-possible = false;
      vsync = true;
    };
  };
}
