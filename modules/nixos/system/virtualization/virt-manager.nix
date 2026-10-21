{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.virtualization.virt-manager;
  systemdPkg = config.systemd.package;
in {
  options.modules.system.virtualization.virt-manager = {
    enable = mkEnableOption "Virtual machine management with virt-manager";

    libguestfsIntrospection = mkOption {
      type = types.bool;
      default = false;
      description = "Enable libguestfs for VM disk image introspection (guestfish, virt-inspector, etc.)";
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      G2TP_OVMF_IMAGE = "/run/libvirt/nix-ovmf/OVMF_CODE.fd";
      G2TP_GRUB_LIB = "/nix/store/77r7pkdhylp119m32lhh349yqc5dyig6-grub-2.12/lib/grub";
    };

    # Ensure tss user exists for swtpm operations
    users.users.tss = {
      isSystemUser = true;
      group = "tss";
      description = "TPM software stack user";
    };

    users.groups.tss = {};
    users.groups.kvm = {};

    environment.systemPackages = with pkgs;
      [
        virt-manager
        qemu_kvm
        qemu-utils
        qemu-python-utils
        qtemu
        quickemu
        OVMFFull
        swtpm
      ]
      ++ lib.optionals cfg.libguestfsIntrospection [
        libguestfs
        libguestfs-with-appliance
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

    # libvirt consumes its secrets-encryption-key through LoadCredentialEncrypted=,
    # which requires a systemd-creds encrypted blob rather than a plaintext key.
    # libvirt ships the drop-in but not this init service, so it must be provided
    # here. Generation is idempotent: replacing the key would orphan every secret
    # already encrypted under the previous one, and libvirt fails to start with
    # "Encrypted file too short" if the file is empty or unencrypted.
    systemd.services.virt-secret-init-encryption = {
      description = "Initialize libvirt secret encryption key";
      wantedBy = ["multi-user.target"];
      before = ["libvirtd.service" "virtsecretd.service"];
      serviceConfig.RemainAfterExit = true;
      path = with pkgs; [
        systemdPkg
        coreutils
        bash
      ];
      script = ''
             set -euo pipefail
             key=/var/lib/libvirt/secrets/secrets-encryption-key
           mkdir -p /var/lib/libvirt/secrets
           if [ ! -s "$key" ]; then
               raw=$(mktemp)
         ${pkgs.coreutils}/bin/head -c 32 /dev/urandom > "$raw"
         ${systemdPkg}/bin/systemd-creds encrypt --name=secrets-encryption-key "$raw" "$key"
        ${pkgs.coreutils}/bin/shred -u "$raw"
             fi
          ${pkgs.coreutils}/bin/chmod 0600 "$key"
      '';
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
