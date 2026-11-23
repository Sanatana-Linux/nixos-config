{inputs, ...}: {
  additions = final: _prev:
    (import ../pkgs {pkgs = final.pkgs;})
    // {
      firefox-nightly-bin = inputs.firefox-nightly.packages.${final.stdenv.hostPlatform.system}.firefox-nightly-bin;
      ollama-pascal = import ../pkgs/ollama-pascal {
        pkgs = final.pkgs;
        lib = final.pkgs.lib;
        fetchFromGitHub = final.pkgs.fetchFromGitHub;
      };
      ollama-cuda-04017 = import ../pkgs/ollama-cuda-04017 {
        pkgs = final.pkgs;
        lib = final.pkgs.lib;
        fetchFromGitHub = final.pkgs.fetchFromGitHub;
      };
    };
}
