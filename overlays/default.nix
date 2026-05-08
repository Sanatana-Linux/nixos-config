{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final.pkgs; inherit inputs;};

  modifications = final: prev: {
    # Completely remove torch packages from python312Packages to force use of torch-bin
    python312Packages = prev.python312Packages.overrideScope (
      python-final: python-prev:
        builtins.removeAttrs python-prev [
          "pytorch-lightning"
          "lightning"
          "onnxruntime"
          "torch"
          "torchvision"
          "torchmetrics"
        ]
    );

    # Disable Python 3.13 ML packages that cause compatibility issues
    python313Packages = prev.python313Packages.overrideScope (
      python-final: python-prev:
        builtins.removeAttrs python-prev [
          "pytorch-lightning"
          "lightning"
          "onnxruntime"
          "torch"
          "torchvision"
          "torchmetrics"
        ]
    );

    opencode = final.stdenv.mkDerivation rec {
      pname = "opencode";
      version = "1.14.23";

      src = final.fetchurl {
        url = "https://github.com/anomalyco/opencode/releases/download/v${version}/opencode-linux-x64.tar.gz";
        hash = "sha256-dlgb6qeFtukUmZUqoOsRhaF7FcnGa5Qxu+Rh+KipiTY=";
      };

      sourceRoot = ".";

      dontStrip = true;
      dontPatchELF = true;

      installPhase = ''
        runHook preInstall
        install -Dm755 opencode $out/bin/opencode
        runHook postInstall
      '';

      meta = with final.lib; {
        description = "AI coding agent built for the terminal";
        homepage = "https://github.com/anomalyco/opencode";
        license = licenses.asl20;
        platforms = ["x86_64-linux"];
        mainProgram = "opencode";
      };
    };

    nps = inputs.nps.defaultPackage.${prev.stdenv.hostPlatform.system};

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

    # node2nix = prev.node2nix.overrideAttrs (oldAttrs: {
    #   nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [final.nodejs];
    # });

    efitools = final.stable.efitools;

    libvirt = prev.libvirt.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          rm -f $out/lib/systemd/system/virt-secret-init-encryption.service
        '';
    });

    # Update SillyTavern to latest staging branch commit
    sillytavern = prev.sillytavern.overrideAttrs (oldAttrs: rec {
      pname = "sillytavern";
      version = "unstable-2026-04-09";
      src = final.fetchFromGitHub {
        owner = "SillyTavern";
        repo = "SillyTavern";
        rev = "64e8c8d964c74b72b421ed06f1d5706713edb804";
        hash = "sha256-8xY0ngf4nCqPqGMsnUQWkhHfOgZSBM08NvL/bnVIqCg=";
      };
      npmDepsHash = "sha256-pjBCwOtx5UiZWW7/Tir4KHZAkPgrM2sMDix/g2USDWk=";
      # Force rebuild of npm dependencies
      npmDeps = final.fetchNpmDeps {
        inherit src;
        hash = "sha256-pjBCwOtx5UiZWW7/Tir4KHZAkPgrM2sMDix/g2USDWk=";
      };
    });

    linuxPackages_xanmod_latest = prev.linuxPackages_xanmod_latest.extend (_kFinal: kPrev: {
      lenovo-legion-module = kPrev.lenovo-legion-module.overrideAttrs (oldAttrs: {
        # Bump to latest upstream (main @ 2026-05-07) which has:
        # - N0CN DMI entry (Legion Pro 5 16IRX9) mapped to model_g8cn
        # - NRCN DMI entry (Legion Slim 5 16AHP9)
        # - R3CN DMI entry (LOQ 15IRX10)
        # - Fixed ec_register_offsets_loq_v0 with correct register values
        # - New ec_register_offsets_loq_v1, model_nrcn, model_r3cn
        src = prev.fetchFromGitHub {
          owner = "johnfanv2";
          repo = "LenovoLegionLinux";
          rev = "352cb4b3cfc29ae7cee5b1c7901b2d39445fe7bd";
          hash = "sha256-KhDtdBedsYSH9x/hk5PYfFR9h0x7ZCLqMA2OG6PERf4=";
        };
        version = "unstable-2026-05-07";
        # fetchFromGitHub creates source root named "source", so we need
        # to set sourceRoot to match the kernel_module subdirectory
        sourceRoot = "source/kernel_module";
      });
    });
  };

  stable-packages = final: prev: {
    stable = import inputs.stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
