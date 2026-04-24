<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-21 | Updated: 2026-04-22 -->

# modules/nixos/ai/

## Purpose
AI/ML tooling — local LLM inference and image generation.

## Key Files

| File | Description |
|------|-------------|
| `default.nix` | Re-exports AI submodules |
| `core.nix` | Shared AI infrastructure (CUDA, Python ML packages) |
| `ollama.nix` | Ollama LLM server (local inference) |
| `comfyui.nix` | ComfyUI stable diffusion frontend |

## For AI Agents

### Working In This Directory
- `core.nix` must be enabled for `ollama.nix` and `comfyui.nix` to work
- CUDA support requires `hardware.nvidia.enable = true` and matching driver version
- Ollama serves on localhost:11434 by default

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->