# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    awesome-git-luajit = inputs.nixpkgs-f2k.packages.${prev.system}.awesome-luajit-git;
    nps = inputs.nps.defaultPackage.${prev.system};
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  f2k-packages = final: _prev: {
    f2k = import inputs.nixpkgs-f2k {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  chaotic-packages = final: _prev: {
    chaotic = import inputs.chaotic {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
