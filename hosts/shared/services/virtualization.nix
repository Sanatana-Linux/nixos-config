{
  lib,
  pkgs,
  ...
}: {
  services.  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      enableNvidia = true;
      extraOptions = "--add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime";
    };
    libvirtd.enable = true;
  };
}
