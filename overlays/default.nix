{inputs, ...}: {
  additions = final: _prev:
    (import ../pkgs {pkgs = final.pkgs;})
    // {
      firefox-nightly-bin = inputs.firefox-nightly.packages.${final.stdenv.hostPlatform.system}.firefox-nightly-bin;
    };

  modifications = final: prev: let
    # Import stable nixpkgs for pinned Python packages
    stable-pkgs = import inputs.stable {
      system = final.stdenv.hostPlatform.system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-39.8.10"];
      };
    };

    # nixpkgs signs out-of-tree modules per module with kmodigest and the kernel
    # modules aggregator expects a <name>.ko.cer beside every .ko. acpi_call and
    # lenovo-legion-module install unsigned .ko files, so the kernel "modules"
    # derivation fails with "cat: ...legion-laptop.ko.cer: No such file".
    # Sign them after install, which also emits the matching certificate.
    signModulePackage = drv:
      drv.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            find "$out/lib/modules" -name '*.ko' -print0 | while IFS= read -r -d "" ko; do
              ${final.kmodigest}/bin/kmodigest "$ko"
            done
          '';
      });
  in {
    # Out-of-tree modules loaded by the Lenovo hardware modules need the cert fix
    linuxPackages_xanmod_latest =
      prev.linuxPackages_xanmod_latest.extend
      (_kFinal: kPrev: {
        acpi_call = signModulePackage kPrev.acpi_call;
        lenovo-legion-module = signModulePackage kPrev.lenovo-legion-module;
      });

    # pipx and anyio fail their own test suites inside the Nix sandbox: pipx
    # wants a writable venv, anyio's TLS and hypothesis plugins need network.
    # Only the checks fail, never the build, so the tests are skipped rather
    # than patched. Overriding changes the derivation, so these two rebuild
    # locally instead of substituting — keep them scoped to just these two.
    python312Packages = prev.python312Packages.overrideScope (
      _python-final: python-prev:
        python-prev
        // {
          pipx = python-prev.pipx.overridePythonAttrs (_: {
            doCheck = false;
            pythonImportsCheck = ["pipx"];
          });
          anyio = python-prev.anyio.overridePythonAttrs (_: {
            doCheck = false;
          });
          # test_performance asserts the SVG path parser finishes in under
          # 0.1 s. That is a wall-clock assertion, and it fails on a loaded
          # build host (measured 0.26 s with four parallel builds) while all
          # 475 behavioural tests pass.
          svgwrite = python-prev.svgwrite.overridePythonAttrs (_: {
            doCheck = false;
          });
        }
    );

    # nix-search CLI from the `nps` flake input; not packaged in nixpkgs.
    nps = inputs.nps.defaultPackage.${prev.stdenv.hostPlatform.system};

    # nixpkgs' typescript-language-server 6.0.2 ships a pnpmDeps hash that no
    # longer reproduces (the FOD aborts). Use the stable-channel 5.3.0 instead.
    typescript-language-server = stable-pkgs.typescript-language-server;

    # fastmcp-slim is marked broken on unstable while upstream fastmcp is not
    # yet compatible with mcp 2.x, which makes mcp-nixos unevaluable there.
    # The stable channel still pairs mcp 1.x with a working fastmcp, and
    # mcp-nixos is the MCP server OpenCode launches by name, so it must stay
    # on PATH.
    mcp-nixos = stable-pkgs.mcp-nixos;

    # yazi plugin that reports file sizes in the preview pane; not in nixpkgs.
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

    # opencv only reaches this system through frei0r (video effects) and
    # nothing here calls cv2.cuda or the dnn CUDA backend — GPU inference runs
    # through ollama-cuda and torch, and the ncnn upscalers use Vulkan. With
    # cudaSupport on, opencv becomes a CUDA variant that no cache carries for
    # nixos-unstable-small revs, so it recompiles through nvcc on every bump
    # for code paths nothing invokes. `opencv` is only an alias of `opencv4`
    # (all-packages.nix: `opencv = opencv4`), so the real attribute is the one
    # to override; with CUDA off this is byte-identical to Hydra's default
    # build and substitutes.
    opencv4 = prev.opencv4.override {
      enableCuda = false;
    };

    # peakperf's GPU path is compiled for compute_50, which CUDA 13 dropped:
    # nvcc aborts with "Unsupported gpu architecture 'compute_50'". The tool
    # benchmarks x86 CPUs, so build the CPU-only variant.
    peakperf = prev.peakperf.override {
      enableCuda = false;
    };

    # Pin ffmpeg-full to stable: ffmpeg's generic.nix enables withCudaNVCC
    # whenever config.cudaSupport is true, so the unstable build of the full
    # variant compiles through nvcc and fails; the stable channel's full
    # variant is prebuilt and substitutes.
    ffmpeg-full = final.stable.ffmpeg-full;

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

    # SillyTavern is tracked from the upstream `staging` branch — the server's
    # development branch, which is always ahead of the newest release tag — so the
    # package builds current upstream instead of a frozen snapshot.
    #
    # Nix pins sources by content, so the branch is captured as `rev = "staging"`
    # plus the hash of whichever commit the branch pointed at when that hash was
    # computed. To move to the current head:
    #
    #   nix hash convert --from nix32 --to sri --hash-algo sha256 \
    #     "$(nix-prefetch-url --unpack --type base32 \
    #        https://github.com/SillyTavern/SillyTavern/archive/refs/heads/staging.tar.gz)"
    #
    # A staging bump that touches package-lock.json also changes the `npmDeps` hash
    # below; build once and copy the value Nix reports for the new source.
    sillytavern = prev.sillytavern.overrideAttrs (oldAttrs: let
      # SillyTavern-CharacterLibrary companion plugin (cl-helper). The server
      # plugin loader only scans <serverDirectory>/plugins, which is read-only
      # in the Nix store, so cl-helper must be baked in at build time. Tracked from
      # the plugin's newest release tag.
      clHelperSrc = final.fetchFromGitHub {
        owner = "Sillyanonymous";
        repo = "SillyTavern-CharacterLibrary";
        tag = "v7.1.0";
        hash = "sha256-O26ROGIeKmIhlbImO1eGLi2vR+N+5kNcSfn+2JkcJQ4=";
      };
    in rec {
      pname = "sillytavern";
      # Staging is unreleased work with no release version to name, so the build is
      # identified by its source hash rather than a hand-maintained version string.
      version = "unstable";
      src = final.fetchFromGitHub {
        owner = "SillyTavern";
        repo = "SillyTavern";
        rev = "staging";
        hash = "sha256-YR9+FpG7F4ypgQNYEYzb8PoITGZnbSihLytwKozpn24=";
      };
      # `npmDepsHash` cannot be overridden here: the upstream package already
      # instantiated its fetchNpmDeps derivation during evaluation, so only replacing
      # `npmDeps` itself re-resolves the hash against this `src`.
      npmDeps = final.fetchNpmDeps {
        inherit src;
        hash = "sha256-wAVmQuchjDXh7sTj8Q7+bJJoYCi7JdvlEeC5G9VtjMU=";
      };
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          mkdir -p $out/lib/node_modules/sillytavern/plugins/cl-helper
          cp -r ${clHelperSrc}/extras/cl-helper/. $out/lib/node_modules/sillytavern/plugins/cl-helper/
        '';
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
          calibre
          ffmpeg-full
          ;
      };
  };
}
