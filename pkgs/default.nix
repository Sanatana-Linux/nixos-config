{pkgs}: {
  autocomplete-sh = pkgs.callPackage ./autocomplete-sh {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  legion-rgb-control = pkgs.callPackage ./legion-rgb-control {};
  legion-kb-rgb = pkgs.callPackage ./legion-kb-rgb {};
  pypeek = pkgs.callPackage ./pypeek {};
  ollama-cuda-04017 = pkgs.callPackage ./ollama-cuda-04017 {};
}
