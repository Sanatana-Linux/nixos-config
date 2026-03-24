{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.services;
in {
  options.modules.base.services = {
    enable = mkEnableOption "core system services (fstrim, fwupd, journald, dbus, gnome services)";
# FHS non-compliance work around 
envfs.enable = true;
    fstrim.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fstrim service for SSDs";
    };

    fwupd.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable firmware updater";
    };

    journald = {
      systemMaxUse = mkOption {
        type = types.str;
        default = "80M";
        description = "Maximum system journal size";
      };

      runtimeMaxUse = mkOption {
        type = types.str;
        default = "30M";
        description = "Maximum runtime journal size";
      };

      maxRetentionSec = mkOption {
        type = types.str;
        default = "7d";
        description = "Maximum journal retention time";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      # discard blocks that are not in use by the filesystem, good for SSDs
      fstrim.enable = cfg.fstrim.enable;

      # firmware updater for machine hardware
      fwupd.enable = cfg.fwupd.enable;

      # limit systemd journal size
      journald.extraConfig = ''
        SystemMaxUse=${cfg.journald.systemMaxUse}
        RuntimeMaxUse=${cfg.journald.runtimeMaxUse}
        MaxRetentionSec=${cfg.journald.maxRetentionSec}
      '';

      dbus = {
        enable = true;
        packages = with pkgs; [dconf gcr dbus-broker polkit_gnome];
        implementation = "dbus";
      };

      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
      };

      tumbler.enable = true;
      gvfs.enable = true;
    };
  };
}
