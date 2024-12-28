{
  pkgs,
  config,
  ...
}: {
  hardware.cpu.intel.updateMicrocode = true;
  environment.systemPackages = with pkgs; [
    cpufrequtils
    intel-compute-runtime
    intel-gmmlib
    intelmetool
    inteltool
    inxi
  ];
}
