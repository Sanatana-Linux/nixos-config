{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./desktop.nix
    ../../modules/home-manager/default.nix
    ../../modules/home-manager/shell/home/bin/default.nix
  ];

  modules = {
    packages.essential.enable = true;
    shell = {
      home.enable = true;
      starship.enable = true;
      x.enable = true;
    };
    programs = {
      firefox = {
        enable = true;
        higgs-boson = false; # strictly disabled for smg
      };
      yazi.enable = true;
      kitty.enable = true;
    };
    services = {
      picom = {
        enable = true;
      };
      xscreensaver.enable = true;
    };
  };

  services.picom.settings = {
    shadow = lib.mkForce false;
    rounded-corners-exclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    blur-background-exclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
      "_GTK_FRAME_EXTENTS@:c"
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

  # Force kitty installation
  home.packages = [ pkgs.kitty ];
  programs.kitty.enable = true;
}
