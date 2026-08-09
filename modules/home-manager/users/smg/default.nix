{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
  ];

  modules = {
    stylix.enable = true;
    desktop = {
      enable = true;
    };
    packages = {
      essential.enable = true;
      permitted-insecure-packages.enable = true;
    };
    shell = {
      zsh.enable = true;
      starship.enable = true;
      cli-tools.enable = true;
      scripts.enable = true;
    };
    core = {
      environment.enable = true;
      home.enable = true;
      nix.enable = true;
      xdg.enable = true;
    };
    programs = {
      firefox.enable = true;
      yazi.enable = true;
      kitty.enable = true;
      neovim.enable = true;
    };
    services = {
      picom = {
        enable = true;
      };
      xscreensaver.enable = true;
      polkit-agent.enable = true;
    };
  };

  services.picom.settings = {
    shadow = lib.mkForce false;
    rounded-corners-exclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
      "_GTK_FRAME_EXTENTS@"
    ];
    blur-background-exclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
      "_GTK_FRAME_EXTENTS@"
    ];

    # ── Menu lag fix ────────────────────────────────────────────────
    # GIMP 3 (and other GTK apps) open File/menu as popup/dropdown/tooltip
    # windows. With fading + opacity animation enabled, every menu open
    # triggers a multi-frame re-composite on the NVIDIA dGPU (PRIME sync +
    # GLX), causing visible stutter on "basic" actions like opening a menu.
    # Render these window types directly: no fade, no shadow, full opacity,
    # no blur. Menus appear instantly.
    wintypes = {
      popup_menu = {
        fade = lib.mkForce false;
        shadow = lib.mkForce false;
        opacity = lib.mkForce 1.0;
        blur = lib.mkForce false;
      };
      dropdown_menu = {
        fade = lib.mkForce false;
        shadow = lib.mkForce false;
        opacity = lib.mkForce 1.0;
        blur = lib.mkForce false;
      };
      tooltip = {
        fade = lib.mkForce false;
        shadow = lib.mkForce false;
        opacity = lib.mkForce 1.0;
        blur = lib.mkForce false;
      };
      utility = {
        fade = lib.mkForce false;
        shadow = lib.mkForce false;
        opacity = lib.mkForce 1.0;
        blur = lib.mkForce false;
      };
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
    };
  };

  # Required by home-manager
  home.stateVersion = "24.11";
  home.username = "smg";
  home.homeDirectory = "/home/smg";
  programs.home-manager.enable = true;

  # Force kitty installation
  home.packages = [pkgs.kitty];
  programs.kitty.enable = true;

  # Increase GStreamer V4L2 buffer count — default is 4, which causes
  # stuttering on high-res webcams. 16 gives the pipeline enough runway.
  home.sessionVariables = {
    GST_V4L2_DEFAULT_BUFFER_COUNT = "16";
  };

  # Disable xfwm4 compositor at session startup.
  # Async with delay to let xfce4-session and xfconfd fully initialize first.
  # xfwm4's built-in compositor redirects windows offscreen, which breaks
  # GL-CL interop (cl_khr_gl_sharing) that GIMP/GEGL and Shotcut/MLT need
  # for GPU compute detection — they silently fall back to CPU when redirected
  # GL contexts don't support sharing. Also avoids dual-compositor conflicts.
  xsession.initExtra = ''
    (sleep 3 && ${pkgs.xfce.xfconf}/bin/xfconf-query \
      -c xfwm4 -p /general/use_compositing -s false 2>/dev/null) &
  '';
}
