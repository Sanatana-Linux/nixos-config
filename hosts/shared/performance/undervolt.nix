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
    coreOffset = -100;
    package = pkgs.undervolt;
    verbose = true;
  };
}
