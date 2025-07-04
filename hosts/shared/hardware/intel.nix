{
  pkgs,
  config,
  ...
}: {
  # For undervolting see ../performance/undervolt
  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  environment.systemPackages = with pkgs; [
    cpufrequtils
    powertop
    intel-compute-runtime
    intel-gmmlib
    intel-media-driver
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-ocl
    intel-undervolt
    undervolt
    intelmetool
    inteltool
    intelmetool
    inteltool
    inxi
  ];
}
