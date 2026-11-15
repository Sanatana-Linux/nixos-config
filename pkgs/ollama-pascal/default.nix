# Ollama LLM server pinned to v0.40.13 for Pascal GPUs (NVIDIA GTX 1080,
# compute_61). CUDA 13 dropped compute_50 and unstable ollama-cuda targets
# sm_86+, so this keeps the last version whose CUDA toolchain still supports
# Pascal. bagalamukhi and matangi use the unpinned upstream ollama-cuda to
# benefit from their modern discrete NVIDIA cards.
{
  pkgs,
  lib,
  fetchFromGitHub,
}:
pkgs.ollama-cuda.overrideAttrs (old: rec {
  pname = "ollama-pascal";
  version = "0.40.13";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${version}";
    hash = "sha256-cxpgG6l97S7f+XZy5Hb689MYpVnbaqxBhzHLL62zAKM=";
  };

  vendorHash = "sha256-1mzJrZUHH2ouP6I+LVojHbft7No5AumqKZVq0I/Ubsg=";

  passthru =
    (old.passthru or {})
    // rec {
      llamaCppVersion = "b11963";
      llamaCppSrc = fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = llamaCppVersion;
        hash = "sha256-DUggBODOVSOydWopvdXt/K9ZiRrbWrl+mywpr1vjJwM=";
      };
    };

  # Pascal (compute_61) — CUDA 12 still targets it; CUDA 13+ does not.
  cudaArches = ["sm_61"];

  meta =
    old.meta
    // {
      description = "Ollama LLM server pinned to v0.40.13 for Pascal GPUs";
    };
})
