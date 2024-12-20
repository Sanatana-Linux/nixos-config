{pkgs, ...}:
with pkgs; [
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
  qemu_full
  virt-manager
  x11docker
]
