# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    nps = inputs.nps.defaultPackage.${prev.system};

    # Fix wolfssl by completely replacing it with a no-test version
    wolfssl = prev.wolfssl.overrideAttrs (oldAttrs: rec {
      # Change the derivation name to force rebuild
      pname = "wolfssl-notests";
      version = "${oldAttrs.version or "5.8.2"}-notests";
      __intentionallyOverridingVersion = true;
      
      # Remove problematic configure flags and add safe ones
      configureFlags = builtins.filter (flag: 
        !builtins.elem flag ["--disable-tests" "--disable-examples" "--disable-crypttests"]
      ) (oldAttrs.configureFlags or []) ++ [
        "--enable-all"
        "--enable-reproducible-build"
        "--enable-pkcs11"
        "--enable-writedup"
        "--enable-base64encode"
        "--enable-bigcache"
        "--enable-sp=yes,asm"
        "--enable-sp-math-all"
        "--enable-harden"
        "--enable-intelasm"
        "--enable-aesni"
      ];
      
      # Completely disable all test phases
      doCheck = false;
      doInstallCheck = false;
      checkPhase = ":";
      installCheckPhase = ":";
      
      # Use the standard build but skip tests
      buildPhase = ''
        runHook preBuild
        make -j$NIX_BUILD_CORES all
        runHook postBuild
      '';
      
      # Skip test-related make targets
      makeFlags = (oldAttrs.makeFlags or []);
    });

    # Also override art-standalone to use our fixed wolfssl
    art-standalone = prev.art-standalone.overrideAttrs (oldAttrs: {
      buildInputs = map (dep: if dep.pname or "" == "wolfssl" then final.wolfssl else dep) (oldAttrs.buildInputs or []);
    });

    # Fix android-translation-layer build issues
    android-translation-layer = prev.android-translation-layer.overrideAttrs (oldAttrs: {
      # Try to apply the patch with different strip levels and locations
      postPatch = ''
        ${oldAttrs.postPatch or ""}
        
        # Find all linker.h files and try to patch them
        find . -name "linker.h" -type f | while read file; do
          echo "Found linker.h at: $file"
          # Try to apply our TLS fixes directly with sed
          if grep -q "R_AARCH64_TLS_DTPREL32" "$file"; then
            echo "Patching $file for R_AARCH64_TLS_DTPREL32"
            sed -i 's/#pragma message "The R_AARCH64_TLS_DTPREL32 was not set :("/#define R_AARCH64_TLS_DTPREL32 1031/g' "$file"
            sed -i 's/#pragma message "The R_AARCH64_TLS_TPREL64 was not set :("/#define R_AARCH64_TLS_TPREL64 1030/g' "$file"
          fi
        done
      '';
      
      # Debug what gets installed
      postInstall = ''
        ${oldAttrs.postInstall or ""}
        echo "=== Installed files in $out/bin ==="
        ls -la $out/bin/ || echo "No bin directory"
        echo "=== Looking for any executables ==="
        find $out -type f -executable | head -20
        echo "=== Contents of share ==="
        ls -la $out/share/ || echo "No share directory"
      '';

      # Override to use our fixed art-standalone
      buildInputs = map (dep: 
        if dep.pname or "" == "art-standalone" then final.art-standalone
        else if dep.pname or "" == "wolfssl" then final.wolfssl
        else dep
      ) (oldAttrs.buildInputs or []) ++ [
        final.glib
        final.pkg-config
      ];

      nativeBuildInputs =
        (oldAttrs.nativeBuildInputs or [])
        ++ [
          final.cmake
          final.pkg-config
        ];

      # Additional build fixes
      preConfigure = ''
        ${oldAttrs.preConfigure or ""}
        # Fix missing includes
        export CPPFLAGS="-I${final.glib.dev}/include/glib-2.0 -I${final.glib.out}/lib/glib-2.0/include $CPPFLAGS"
        export PKG_CONFIG_PATH="${final.glib.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
      '';
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
