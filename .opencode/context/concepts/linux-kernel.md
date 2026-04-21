# Linux Kernel on NixOS

Core concept: NixOS provides declarative kernel management via `boot.kernelPackages`, `boot.kernelPatches`, `boot.kernelParams`, `boot.kernelModules`, `boot.extraModulePackages`, and `boot.kernel.sysctl`. Custom kernels, patches, and out-of-tree modules are all first-class config options — no manual kernel compilation needed.

Key Points:
- **Select kernel** via `boot.kernelPackages = pkgs.linuxPackages_xanmod_latest` — latest LTS is default. Use `nix repl` tab-completion on `pkgs.linuxPackages` to list all variants (zen, hardened, rt, xanmod, rpi, custom, etc.)
- **Extra kernel modules must match kernel version** — always use `config.boot.kernelPackages` (not `pkgs.linuxPackages`) to select modules for the running kernel: `boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];`
- **SysRq for OOM recovery** — `boot.kernel.sysctl."kernel.sysrq" = 1;` enables magic key shortcuts (Alt+SysRq+f to kill OOM process, e+b for emergency reboot)
- **Kernel patches** via `boot.kernelPatches` with `structuredExtraConfig` using `lib.kernel` option type (yes/no/module/unset). Use `lib.kernel.unset` to explicitly remove config options that conflict
- **Out-of-tree modules** need `hardeningDisable = ["pic" "format"]`, `nativeBuildInputs = kernel.moduleBuildDependencies`, and `INSTALL_MOD_PATH=$(out)` in makeFlags
- **Custom kernel from source** — use `pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_X_Y.override { ... })` or `buildLinux` with custom `structuredExtraConfig`
- **Override kernel packages** — use `linuxPackages.extend (self: super: { pkg = super.pkg.overrideAttrs ...; })` or `kernelPackagesExtensions`

Example:
```nix
# Select kernel (this repo uses xanmod)
boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

# Extra module matching running kernel
boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call rtl88x2bu ];

# Kernel parameters
boot.kernelParams = [ "mitigations=off" "preempt=full" "quiet" "splash" ];

# Sysctl tuning
boot.kernel.sysctl = {
  "kernel.sysrq" = 1;
  "net.ipv4.tcp_ecn" = 1;
  "vm.swappiness" = 10;
};

# Kernel patch with structured config (from this repo's intel.nix)
boot.kernelPatches = [{
  name = "intel-undervolt";
  patch = null;
  structuredExtraConfig = with lib.kernel; {
    INTEL_UNCORE_FREQ = module;
  };
}];

# Override kernel package via overlay
nixpkgs.overlays = [(self: super: {
  linuxPackages_xanmod_latest = prev.linuxPackages_xanmod_latest.extend (_kFinal: kPrev: {
    # custom override
  });
})];
```

Reference: [wiki.nixos.org/wiki/Linux_kernel](https://wiki.nixos.org/wiki/Linux_kernel)