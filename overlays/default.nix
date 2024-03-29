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

    nps = inputs.nps.defaultPackage.${prev.system};

    ncmpcpp = prev.ncmpcpp.overrideAttrs (old: rec {
      src = prev.fetchFromGitHub {
        owner = "ncmpcpp";
        repo = "ncmpcpp";
        rev = "417d7172e5587f4302f92ea6377268dca7f726ad";
        sha256 = "LRf/iWxRO9zX+MZxIQbscslicaWzN7kokzJLUVg7T38=";
      };

      nativeBuildInputs = old.nativeBuildInputs ++ [prev.autoconf prev.automake prev.libtool];
      preConfigure = "./autogen.sh";
    });

    thunar = prev.thunar.overrideAttrs rec {
      thunarPlugins = [
        inputs.nixpkgs.${prev.system}.xfce.thunar-archive-plugin
        inputs.nixpkgs.${prev.system}.xfce.thunar-volman
        inputs.nixpkgs.${prev.system}.xfce.thunar-dropbox-plugin
        inputs.nixpkgs.${prev.system}.xfce.thunar-media-tags-plugin
      ];
    };

    picom = inputs.nixpkgs-f2k.packages.${prev.system}.picom-ft-labs;
  };
in {
  default = final: prev: (additions final prev) // (modifications final prev);
}
