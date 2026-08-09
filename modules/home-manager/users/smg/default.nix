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
      # Picom disabled on matangi — its GLX compositing (fade/opacity/blur on
      # menu windows) caused GIMP 3 menu lag on the NVIDIA PRIME-sync stack.
      # xfwm4 compositing is also disabled below, so windows render directly.
      picom = {
        enable = false;
      };
      xscreensaver.enable = true;
      polkit-agent.enable = true;
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
