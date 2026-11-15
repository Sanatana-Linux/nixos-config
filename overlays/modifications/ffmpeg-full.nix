{inputs, ...}: {
  modifications = final: prev: {
    # Pin ffmpeg-full to stable: ffmpeg's generic.nix enables withCudaNVCC
    # whenever config.cudaSupport is true, so the unstable build of the full
    # variant compiles through nvcc and fails; the stable channel's full
    # variant is prebuilt and substitutes.
    ffmpeg-full = final.stable.ffmpeg-full;
  };
}
