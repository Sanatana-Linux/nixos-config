{
  outputs,
  inputs,
}: let
  # Adds my custom packages
  additions = final: _: import ../pkgs {pkgs = final;};

  # Modifies existing packages
  modifications = final: prev: {
    master-pkgs = inputs.nixpkgs-master.legacyPackages.${prev.system};
    chaotic-pkgs = inputs.chaotic.packages.${prev.system};
    awesome-git-luajit = inputs.nixpkgs-f2k.packages.${prev.system}.awesome-luajit-git;
    nps = inputs.nps.defaultPackage.${prev.system};
    sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
      pname = "sf-mono-liga-bin";
      version = "dev";
      src = inputs.sf-mono-liga-src;
      dontConfigure = true;
      installPhase = ''
        mkdir -p $out/share/fonts/opentype
        cp -R $src/*.otf $out/share/fonts/opentype/
      '';
    };
    nixpkgs-f2k = inputs.nixpkgs-f2k.packages.${prev.system};
    nur = inputs.nur.overlay.default;
  };
in {
  default = final: prev: (additions final prev) // (modifications final prev);
}
