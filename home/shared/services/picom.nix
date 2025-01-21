{
  colors,
  pkgs,
  outputs,
  ...
}: {
  services.picom = {
    enable = true;
    package = pkgs.picom;
    activeOpacity = 0.99;
    backend = "glx";
    fade = true;
    fadeDelta = 3;
    fadeSteps = [0.3 0.3];

    opacityRules = [
      "93:class_g = 'kitty' && !focused"
      "93:class_g = 'ghostty' && !focused"
      "98:class_g = 'ghostty' && focused"
      "98:class_g = 'kitty' && focused"
      "99:class_g = 'awesome'"
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
      corner-radius = 0; # awesome handles this better
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
        #   method = "dual_kawase";
        # strength = 12.0;
        # deviation = 3.0;
        method = "gaussian";
        size = 20;
        deviation = 15;
        # kernel = "11x11gaussian";
      };

      blur-background = true;
      blur-background-frame = true;
      blur-background-fixed = true;
      xrender-sync-fence = true;
      use-damage = true;
      unredir-if-possible = false;
      vsync = true;
    };
  };
}
