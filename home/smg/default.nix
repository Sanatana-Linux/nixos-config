{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/home-manager/default.nix
  ];

  modules = {
    desktop = {
      gtk.enable = true; # Use the consolidated gtk module instead of orchisCosmic
    };
    packages.essential.enable = true;
    shell = {
      home.enable = true;
      environment.enable = true;
      zsh.enable = true;
      starship.enable = true;
      cli-tools.enable = true;
      nix.enable = true;
      xdg.enable = true;
      scripts.enable = true;
    };
    programs = {
      firefox.enable = true;
      higgs-boson-firefox.enable = false;
      yazi.enable = true;
      kitty.enable = true;
    };
    services = {
      picom = {
        enable = true;
      };
      xscreensaver.enable = true;
      # Polkit authentication agent for GUI dialogs (mounting encrypted drives, etc.)
      polkit-agent.enable = true;
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
  home.packages = [pkgs.kitty];
  programs.kitty.enable = true;
}
