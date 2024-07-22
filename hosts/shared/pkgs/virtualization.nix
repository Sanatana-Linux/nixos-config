{ pkgs, ... }:
with pkgs; [
  appvm
  conmon
  containerd
  devbox
  distrobox
  docker
  docker-buildx
  docker-client
  docker-compose
  docker-distribution
  docker-gc
  docker-slim
  oxker
  docker-credential-helpers
  kvmtool
  #  qemu_full
  virt-manager
  x11docker
]
