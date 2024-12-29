{
  pkgs,
  config,
  ...
}: {
  # Done with the "advanced" BIOS setting to limit a
  # amount of current that the CPU can request (default was no limit!)
  services.undervolt = {
    enable = true;
    coreOffset = -100;
  };
}
