{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.performance.hugepages;
in {
  options.modules.system.performance.hugepages = {
    enable = mkEnableOption "Huge page support";

    transparentHugePages = mkOption {
      type = types.enum ["always" "madvise" "never"];
      default = "madvise";
      description = ''
        Transparent Huge Pages (THP) policy.
        - `always`: kernel attempts to use huge pages for all allocations
        - `madvise`: only allocations explicitly marked with madvise(MADV_HUGEPAGE)
        - `never`: disable THP entirely
        `madvise` is the recommended desktop default — it avoids the latency
        spikes `always` can cause while still giving huge pages to apps that
        opt in.
      '';
    };

    nrHugepages = mkOption {
      type = types.int;
      default = 0;
      description = "Number of persistent huge pages to reserve at boot (0 = none).";
    };

    nrOvercommitHugepages = mkOption {
      type = types.int;
      default = 0;
      description = "Maximum number of additional huge pages the kernel may allocate on demand (0 = none).";
    };
  };

  config = mkIf cfg.enable {
    # THP policy is set via kernel param so it applies from the earliest boot stage.
    boot.kernelParams = [
      "transparent_hugepage=${cfg.transparentHugePages}"
    ];

    boot.kernel.sysctl = {
      # Persistent huge page pool reserved at boot.
      "vm.nr_hugepages" = cfg.nrHugepages;
      # Allow on-demand huge page allocation up to this cap.
      "vm.nr_overcommit_hugepages" = cfg.nrOvercommitHugepages;
    };
  };
}
