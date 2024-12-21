{
  config,
  lib,
  pkgs,
  ...
}:
{

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}


