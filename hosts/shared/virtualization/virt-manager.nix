{
  lib,
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu_kvm
    #stable.qemu_full
    qemu-utils
    qemu-python-utils
    qtemu
    quickemu
    OVMFFull
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
