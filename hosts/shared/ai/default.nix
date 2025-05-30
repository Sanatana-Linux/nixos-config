{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aichat
    alpaca
    code2prompt
    codegrab # use as `grab`
    #    promptfoo
    gollama
    #    lunacy
    #    plandex
    # local-ai
    #    python312Packages.peacasso
    python312Packages.diffusers
    python312Packages.optimum
    koboldcpp
    libtorch-bin
    python312Packages.pytorch-bin
    python312Packages.transformers
    python312Packages.triton-cuda
    ollama-cuda
    python312Packages.ollama
    tgpt
  ];
}
