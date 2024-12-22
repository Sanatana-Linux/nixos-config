{
  pkgs,
  config,
  ...
}: {
  # Trivial Setting Here, Mostly an Extra Precautionary Step
  # as This is Also Set in Bios to limit CPU power draw to 1.35V
  services.undervolt = {
    enable = true;
    coreOffset = -50;
  };
}
