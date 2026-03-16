{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.encrypted-storage;
in {
  options.modules.hardware.encrypted-storage = {
    enable = mkEnableOption "Support for encrypted storage devices (LUKS, cryptsetup)";

    enableLvm = mkOption {
      type = types.bool;
      default = true;
      description = "Enable LVM2 support for encrypted volumes that use LVM";
    };

    autoUnlock = mkOption {
      type = types.bool;
      default = false;
      description = "Enable automatic unlocking of encrypted devices with cached credentials (requires keyring integration)";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      initrd = {
        kernelModules = [
          "dm_crypt"
          "dm_mod"
        ];
      };

      kernelModules = [
        "dm_crypt"
        "dm_mod"
      ];
    };

    environment.systemPackages = with pkgs;
      [
        cryptsetup
        cryptsetup-mux
        libblockdev-crypto
      ]
      ++ optionals cfg.enableLvm [
        lvm2
        libblockdev-lvm
      ];

    services = {
      udisks2 = {
        enable = mkDefault true;
        settings = {
          "mount_options.conf" = {
            defaults = {
              defaults = "noatime";
            };
          };
          "udisks2.conf" = {
            defaults = {
              encryption = "luks1";
            };
          };
        };
      };

      devmon = {
        enable = mkDefault true;
        extraOptions = [];
      };

      gnome = {
        glib-networking.enable = mkDefault true;
      };
    };

    security.polkit = {
      enable = mkDefault true;

      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ((action.id == "org.freedesktop.UDisks2.encrypted-auth-check" ||
               action.id == "org.freedesktop.UDisks2.encrypted-unlock") &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });

        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.UDisks2.filesystem-mount" ||
              action.id == "org.freedesktop.UDisks2.filesystem-mount-other-seat") {
            if (subject.isInGroup("wheel")) {
              return polkit.Result.YES;
            }
          }
        });
      '';
    };

    programs.dconf = {
      enable = mkDefault true;
    };

    boot.supportedFilesystems = [
      "ext4"
      "ntfs"
      "vfat"
      "exfat"
    ];
  };
}
