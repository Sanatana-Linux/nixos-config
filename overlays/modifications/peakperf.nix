{inputs, ...}: {
  modifications = final: prev: {
    # peakperf's GPU path is compiled for compute_50, which CUDA 13 dropped:
    # nvcc aborts with "Unsupported gpu architecture 'compute_50'". The tool
    # benchmarks x86 CPUs, so build the CPU-only variant.
    peakperf = prev.peakperf.override {
      enableCuda = false;
    };
  };
}
