# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    nps = inputs.nps.defaultPackage.${prev.stdenv.hostPlatform.system};

    # Fix olive-editor Qt 6.10 compatibility
    olive-editor = prev.olive-editor.overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          ../modules/nixos/packages/olive-editor-qt610-fix.patch
        ];
    });
  };

  # Master packages overlay (bleeding edge)
  master-packages = final: prev: {
    master = import inputs.master {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  f2k-packages = final: prev: {
    f2k = import inputs.nixpkgs-f2k {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
  stable-packages = final: prev: {
    stable = import inputs.stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  chaotic-packages = final: prev: {
    chaotic = import inputs.chaotic {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
