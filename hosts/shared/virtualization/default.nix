{
  lib,
  pkgs,
  ...
}: {
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      extraOptions = "--add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime";
    };
    libvirtd.enable = true;
  };
   hardware.nvidia-container-toolkit.enable = true;
}
