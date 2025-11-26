{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aichat
    gemini-cli
    code2prompt
    codegrab # use as `grab`
    gollama
    # local-ai
    libtorch-bin
    # python312Packages.diffusers
    # python312Packages.optimum
    python312Packages.torch-bin
    # python312Packages.torchWithCuda
    # python312Packages.transformers
    # python312Packages.triton-cuda
    ollama-cuda
    python312Packages.ollama
    tgpt
  ];
}
