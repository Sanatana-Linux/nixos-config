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
    #   rootless = [
    #   enable = true;
    #    daemon.settings.features.cdi = true;# see: https://nixos.wiki/wiki/Nvidia#NVIDIA_Docker_not_Working
    #  };
    #   extraOptions = "--add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime ";
    #   package = pkgs.docker_25;

    # };
    containers.enable = true;
    libvirtd.enable = true;
    containerd.enable = true;
    oci-containers.backend = "podman";
    # I *think* I like podman better at the end of the day, jury is still out
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
    podman-compose
    podman-tui
    kvmtool
    virt-manager
    qemu_full
    # docker_25
    # docker-buildx
    # docker-client
    # docker-compose
    # docker-credential-helpers
    # docker-distribution
    # docker-gc
    # docker-slim

    #   x11docker
  ];
}
