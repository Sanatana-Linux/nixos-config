{
  pkgs,
  config,
  ...
}: {
  # enable fix for Intel CPU throttling
  services.throttled.enable = true;
  # Also done with the "advanced" BIOS setting to limit a
  # amount of current that the CPU can request (default was no limit!)
  # rest of undevolting done via  OS configuration as it is more responsive to experimentation
  services.undervolt = {
    enable = true;
    uncoreOffset = -50; # in mV
    coreOffset = -50; # in mV
    package = pkgs.undervolt;
    verbose = true; # More logging
    turbo = 0; # Keep Intel Turbo feature enabled (1 for disabled)
    p1 = {
      # P-State 1 limit and time window (both must be set)
      limit = 150; # in Watts
      window = 300; # in Seconds
    };
    p2 = {
      # P-State 2 limit and time window (both must be set)
      limit = 150; # in Watts
      window = 224; # in Seconds
    };
  };
}
