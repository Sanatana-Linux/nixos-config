{
  pkgs,
  config,
  ...
}: {
  services = {
    xserver = {
      enable = true;
    };
  };
}
