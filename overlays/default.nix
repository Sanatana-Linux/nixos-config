# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    nps = inputs.nps.defaultPackage.${prev.stdenv.hostPlatform.system};

    # what-size.yazi plugin - fetches from GitHub
    what-size = prev.yaziPlugins.mkYaziPlugin {
      pname = "what-size";
      version = "2025-03-07";
      src = final.fetchFromGitHub {
        owner = "pirafrank";
        repo = "what-size.yazi";
        rev = "main";
        hash = "sha256-7q/45TopqbojNRvYDmP9+hgSGPmiyLHBcV051qpOB2Y=";
      };
    };

    # node2nix fails to build in the nixpkgs sandbox because npm is not in
    # nativeBuildInputs of the outer derivation — add nodejs explicitly.
    node2nix = prev.node2nix.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [final.nodejs];
    });

    libvirt = prev.libvirt.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          rm -f $out/lib/systemd/system/virt-secret-init-encryption.service
        '';
    });

    # Override lenovo-legion-module to use a fork that adds the Legion 5
    # 16IRX9 83DG (NMCN BIOS) model to the driver allowlist.
    # https://github.com/jlbyh2o/LenovoLegionLinux/tree/add-legion-5-16irx9-83dg-nmcn
    #    linuxPackages_xanmod_latest = prev.linuxPackages_xanmod_latest.extend (_kFinal: kPrev: {
    #       lenovo-legion-module = kPrev.lenovo-legion-module.overrideAttrs (_oldAttrs: {
    #         src = final.fetchFromGitHub {
    #           owner = "jlbyh2o";
    #           repo = "LenovoLegionLinux";
    #           rev = "4cc42952ad1b6a2d9d69a853ecd5aeb63eb2bcfe";
    #           hash = "sha256-fS2s+x163ATrgi2KW6m/pMeikRNAAInJ69GMBu1Sacs=";
    #         };
    #         sourceRoot = "source/kernel_module";
    #       });
    #     });

    #   linuxPackages_latest = prev.linuxPackages_latest.extend (_kFinal: kPrev: {
    #     lenovo-legion-module = kPrev.lenovo-legion-module.overrideAttrs (_oldAttrs: {
    #       src = final.fetchFromGitHub {
    #         owner = "jlbyh2o";
    #         repo = "LenovoLegionLinux";
    #         rev = "4cc42952ad1b6a2d9d69a853ecd5aeb63eb2bcfe";
    #         hash = "sha256-fS2s+x163ATrgi2KW6m/pMeikRNAAInJ69GMBu1Sacs=";
    #       };
    #       sourceRoot = "source/kernel_module";
    #     });
    #   });
  };

  stable-packages = final: prev: {
    stable = import inputs.stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
