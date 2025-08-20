{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}:
with builtins;
with lib; let
  cfg = config.modules.desktop.newm;
in {
  options.modules.desktop.newm.enable = true;

  environment.systemPackages = with pkgs; [newm];
  services.xserver.displayManager.sessionPackages = with pkgs; [newm];
}
