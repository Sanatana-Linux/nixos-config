{inputs, ...}: {
  modifications = final: prev: {
    # Handle IOError on sysfs reads gracefully — firmware WMI failures return EINVAL
    # for features like rapidcharge, cpu_oc, power limits that the BIOS doesn't fully implement
    lenovo-legion = prev.lenovo-legion.overrideAttrs (old: {
      postPatch = (old.postPatch or "");
    });
  };
}
