{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.openrgb;
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
      default = pkgs.symlinkJoin {
        name = "openrgb-wrapped";
        paths = [pkgs.openrgb-with-all-plugins];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/openrgb \
            --set QT_QPA_PLATFORM xcb
        '';
        meta.mainProgram = "openrgb";
      };
      description = "The OpenRGB package to use, typically with all plugins";
    };

    extraSystemPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to install system-wide, often includes custom tools like 'toggleRGB'";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Enable I2C hardware support
      hardware.i2c.enable = true;

      # Create i2c group for user access
      users.groups.i2c = {};

      # Udev rules are needed so OpenRGB can access hardware without root
      services.udev.packages = [pkgs.openrgb];

      # Configure the OpenRGB service
      services.hardware.openrgb = {
        enable = true;
        package = cfg.package;
        motherboard = cfg.motherboard;
        server.port = cfg.serverPort;
      };

      # Install the package and extra system packages
      environment.systemPackages = with pkgs; [cfg.package i2c-tools] ++ cfg.extraSystemPackages;

      # Basic kernel module for I2C access
      boot.kernelModules = ["i2c-dev"]; # Userspace I2C interface
    }
    (mkIf (cfg.motherboard == "intel") {
      boot.kernelModules = ["i2c-i801"]; # Intel SMBus controller driver
    })
    (mkIf (cfg.motherboard == "amd") {
      boot.kernelModules = ["i2c-piix4"]; # AMD SMBus controller driver
    })
  ]);
}
