{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aichat
    alpaca
    code2prompt
    gollama
    lunacy
    plandex
    # local-ai
    open-interpreter
    ollama-cuda
    python312Packages.ollama
    tgpt
  ];
}
