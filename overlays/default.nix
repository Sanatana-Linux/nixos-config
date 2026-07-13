{inputs, ...}: {
  additions = final: _prev:
    (import ../pkgs {pkgs = final.pkgs;})
    // {
      firefox-nightly-bin = inputs.firefox-nightly.packages.${final.stdenv.hostPlatform.system}.firefox-nightly-bin;
    };

  modifications = final: prev: {
    # Completely remove torch packages from python312Packages to force use of torch-bin
    # Also disable pipx tests (known upstream assertion failures)
    python312Packages = prev.python312Packages.overrideScope (
      python-final: python-prev:
        builtins.removeAttrs (python-prev
          // {
            pipx = python-prev.pipx.overridePythonAttrs (old: {
              doCheck = false;
              pythonImportsCheck = ["pipx"];
            });
          }) [
          "pytorch-lightning"
          "lightning"
          "onnxruntime"
          "torch"
          "torchvision"
          "torchmetrics"
        ]
    );

    # Disable Python 3.13 ML packages that cause compatibility issues
    # Also fix qemu python package: add missing qemu-qmp runtime dependency
    python313Packages = prev.python313Packages.overrideScope (
      python-final: python-prev:
        builtins.removeAttrs (python-prev
          // {
            qemu = python-prev.qemu.overrideAttrs (old: {
              propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [python-prev.qemu-qmp];
            });
          }) [
          "pytorch-lightning"
          "lightning"
          "onnxruntime"
          "torch"
          "torchvision"
          "torchmetrics"
        ]
    );

    # Python 3.14 qemu fix: add missing qemu-qmp runtime dependency
    python314Packages = prev.python314Packages.overrideScope (
      python-final: python-prev:
        python-prev
        // {
          qemu = python-prev.qemu.overrideAttrs (old: {
            propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [python-prev.qemu-qmp];
          });
        }
    );

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

    # Fix uefi-firmware-parser: missing setuptools-scm build dependency
    uefi-firmware-parser = prev.uefi-firmware-parser.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.python313Packages.setuptools-scm];
    });

    # Handle IOError on sysfs reads gracefully — firmware WMI failures return EINVAL
    # for features like rapidcharge, cpu_oc, power limits that the BIOS doesn't fully implement
    lenovo-legion = prev.lenovo-legion.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
                  # Don't crash the GUI when sysfs reads fail — some features exist but the EC
                  # returns EINVAL (Errno 22) because the BIOS doesn't fully implement the WMI method
                  ${final.python313.interpreter} -c "
          import re
          with open('./legion_linux/legion.py') as f:
              content = f.read()
          # Wrap _read_file_int in try/except
          old = '    def _read_file_int(self, file_path) -> int:\n        return int(self._read_file_str(file_path))'
          new = '    def _read_file_int(self, file_path) -> int:\n        try:\n            return int(self._read_file_str(file_path))\n        except (IOError, ValueError):\n            log.warning(\"Feature _read_file_int failed for %s, returning 0\", file_path)\n            return 0'
          content = content.replace(old, new)
          with open('./legion_linux/legion.py', 'w') as f:
              f.write(content)
          "
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

    # Patches applied after the cachyos kernel overlay — see cachyos-patches below
  };

  # Overlay that runs after the cachyos kernel overlay to patch the lenovo-legion-module
  # for the cachyos kernel. Registered in host configs after inputs.nix-cachyos-kernel.overlays.pinned.
  cachyos-patches = final: prev: {
    cachyosKernels =
      prev.cachyosKernels
      // {
        linuxPackages-cachyos-bore-lto-x86_64-v3 = prev.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3.extend (_kFinal: kPrev: {
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
  };

  stable-packages = final: prev: {
    stable =
      prev
      // {
        inherit
          (import inputs.stable {
            system = final.stdenv.hostPlatform.system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "electron-39.8.10"
              ];
            };
          })
          efitools
          inkscape
          inkscape-with-extensions
          gimp3-with-plugins
          ;
      };
  };
}
