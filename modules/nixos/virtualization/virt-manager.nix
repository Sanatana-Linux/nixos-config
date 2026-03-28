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

    systemd.services.virt-secret-init-encryption = {
      description = "Initialize libvirt secret encryption key";
      wantedBy = ["multi-user.target"];
      before = ["libvirtd.service" "virtsecretd.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p /var/lib/libvirt/secrets && touch /var/lib/libvirt/secrets/secrets-encryption-key && chmod 0600 /var/lib/libvirt/secrets/secrets-encryption-key'";
      };
    };
  };
}
