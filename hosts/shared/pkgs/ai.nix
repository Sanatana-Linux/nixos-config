{pkgs, ...}:
with pkgs; [
  aichat
  #  local-ai
  code2prompt
  nextjs-ollama-llm-ui
  tgpt
  ollama-cuda
  python312Packages.ollama
  gollama
]
