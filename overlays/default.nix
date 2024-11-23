{
  outputs,
  inputs,
}: let
  # Adds my custom packages
  additions = final: _: import ../pkgs {pkgs = final;};

  # Modifies existing packages
  modifications = final: prev: {
    master-pkgs = inputs.nixpkgs-master.legacyPackages.${prev.system};
    awesome-git-luajit = inputs.nixpkgs-f2k.packages.${prev.system}.awesome-luajit-git;
    neovim = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
    nps = inputs.nps.defaultPackage.${prev.system};

    picom = prev.picom.overrideAttrs (old: {
        src = inputs.picom-sdhand-src;
        version = "sdhand-git";
        buildInputs =
          (old.buildInputs or [])
          ++ [
            final.pcre
            final.asciidoc-full
            final.xorg.xcbutil
          ];
      });



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
  nur = inputs.nur.overlay;
  };
in {
  default = final: prev: (additions final prev) // (modifications final prev);
}
