{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.udev;
in {
  options.modules.hardware.udev = {
    enable = mkEnableOption "udev services with hardware packages";

    packages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        gnome-settings-daemon
        xsettingsd
        xfce4-settings
        logitech-udev-rules
        via
        qmk-udev-rules
        libsigrok
      ];
      description = "Additional udev packages to install";
    };

    udisks2 = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable udisks2 service";
      };

      mountOptions = mkOption {
        type = types.str;
        default = "noatime";
        description = "Default mount options";
      };
    };

    supportedFilesystems = mkOption {
      type = with types; listOf str;
      default = ["ntfs"];
      description = "Additional supported filesystems";
    };
  };

  config = mkIf cfg.enable {
    services = {
      udev = {
        enable = true;
        packages = cfg.packages;
      };

      udisks2 = mkIf cfg.udisks2.enable {
        enable = true;
        settings = {
          "mount_options.conf" = {
            defaults = {
              defaults = cfg.udisks2.mountOptions;
            };
          };
        };
      };
    };

    boot.supportedFilesystems = cfg.supportedFilesystems;
  };
}
