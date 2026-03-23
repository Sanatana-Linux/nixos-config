{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.virtualization.virt-manager;
in {
  options.modules.virtualization.virt-manager = {
    enable = mkEnableOption "Virtual machine management with virt-manager";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      qemu_kvm
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
        swtpm.enable = true;
        runAsRoot = false;
      };
    };
  };
}
