{
  # Tune the configuration to take advantage of the ZRAM swap device.

  # NOTE for the `sysctl` commands that are associated with zram, see this directory's default.nix

  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 400;
    # TODO: Consider a writeback device to avoid OOMs.
    # https://wiki.archlinux.org/title/Zram#Enabling_a_backing_device_for_a_zram_block
  };
}
