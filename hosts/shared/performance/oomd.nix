{
  pkgs,
  config,
  ...
}: {
  # Systemd OOMd
  # Fedora enables these options by default. See the 10-oomd-* files here:
  # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
  systemd.oomd = {
    enable = true;
    enableRootSlice = true; # Root
    enableUserSlices = true; # User
    enableSystemSlice = true; # System
    settings.OOM = {
      "DefaultMemoryPressureDurationSec" = "8s"; # time after memory pressure to take action
    };
  };
  services.irqbalance.enable = true; # distributes hardware interrupts to processor
  services.earlyoom.enable = true; # oomd before it gets bad please
}
