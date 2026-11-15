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
    # Same cert fix for the standard kernel packages (currently in use).
    linuxPackages_latest =
      prev.linuxPackages_latest.extend
      (_kFinal: kPrev: {
        acpi_call = signModulePackage kPrev.acpi_call;
        lenovo-legion-module = signModulePackage kPrev.lenovo-legion-module;
      });
  };
}
