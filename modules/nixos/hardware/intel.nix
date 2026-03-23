{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.intel;
in {
  options.modules.hardware.intel = {
    enable = mkEnableOption "Intel CPU and graphics support";

    vaapi = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Intel VA-API video acceleration";
    };

    opencl = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Intel OpenCL compute runtime";
    };

    powerManagement = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Intel CPU power management tools";
    };

    virtualization = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Intel virtualization support (KVM, nested virtualization)";
    };

    enableGVT = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Intel GVT-g graphics virtualization (GPU passthrough support)";
    };
  };

  config = mkIf cfg.enable {
    # Intel initrd modules
    boot.initrd.kernelModules = [
      "intel_cstate" # Intel CPU power states
      "aesni_intel" # AES crypto acceleration
      "intel_uncore" # Intel uncore events
      "intel_uncore_frequency" # Uncore frequency control
      "intel_powerclamp" # Intel Power Clamp driver for thermal throttling
    ];

    boot.kernelModules =
      [
        "i2c-dev" # Userspace I2C access (often needed by DDC/CI tools)
        "i2c-i801" # Intel SMBus driver (common motherboard controller)
        "i915" # Intel graphics
      ]
      ++ optionals cfg.powerManagement [
        "phc-intel" # Intel PHC (Processor Hardware Control)
      ]
      ++ optionals cfg.virtualization [
        "kvm-intel" # Intel KVM virtualization
        "vfio-pci" # VFIO PCI device assignment
      ];

    # Enable Intel CPU frequency driver
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

    # Intel CPU microcode updates
    hardware.cpu.intel.updateMicrocode = true;

    # Intel graphics driver
    hardware.graphics = {
      enable = true;
      extraPackages = mkIf cfg.vaapi (with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ]);
    };

    # Kernel parameters for Intel hardware
    boot.kernelParams =
      [
        "i915.fastboot=1" # Enable fastboot for Intel graphics
        "dev.i915.perf_stream_paranoid=0" # Allow non-root access to performance counters
      ]
      ++ optionals cfg.virtualization [
        "intel_iommu=on" # Enable Intel IOMMU for virtualization
        "iommu=pt" # Use passthrough mode for better performance
        "kvm.ignore_msrs=1" # Ignore unimplemented MSRs
        "kvm_intel.nested=1" # Enable nested virtualization
      ]
      ++ optionals cfg.enableGVT [
        "i915.enable_gvt=1" # Enable Intel GVT-g graphics virtualization
      ];

    # Kernel configuration options
    boot.kernelPatches = [
      {
        name = "intel-config";
        patch = null;
        structuredExtraConfig = with lib.kernel;
          {
            # Intel CPU features
            X86_INTEL_LPSS = yes;
            INTEL_IDLE = yes;
            INTEL_POWERCLAMP = module;
            INTEL_RAPL = module;
            INTEL_TURBO_MAX_3 = yes;
            INTEL_UNCORE_FREQ_CONTROL = yes;

            # Intel graphics
            DRM_I915 = module;
            DRM_I915_GVT = mkIf cfg.enableGVT yes;
            DRM_I915_GVT_KVMGT = mkIf cfg.enableGVT module;
            DRM_I915_USERPTR = yes;

            # Intel virtualization
            KVM_INTEL = mkIf cfg.virtualization module;
            VFIO = mkIf cfg.virtualization module;
            VFIO_PCI = mkIf cfg.virtualization module;
            VFIO_IOMMU_TYPE1 = mkIf cfg.virtualization module;
            # VFIO_VIRQFD removed - auto-configured by kernel based on dependencies

            # Intel IOMMU
            INTEL_IOMMU = mkIf cfg.virtualization yes;
            INTEL_IOMMU_DEFAULT_ON = mkIf cfg.virtualization yes;
            INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON = mkIf cfg.virtualization yes;

            # Intel thermal and power management
            INTEL_PCH_THERMAL = module;
            INTEL_SOC_DTS_IOSF_CORE = module;
            INTEL_SOC_DTS_THERMAL = module;
            INTEL_HFI_THERMAL = yes;

            # Intel MEI (Management Engine Interface)
            INTEL_MEI = module;
            INTEL_MEI_ME = module;
            INTEL_MEI_TXE = module;
            INTEL_MEI_HDCP = module;

            # Intel audio
            SND_HDA_INTEL = module;
            SND_HDA_CODEC_HDMI = module;
            SND_SOC_INTEL_MACH = yes;

            # Intel network
            E1000E = module;
            IXGBE = module;
            I40E = module;
            ICE = module;
          }
          // optionalAttrs cfg.virtualization {
            # Additional virtualization options
            VHOST_NET = module;
            VHOST_VSOCK = module;
            VSOCKETS = module;
          };
      }
    ];

    nixpkgs.config.packageOverrides = mkIf cfg.vaapi (pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
    });

    environment.systemPackages = with pkgs;
      [
        # Intel hardware tools
        intelmetool
        inteltool
        inxi
        i2c-tools
      ]
      ++ optionals cfg.vaapi [
        # Video acceleration
        libva-vdpau-driver
        libvdpau-va-gl
      ]
      ++ optionals cfg.opencl [
        # OpenCL compute
        intel-compute-runtime
        intel-gmmlib
        intel-ocl
      ]
      ++ optionals cfg.powerManagement [
        # Power management
        cpufrequtils
        powertop
        intel-undervolt
        undervolt
      ];
  };
}
