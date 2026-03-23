{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.tpm;
in {
  options.modules.hardware.tpm = {
    enable = mkEnableOption "Trusted Platform Module 2.0 support";

    enableAbrmd = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Trusted Platform 2 userspace resource manager daemon";
    };

    enableTctiEnvironment = mkOption {
      type = types.bool;
      default = true;
      description = "Set TCTI environment variables (TPM2TOOLS_TCTI, TPM2_PKCS11_TCTI)";
    };

    enablePkcs11 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable TPM2 PKCS#11 tool and shared library in system path";
    };

    initrdSupport = mkOption {
      type = types.bool;
      default = true;
      description = "Load TPM kernel module in initrd";
    };
  };

  config = mkIf cfg.enable {
    security.tpm2 = {
      enable = mkDefault true;
      abrmd.enable = mkDefault cfg.enableAbrmd;
      tctiEnvironment.enable = mkDefault cfg.enableTctiEnvironment;
      pkcs11.enable = mkDefault cfg.enablePkcs11;
    };

    boot.initrd.kernelModules = mkIf cfg.initrdSupport ["tpm"];

    # TPM-related packages
    environment.systemPackages = with pkgs; [
      libtpms
      python312Packages.tpm2-pytss
      ssh-tpm-agent
      swtpm
      tpm2-abrmd
      tpm2-tools
      tpm2-tss
      tpmmanager
    ];
  };
}
