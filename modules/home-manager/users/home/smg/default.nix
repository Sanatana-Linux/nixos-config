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
}
