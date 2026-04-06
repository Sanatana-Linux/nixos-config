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
    # Ensure tss user exists for swtpm operations
    users.users.tss = {
      isSystemUser = true;
      group = "tss";
      description = "TPM software stack user";
    };
    
    users.groups.tss = {};

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu_kvm
      qemu-utils
      qemu-python-utils
      qtemu
      quickemu
      OVMFFull
      kvmtool
      swtpm
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        runAsRoot = false;
      };
    };

    # Suppress unwanted libvirtd services
    systemd.suppressedSystemUnits = [
      "libvirtd-ro.socket"
    ];

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

    # Initialize swtpm-localca directory with proper permissions
    systemd.services.swtpm-localca-init = {
      description = "Initialize swtpm-localca directory";
      wantedBy = ["multi-user.target"];
      before = ["libvirtd.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p /var/lib/swtpm-localca && chown tss:tss /var/lib/swtpm-localca && chmod 0755 /var/lib/swtpm-localca && mkdir -p /var/log/swtpm/libvirt/qemu && chown -R tss:tss /var/log/swtpm && chmod -R 0755 /var/log/swtpm'";
      };
    };
  };
}
