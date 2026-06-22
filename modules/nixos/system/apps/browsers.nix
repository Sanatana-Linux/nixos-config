{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.modules.system.apps.browsers;
in {
  options.modules.system.apps.browsers = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Web browser packages (Chromium, Epiphany, Tor Browser)";
    };
    chromium = mkOption {
      type = types.bool;
      default = true;
      description = "Chromium web browser";
    };
    epiphany = mkOption {
      type = types.bool;
      default = true;
      description = "GNOME Web (Epiphany) browser";
    };
    torBrowser = mkOption {
      type = types.bool;
      default = true;
      description = "Tor Browser";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      optionals cfg.chromium [ chromium ]
      ++ optionals cfg.epiphany [ epiphany ]
      ++ optionals cfg.torBrowser [ tor-browser ];
  };
}
