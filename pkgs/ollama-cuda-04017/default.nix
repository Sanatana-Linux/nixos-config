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
    hash = "sha256-1icr0xkxymc2siihiww8ahxzlnj36ymbii1syg3f2nkd3d4ma9iz=";
  };

  # Placeholder — replaced with the real hash after the first build attempt.
  vendorHash = "sha256-0000000000000000000000000000000000000000000000000000=";

  passthru =
    (old.passthru or {})
    // rec {
      llamaCppVersion = "b12257";
      llamaCppSrc = fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = llamaCppVersion;
        hash = "sha256-0ibd0xpqfxargpqqp881kv8189ybq1zcpdh2wygkd826m8pn1swl=";
      };
    };

  meta =
    old.meta
    // {
      description = "Ollama LLM server v0.40.17 with CUDA support";
    };
})
