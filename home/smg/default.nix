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

  services.picom.settings.shadow = lib.mkForce false;

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
}
