{inputs, ...}: {
  modifications = final: prev: let
    # Sign out-of-tree kernel modules after install, emitting matching .ko.cer
    # certificates so the kernel modules aggregator doesn't fail on missing certs.
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
    # Out-of-tree modules loaded by the Lenovo hardware modules and by
    # modules.hardware.amd.monitoring need the cert fix
    linuxPackages_xanmod_latest =
      prev.linuxPackages_xanmod_latest.extend
      (_kFinal: kPrev: {
        acpi_call = signModulePackage kPrev.acpi_call;
        lenovo-legion-module = signModulePackage kPrev.lenovo-legion-module;
        ryzen-smu = signModulePackage kPrev.ryzen-smu;
        # Recent nixpkgs ships the XanMod kernel source tarball with the
        # `tools-add-128-bit-integer-types-for-aarch64.patch` already applied.
        # patchPhase then fails with "Reversed patch detected" because it
        # prompts interactively. Drop already-applied patches to work around this.
        kernel = kPrev.kernel.overrideAttrs (old: {
          patches = [];
        });
      });
  };
}
