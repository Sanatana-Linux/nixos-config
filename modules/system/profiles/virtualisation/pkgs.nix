# packages that should be installed

{ pkgs }:

with pkgs; [
  anbox
  distrobox
  docker-compose
  docker-gc
  docker-slim
  # virtualboxWithExtpack # takes too damn long to buildz
  qemu_full
  virt-manager
  x11docker
]
