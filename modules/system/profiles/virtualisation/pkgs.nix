# packages that should be installed

{ pkgs }:

with pkgs; [
# virtualboxWithExtpack # takes too damn long to build
anbox
distrobox
docker-compose
docker-gc
docker
qemu_full
virt-manager
kvmtool 
x11docker
docker-distribution  
docker-client  
docker-buildx  
arion    
waydroid
containerd   
containerpilot    
conmon 
convoy
devbox
]
