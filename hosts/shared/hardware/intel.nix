{
  pkgs,
  config,
  ...
}: {
  # For undervolting see ../performance/undervolt
  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  environment.systemPackages = with pkgs; [
    cpufrequtils
    powertop
    intel-compute-runtime
    intel-gmmlib
    intel-media-driver
    intel-vaapi-driver
    libva-vdpau-driver
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
