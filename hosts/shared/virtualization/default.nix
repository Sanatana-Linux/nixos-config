{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./virt-manager.nix
    ./waydroid.nix
  ];
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      rootless = {
        enable = true;
        daemon.settings.features.cdi = true; # see: https://nixos.wiki/wiki/Nvidia#NVIDIA_Docker_not_Working
      };
      extraOptions = "--add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime ";
      #      package = pkgs.docker_25;
    };
    containers.enable = true;
    libvirtd.enable = true;
    containerd.enable = true;
    oci-containers.backend = "docker";
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics.enable32Bit = true;
  environment.systemPackages = with pkgs; [
    conmon
    containerd
    fuse-overlayfs
    docker
    docker-buildx
    docker-client
    docker-compose
    docker-credential-helpers
    distribution
    docker-gc
    docker-slim
    libvirt
    libvirt-glib
    libgovirt
    virtualboxWithExtpack
  ];
}
