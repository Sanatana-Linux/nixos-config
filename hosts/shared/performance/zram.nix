{
  # Tune the configuration to take advantage of the ZRAM swap device.

  # NOTE for the `sysctl` commands that are associated with zram, see this directory's default.nix

  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 30; # Use 30% of available RAM for zram swap
    priority = 1501;
  };
}
