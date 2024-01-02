{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.sway;
  sway-overlay = final: prev: {
    wlay = pkgs.unstable.wlay;
  };
in {
  options.tlh.sway = {
    enable = mkEnableOption "activate sway";
  };

  config = mkIf cfg.enable {
    nixpkgs = {overlays = [sway-overlay];};

    # make sure wayland quirks are set and KDE is being disabled
    tlh = {
      wayland.enable = true;
      kde.enable = mkForce false;
    };

    home-manager.users."${config.tlh.home-manager.username}" = {
      imports = [{nixpkgs.overlays = [sway-overlay];}];
      # enable sway related home manager modules
      tlh.programs = {
        sway.enable = true;
        swaylock.enable = true;
      };
    };
  };
}
