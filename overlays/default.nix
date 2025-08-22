# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    nps = inputs.nps.defaultPackage.${prev.system};

    # Fix android-translation-layer build issues
    android-translation-layer = prev.android-translation-layer.overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          ../patches/android-translation-layer-aarch64-relocs.patch
          ../patches/android-translation-layer-elfutils-glibc.patch
          ../patches/android-translation-layer-cmake-glib.patch
        ];

      # Additional build fixes
      preConfigure = ''
        ${oldAttrs.preConfigure or ""}
        # Fix missing includes
        export CPPFLAGS="-I${prev.glib.dev}/include/glib-2.0 -I${prev.glib.out}/lib/glib-2.0/include $CPPFLAGS"
        export PKG_CONFIG_PATH="${prev.glib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
      '';

      buildInputs =
        (oldAttrs.buildInputs or [])
        ++ [
          prev.glib
          prev.pkg-config
        ];

      nativeBuildInputs =
        (oldAttrs.nativeBuildInputs or [])
        ++ [
          prev.cmake
          prev.pkg-config
        ];
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'

  unstable-packages = final: prev: {
    unstable = import inputs.unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  f2k-packages = final: prev: {
    f2k = import inputs.nixpkgs-f2k {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  stable-packages = final: prev: {
    stable = import inputs.stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  master-packages = final: prev: {
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  chaotic-packages = final: prev: {
    chaotic = import inputs.chaotic {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
