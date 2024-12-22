{pkgs, config, ...}:{

       cpu.intel.updateMicrocode = true;
   systemPackages = with pkgs; [
      cpufrequtils
      intel-compute-runtime
      intel-gmmlib
      intel-ocl
      intelmetool
      inteltool
      inxi
    ];

}
