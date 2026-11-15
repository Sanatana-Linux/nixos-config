{inputs, ...}: {
  modifications = final: prev: {
    # opencv only reaches this system through frei0r (video effects) and
    # nothing here calls cv2.cuda or the dnn CUDA backend — GPU inference runs
    # through ollama-cuda and torch, and the ncnn upscalers use Vulkan. With
    # cudaSupport on, opencv becomes a CUDA variant that no cache carries for
    # nixos-unstable-small revs, so it recompiles through nvcc on every bump
    # for code paths nothing invokes. `opencv` is only an alias of `opencv4`
    # (all-packages.nix: `opencv = opencv4`), so the real attribute is the one
    # to override; with CUDA off this is byte-identical to Hydra's default
    # build and substitutes.
    opencv4 = prev.opencv4.override {
      enableCuda = false;
    };
  };
}
