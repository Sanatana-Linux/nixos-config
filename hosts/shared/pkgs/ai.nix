{pkgs, ...}:
with pkgs; [
  ollama
  gpt4all-cuda
  alpaca
  nextjs-ollama-llm-ui
  nvidia-docker
  nvidia-container-toolkit
  aichat
  llama-cpp
]
