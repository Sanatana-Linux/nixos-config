{pkgs, ...}:
with pkgs; [
  conmon
  containerd
  containerpilot
  convoy
  devbox
  distrobox
  docker
  docker-buildx
  docker-client
  docker-compose
  docker-distribution
  docker-gc
  kvmtool
  qemu_full
  virt-manager
  x11docker
]
