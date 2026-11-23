{pkgs}: {
  autocomplete-sh = pkgs.callPackage ./autocomplete-sh {};
  # Upstream XPI comes from the NUR add-on set that the Firefox module already
  # consumes; nur is added to this package set by the host's overlay list.
  bitwarden-xpi = pkgs.callPackage ./bitwarden-xpi {
    src = pkgs.nur.repos.rycee.firefox-addons.bitwarden;
  };
  material-symbols = pkgs.callPackage ./material-symbols {};
  legion-rgb-control = pkgs.callPackage ./legion-rgb-control {};
  legion-kb-rgb = pkgs.callPackage ./legion-kb-rgb {};
  pypeek = pkgs.callPackage ./pypeek {};
  ollama-cuda-04017 = pkgs.callPackage ./ollama-cuda-04017 {};
}
