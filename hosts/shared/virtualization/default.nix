{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./virt-manager.nix
  ];
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      rootless.enable = true;
      extraOptions = "--add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime";
    };
    libvirtd.enable = true;
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics.enable32Bit = true;
  environment.systemPackages = with pkgs; [
    appvm
    conmon
    containerd
    docker
    docker-buildx
    docker-client
    docker-compose
    docker-credential-helpers
    docker-distribution
    docker-gc
    docker-slim
    nvidia-container-toolkit
    kvmtool
    oxker
    #qemu_full
    virt-manager
    x11docker
  ];
}
