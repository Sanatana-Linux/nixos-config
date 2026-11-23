# Ollama LLM server v0.40.17 with CUDA support for modern NVIDIA GPUs.
#
# nixpkgs-unstable is pinned at ollama 0.40.16, which is too old to pull
# newer models (e.g. inkling-2-mini) that require a newer Ollama manifest
# API. This override builds ollama-cuda from the v0.40.17 GitHub tag.
#
# cudaArches is deliberately left unset so it defaults to
# `cudaPackages.flags.realArches` (all real CUDA architectures), which covers
# bagalamukhi's and matangi's modern discrete NVIDIA cards. Do NOT restrict to
# sm_61 — that is Pascal-only and breaks modern GPUs.
{
  pkgs,
  lib,
  fetchFromGitHub,
}:
pkgs.ollama-cuda.overrideAttrs (old: rec {
  pname = "ollama-cuda-04017";
  version = "0.40.17";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${version}";
    hash = "sha256-PyZVSRttWuHG8zrEuKo3Q1r6O1SI8whj1IJV32cHmcU=";
  };

  vendorHash = "sha256-1mzJrZUHH2ouP6I+LVojHbft7No5AumqKZVq0I/Ubsg=";

  passthru =
    (old.passthru or {})
    // rec {
      llamaCppVersion = "b12257";
      llamaCppSrc = fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = llamaCppVersion;
        hash = "sha256-lOtgL6pGoDaf5wK2y37AyycU0J4BoYvxfVl1h28HbUU=";
      };
    };

  meta =
    old.meta
    // {
      description = "Ollama LLM server v0.40.17 with CUDA support";
    };
})
