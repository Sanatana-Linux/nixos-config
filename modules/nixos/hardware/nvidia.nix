{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA graphics hardware support";

    cuda = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable CUDA toolkit and related packages";
      };
    };

    prime = {
      intelBusId = mkOption {
        type = types.str;
        default = "PCI:00:02:0";
        description = "PCI bus ID of the Intel GPU (use 'lspci | grep VGA')";
      };
      nvidiaBusId = mkOption {
        type = types.str;
        default = "PCI:01:00:0";
        description = "PCI bus ID of the NVIDIA GPU (use 'lspci | grep 3D')";
      };
    };

    driver = mkOption {
      type = types.enum ["stable" "latest" "beta" "production"];
      default = "stable";
      description = "Which NVIDIA driver to use";
    };

    gpuTempLimit = mkOption {
      type = types.nullOr (types.ints.between 30 100);
      default = null;
      description = "GPU temperature target in °C. DEPRECATED — nvidia-smi -gtt is not supported on RTX 4070 Laptop GPU. Kept for compatibility, has no effect.";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      variables =
        {
          # Display scaling
          GDK_SCALE = "1";
          GDK_DPI_SCALE = "1";
          _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";

          # Video acceleration
          LIBVA_DRIVER_NAME = "nvidia";

          # Wayland compatibility
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        }
        // optionalAttrs cfg.cuda.enable {
          CUDA_PATH = "${pkgs.cudatoolkit}";
          EXTRA_LDFLAGS = "-L/lib -L${config.boot.kernelPackages.nvidiaPackages.${cfg.driver}}/lib";
          EXTRA_CCFLAGS = "-I/usr/include";
        };

      systemPackages = with pkgs;
        [
          # Core GL libraries
          libGL
          libGLU
          libGLX
          libglut
          libglvnd
          # Mesa
          mesa
          mesa_glu
          mesa-gl-headers
          mesa-demos
          # NVIDIA specific
          nvidia-vaapi-driver
          nvidia-texture-tools
          libnvidia-container
          nv-codec-headers
          nvtopPackages.full
          nvidia_cg_toolkit
          nvidia-optical-flow-sdk
          # Vulkan
          vulkan-headers
          vulkan-extension-layer
          vulkan-helper
          vulkan-loader
          vulkan-tools
          vulkan-utility-libraries
          vkd3d
          vk-bootstrap
          # Additional graphics libraries
          eglexternalplatform
          freeglut
          ftgl
          gegl
          glew
          glee
          glfw
          libva-vdpau-driver
          libvdpau-va-gl
          mlx42
          xorg_sys_opengl
          zenith-nvidia
          kompute
        ]
        ++ optionals cfg.cuda.enable [
          cudatoolkit
          nvidia-container-toolkit
          cudaPackages.cuda_opencl
          cudaPackages.cuda_nvcc
          cudaPackages.libcublas
          cudaPackages.libnvjitlink
          cudaPackages.nvidia_fs
          cudaPackages.libcutensor
          tiny-cuda-nn
          cudaPackages.cudatoolkit
          blas
          peakperf
          python312Packages.numpy
        ];
    };

    # ── Kernel parameters ──────────────────────────────────────────────
    boot.kernelParams = [
      # ── DRM / display ──
      # Provide a kernel framebuffer via nvidia-drm. Required for Wayland
      # and for the console to work before X starts.
      "nvidia_drm.fbdev=1"
      # Enable kernel modesetting via nvidia-drm. Required for PRIME sync,
      # Wayland, and proper multi-monitor support.
      "nvidia-drm.modeset=1"

      # ── Memory / performance ──
      # Preserve VRAM allocations across VT switches and suspend/resume.
      # Without this, the GPU clears VRAM on mode switches, destroying
      # the desktop state. Does NOT conflict with nvidia-persistenced —
      # persistenced keeps the kernel module loaded; this preserves the
      # actual framebuffer contents in VRAM.
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      # Enable PCIe Resizable BAR — lets the CPU access the entire GPU
      # framebuffer in one mapping instead of 256MB windows. Improves
      # throughput for large texture transfers.
      "nvidia.NVreg_EnableResizableBar=1"
      # Use Page Attribute Table (PAT) for CPU↔GPU memory mappings.
      # PAT is the modern replacement for MTRR — more flexible, better
      # performance on CPUs with many cores. MTRR is deprecated.
      "nvidia.NVreg_UsePageAttributeTable=1"
      # Skip zeroing system memory before GPU DMA allocations. The GPU
      # overwrites it immediately anyway. Saves CPU time on every buffer
      # allocation. Safe on a single-user desktop.
      "nvidia.NVreg_InitializeSystemMemoryAllocations=0"

      # ── Power management ──
      # Enable GSP (GPU System Processor) firmware. Required for:
      # - nvidia-powerd (dynamic power management)
      # - Lower GPU idle states (P8 instead of P0)
      # - Runtime D3 (deep sleep) when GPU is idle
      # - Video memory self-refresh / power-off
      "nvidia.NVreg_EnableGpuFirmware=1"
      # Dynamic power management: 0x02 = coarse-grained (whole-GPU suspend).
      # Required alongside GSP firmware for the GPU to reach P8 at idle.
      # Without this, the GPU may stay in P0-P4 even with nvidia-powerd running.
      "nvidia.NVreg_DynamicPowerManagement=0x02"
      # Enable PCIe Active State Power Management. Allows the PCIe link
      # to enter lower power states (L0s, L1) when idle. Required for
      # the GPU to reach deep sleep states.
      "pcie_aspm=on"
      # ASPM policy: powersave = aggressively enter low-power link states.
      # On laptops this saves 1-3W at idle with negligible latency impact.
      "pcie_aspm.policy=powersave"
    ];

    # ── Initrd modules ────────────────────────────────────────────────
    # Loaded early so the display works during boot and LUKS unlock.
    boot.initrd.kernelModules = [
      "nvidia" # Main kernel driver
      "nvidiafb" # Framebuffer (console before X)
      "nvidia-drm" # DRM/KMS interface
      "nvidia-uvm" # Unified Virtual Memory (CUDA)
      "nvidia-modeset" # Kernel modesetting
    ];

    nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = cfg.cuda.enable;
      nvidia.acceptLicense = true;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "cudatoolkit"
          "nvidia-powerd"
          "nvidia-persistenced"
          "nvidia-settings"
          "nvidia-x11"
        ];
    };

    hardware = {
      nvidia-container-toolkit.enable = cfg.cuda.enable;
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          glfw
          libva-utils
          libvdpau-va-gl
          mesa
          mesa-gl-headers
          mesa-demos
          mlx42
          nvidia-vaapi-driver
          xorg_sys_opengl
          config.boot.kernelPackages.nvidiaPackages.${cfg.driver}
        ];
      };

      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;

        # ── nvidia-persistenced — OFF ──────────────────────────────────
        # Disabled: with PRIME sync, Xorg/picom keep the GPU active at
        # all times — it will never be idle long enough to enter D3cold
        # at runtime. persistenced is redundant and adds a daemon that
        # can interfere with GPU power state transitions.
        # Does NOT affect suspend/hibernate — that goes through the
        # kernel PM subsystem, not userspace daemons.
        nvidiaPersistenced = false;

        # ── Dynamic Boost — OFF ────────────────────────────────────────
        # Disabled: nvidia-powerd can pin the GPU at P0 clocks (~30W)
        # even at idle desktop. On PRIME sync systems where the dGPU
        # renders everything continuously, Dynamic Boost has no thermal
        # headroom to shift and only adds polling overhead.
        dynamicBoost.enable = false;

        # ── Composition Pipeline ─────────────────────────────────────
        # Disabled: adds a full-frame buffer that eliminates tearing but
        # costs ~1 frame of latency and ~5-10W of GPU power. PRIME sync
        # handles tear-free output without the power cost.
        forceFullCompositionPipeline = false;

        # ── Runtime power management ─────────────────────────────────
        # finegrained = false: use coarse-grained runtime PM. The GPU
        # suspends as a whole device rather than per-function. More
        # reliable on hybrid laptops where the GPU may be in use by
        # multiple subsystems (X, CUDA, video decode) simultaneously.
        powerManagement = {
          enable = true;
          finegrained = false;
        };

        # ── Open kernel modules ─────────────────────────────────────
        # Use the proprietary nvidia.ko (not the open-source one).
        # The open module fails to communicate with the Lenovo BIOS
        # (PlatformRequestHandler returns NV_ERR_INVALID_DATA for temp
        # targets and power modes), causing GPU memory allocation failures
        # and desktop freezes. Proprietary module works correctly.
        open = false;

        package = config.boot.kernelPackages.nvidiaPackages.${cfg.driver};

        prime = {
          # PRIME sync: the NVIDIA GPU renders directly to the Intel
          # framebuffer with no copy. Zero latency, tear-free. Never
          # switch to offload mode — it adds a copy step and breaks
          # seamless desktop composition.
          sync.enable = mkForce true;
          offload.enable = mkForce false;

          intelBusId = cfg.prime.intelBusId;
          nvidiaBusId = cfg.prime.nvidiaBusId;
        };
      };
    };

    # ── nvidia-powerd ─────────────────────────────────────────────────
    # Dynamic power management daemon. Requires GSP firmware
    # (NVreg_EnableGpuFirmware=1). Manages GPU clock/power state
    # transitions (P0↔P8), runtime D3, and video memory self-refresh.
  };
}
