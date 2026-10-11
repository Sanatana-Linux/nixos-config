{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.amd;
in {
  options.modules.hardware.amd = {
    enable = mkEnableOption "AMD CPU and chipset support (Zen family, AM4/X570 boards)";

    sensors = mkOption {
      type = types.bool;
      default = true;
      description = "Load AMD and board hwmon drivers (k10temp, nct6775, asus_ec_sensors) for temperature, voltage, fan RPM and PWM";
    };

    powerManagement = mkOption {
      type = types.bool;
      default = true;
      description = "Enable AMD CPU power management tooling. The amd_pstate driver itself is configured by nixos-hardware's common/cpu/amd/pstate module.";
    };

    virtualization = mkOption {
      type = types.bool;
      default = true;
      description = "Enable AMD-V (KVM, nested virtualization) and AMD IOMMU for VFIO device passthrough";
    };

    ecc = mkOption {
      type = types.bool;
      default = true;
      description = "Load AMD64 EDAC modules for ECC memory error reporting (inert on non-ECC systems)";
    };
  };

  config = mkIf cfg.enable {
    # AMD CPU / chipset kernel modules.
    #   kvm-amd              — AMD-V hardware virtualization
    #   ccp                  — Cryptographic Coprocessor (AES/SHA offload)
    #   sp5100_tco           — AMD FCH watchdog timer
    #   i2c-piix4            — AMD SMBus controller (backs the Super I/O sensor chip)
    #   x86_pkg_temp_thermal — package temperature sensor
    #   k10temp              — Zen 2 (Family 17h model 70h) Tdie/Tctl, per-CCD temp,
    #                          core/SoC current and voltage
    #   nct6775              — Nuvoton NCT6798D Super I/O: motherboard temperature,
    #                          voltages, fan RPM and PWM fan control
    #   asus_ec_sensors      — ASUS embedded-controller driver (mainline >= 5.18).
    #                          The Pro WS X570-ACE is an explicitly supported board:
    #                          adds chipset/VRM/T_Sensor temps, extra fan RPM and
    #                          CPU current/voltage that the Super I/O chip does not expose.
    boot.kernelModules =
      [
        "kvm-amd"
        "ccp"
        "sp5100_tco"
        "i2c-piix4"
        "x86_pkg_temp_thermal"
      ]
      ++ optionals cfg.sensors [
        "k10temp"
        "nct6775"
        "asus_ec_sensors"
      ]
      ++ optionals cfg.ecc [
        "edac_mce_amd"
        "amd64_edac"
      ]
      ++ optionals cfg.virtualization [
        "vfio-pci"
      ];

    # amd_pstate=active is supplied by nixos-hardware's asus/pro-ws-x570-ace
    # module (which imports common/cpu/amd/pstate.nix) on kernel >= 6.3, so it
    # is not repeated here. schedutil is the software governor that pairs with
    # the active EPP hint.
    powerManagement.cpuFreqGovernor = mkIf cfg.powerManagement (mkDefault "schedutil");

    # AMD IOMMU and KVM tuning for the virtualization stack (Docker, virt-manager).
    boot.kernelParams = optionals cfg.virtualization [
      "amd_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      "kvm_amd.nested=1"
    ];

    environment.systemPackages = with pkgs;
      [
        cpufrequtils
      ]
      ++ optionals cfg.sensors [lm_sensors]
      ++ optionals cfg.powerManagement [powertop]
      ++ optionals cfg.ecc [edac-utils];

    # Persist the hwmon module list for sensor and fan tooling.
    environment.etc."sysconfig/lm_sensors".text = mkIf cfg.sensors ''
      HWMON_MODULES="k10temp nct6775 asus_ec_sensors"
    '';
  };
}
