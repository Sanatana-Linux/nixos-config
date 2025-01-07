{
  pkgs,
  config,
  ...
}: {
  # Also done with the "advanced" BIOS setting to limit a
  # amount of current that the CPU can request (default was no limit!)
  # Doubling up to insure system functionality
  services.undervolt = {
    enable = true;
    coreOffset = -100; # The amount of voltage in mV to offset the CPU cores by.
    package = pkgs.undervolt;
    verbose = true; # More logging
    turbo = 0; #Changes the Intel Turbo feature status (1 is disabled and 0 is enabled).
  };
}
