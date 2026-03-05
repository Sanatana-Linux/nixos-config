{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.intel;
in {
  options.modules.hardware.intel = {
    enable = mkEnableOption "Intel CPU and graphics support";

    vaapi = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Intel VA-API video acceleration";
    };

    opencl = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Intel OpenCL compute runtime";
    };

    powerManagement = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Intel CPU power management tools";
    };
  };

  config = mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = true;

    nixpkgs.config.packageOverrides = mkIf cfg.vaapi (pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
    });

    environment.systemPackages = with pkgs;
      [
        # Intel hardware tools
        intelmetool
        inteltool
        inxi
      ]
      ++ optionals cfg.vaapi [
        # Video acceleration
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ]
      ++ optionals cfg.opencl [
        # OpenCL compute
        intel-compute-runtime
        intel-gmmlib
        intel-ocl
      ]
      ++ optionals cfg.powerManagement [
        # Power management
        cpufrequtils
        powertop
        intel-undervolt
        undervolt
      ];
  };
}
