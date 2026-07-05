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
    stylix.enable = false;
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

  # Explicitly disable Stylix at home-manager level — NixOS-level stylix
  # stays enabled to keep the Stylix home-manager option available, but
  # smg gets no theming, no Firefox profile warnings, etc.
  stylix.enable = false;

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
}
