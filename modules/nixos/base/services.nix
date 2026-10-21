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
      fstrim.enable = cfg.fstrim.enable;

      fwupd = {
        enable = cfg.fwupd.enable;
        # Extra remotes beyond the default `lvfs`: the testing metadata remote
        # plus the local vendor remotes (OEM firmware placed in the fwupd state
        # directory). Only takes effect while fwupd is enabled — the fwupd
        # module guards all of its config on services.fwupd.enable.
        extraRemotes = [
          "lvfs-testing"
          "vendor"
          "vendor-directory"
        ];
        # Allow firmware that is not signed by a trusted key to be installed
        # without additional authentication. The testing and vendor remotes are
        # not covered by the small default trusted-key set, so their payloads
        # would otherwise be treated as untrusted.
        daemonSettings.OnlyTrusted = false;
      };

      journald.settings.Journal = {
        SystemMaxUse = cfg.journald.systemMaxUse;
        RuntimeMaxUse = cfg.journald.runtimeMaxUse;
        MaxRetentionSec = cfg.journald.maxRetentionSec;
      };

      dbus = {
        enable = true;
        packages = with pkgs; [dconf gcr_4 dbus-broker polkit_gnome];
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
