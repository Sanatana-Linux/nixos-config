{pkgs, ...}:
with pkgs; [
  aichat
  gpt4all-cuda
  llama-cpp
  nextjs-ollama-llm-ui
  tgpt
  nvidia-container-toolkit
  nvidia-docker
  ollama
  cudaPackages.cudnn
  cudaPackages.cutensor
  cudaPackages.cuda_opencl
]
