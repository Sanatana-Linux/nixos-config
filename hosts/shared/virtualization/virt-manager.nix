{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu_kvm
    qemu-utils
    qemu-python-utils
    qtemu
    quickemu
    OVMFFull
    docker
    docker-buildx
    docker-client
    docker-compose
    docker-credential-helpers
    docker-distribution
    docker-gc
    docker-slim
    x11docker
    appvm
    conmon
    containerd
    fuse-overlayfs
    kvmtool
  ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      swtpm.enable = true;
      runAsRoot = false;
    };
  };
}
