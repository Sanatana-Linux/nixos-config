{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.printer;
in {
  options.modules.printer = {
    enable = mkEnableOption "printer support with CUPS and drivers";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = [pkgs.brlaser];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    users.users.smg.extraGroups = ["lp" "scanner"];
  };
}
