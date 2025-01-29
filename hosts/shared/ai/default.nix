{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aichat
    alpaca
    code2prompt
    gollama
    #    local-ai
    open-interpreter
    nextjs-ollama-llm-ui
    ollama-cuda
    python312Packages.ollama
    tgpt
  ];
}
