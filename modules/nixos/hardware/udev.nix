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

  boot.kernelParams = [
    "nvme_core.default_ps_max_latency_us=0"
    "nvme.poll_queues=8"
    "pcie_aspm.policy=performance"
    "pci=pcie_bus_perf,realloc"
  ];

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", ENV{DEVTYPE}=="disk", TEST=="queue", ATTR{queue/scheduler}="none"
    ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", ENV{DEVTYPE}=="disk", TEST=="queue", ATTR{queue/rq_affinity}="2"
    ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", ENV{DEVTYPE}=="disk", TEST=="queue", ATTR{queue/nomerges}="1"
    ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", ENV{DEVTYPE}=="disk", TEST=="queue", ATTR{queue/iostats}="0"
  '';
};
}
