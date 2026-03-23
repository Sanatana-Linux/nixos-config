{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.openrgb;
  isX11 = config.modules.desktop.xorg.enable || config.modules.desktop.awesomewm.enable || config.modules.desktop.xfce.enable;
in {
  options.modules.hardware.openrgb = {
    enable = mkEnableOption "OpenRGB hardware lighting control and server";

    motherboard = mkOption {
      type = types.str;
      default = "intel";
      description = "The motherboard driver to use for OpenRGB (e.g., 'intel' or 'asus')";
    };

    serverPort = mkOption {
      type = types.int;
      default = 9999;
      description = "The network port for the OpenRGB SDK server";
    };

    package = mkOption {
      type = types.package;
      default =
        if isX11
        then
          pkgs.symlinkJoin {
            name = "openrgb-wrapped";
            paths = [pkgs.openrgb-with-all-plugins];
            buildInputs = [pkgs.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/openrgb \
                --set QT_QPA_PLATFORM xcb
            '';
            meta.mainProgram = "openrgb";
          }
        else pkgs.openrgb-with-all-plugins;
      description = "The OpenRGB package to use (wrapped for X11 xcb backend if needed)";
    };

    extraSystemPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to install system-wide, often includes custom tools like 'toggleRGB'";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.i2c.enable = true;

      users.groups.i2c = {};

      services.udev.packages = [pkgs.openrgb];

      services.hardware.openrgb = {
        enable = true;
        package = cfg.package;
        motherboard = cfg.motherboard;
        server.port = cfg.serverPort;
      };

      environment.systemPackages = with pkgs; [cfg.package i2c-tools] ++ cfg.extraSystemPackages;

      boot.kernelModules = ["i2c-dev"];
    }
    (mkIf (cfg.motherboard == "intel") {
      boot.kernelModules = ["i2c-i801"];
    })
    (mkIf (cfg.motherboard == "amd") {
      boot.kernelModules = ["i2c-piix4"];
    })
  ]);
}
