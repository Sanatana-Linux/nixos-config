{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./virt-manager.nix
  ];
  virtualisation = {
    # docker = {
    #   enable = true;
    #   enableOnBoot = true;
    #   rootless.enable = true;
    #   extraOptions = "--add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime ";
    #   package = pkgs.docker_25;
    # };
    containers.enable = true;
    libvirtd.enable = true;
    containerd.enable = true;
    oci-containers.backend = "podman";
    podman = {
      defaultNetwork.settings = {
        dns_enabled = true;
      };
      dockerCompat = true;
      dockerSocket.enable = true;
      enable = true;
    };
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics.enable32Bit = true;
  environment.systemPackages = with pkgs; [
    appvm
    conmon
    containerd
    act
    distrobox
    fuse-overlayfs
    podman-desktop
    podman-compose
    podman-tui
    # docker_25
    # docker-buildx
    # docker-client
    # docker-compose
    # docker-credential-helpers
    # docker-distribution
    # docker-gc
    # docker-slim
    nvidia-container-toolkit
    libnvidia-container
    cudaPackages.cudatoolkit
    cudaPackages.cuda_opencl
    cudaPackages.libnvidia_nscq
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    kvmtool
    #    oxker
    qemu_full
    virt-manager
    #   x11docker
  ];
}
