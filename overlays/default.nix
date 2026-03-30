{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
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

    linuxPackages_xanmod_latest = prev.linuxPackages_xanmod_latest.extend (_kFinal: kPrev: {
      lenovo-legion-module = kPrev.lenovo-legion-module.overrideAttrs (oldAttrs: {
        postPatch =
          (oldAttrs.postPatch or "")
          + ''
            # Add Legion Pro 5 16IRX9 (N0CN) model config before denylist
            sed -i '/^static const struct dmi_system_id denylist/i \
            // Legion Pro 5 16IRX9 (2023) - Gen 8\
            static const struct model_config model_n0cn = {\
            .registers = \&ec_register_offsets_v0,\
            .check_embedded_controller_id = true,\
            .embedded_controller_id = 0x5507,\
            .memoryio_physical_ec_start = 0xC400,\
            .memoryio_size = 0x300,\
            .has_minifancurve = true,\
            .has_custom_powermode = true,\
            .access_method_powermode = ACCESS_METHOD_WMI,\
            .access_method_keyboard = ACCESS_METHOD_WMI,\
            .access_method_fanspeed = ACCESS_METHOD_WMI3,\
            .access_method_temperature = ACCESS_METHOD_WMI3,\
            .access_method_fancurve = ACCESS_METHOD_WMI3,\
            .access_method_fanfullspeed = ACCESS_METHOD_WMI,\
            .acpi_check_dev = true,\
            .ramio_physical_start = 0xFE0B0400,\
            .ramio_size = 0x600\
            };\
            ' legion-laptop.c

            # Add N0CN to the allowlist (before the sentinel {})
            sed -i '/\.driver_data = (void \*)\&model_nzcn/,/^[[:space:]]*{[[:space:]]*}$/{
            /^[[:space:]]*{[[:space:]]*}$/i\
            {\
            // e.g. Legion Pro 5 16IRX9 (2023) Gen 8\
            .ident = "N0CN",\
            .matches = {\
            DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),\
            DMI_MATCH(DMI_BIOS_VERSION, "N0CN"),\
            },\
            .driver_data = (void *)\&model_n0cn\
            },
            }' legion-laptop.c
          '';
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
