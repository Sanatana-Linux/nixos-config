{
  pkgs,
  config,
  ...
}: {
  # For undervolting see ../performance/undervolt
  hardware.cpu.intel.updateMicrocode = true;
  environment.systemPackages = with pkgs; [
    cpufrequtils
    powertop
    intel-compute-runtime
    intel-gmmlib
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
