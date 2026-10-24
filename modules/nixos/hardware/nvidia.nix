{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.nvidia;

  # CUDA 13 dropped compute 5.0–7.0 (Maxwell, Pascal, Volta). nixpkgs defaults
  # cudaPackages to 13.x, whose backendStdenv asserts on any requested
  # capability below 7.5. Hosts that still target such a GPU (Pascal here) need
  # a 12.x toolkit, so pin it rather than dropping the capability — dropping it
  # would compile binaries that cannot run on those cards at all.
  cudaNeedsLegacyToolkit =
    cfg.cuda.enable
    && lib.any (capability: versionOlder capability "7.5") cfg.cuda.capabilities;
in {
  options.modules.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA graphics hardware support";

    cuda = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable CUDA toolkit and related packages";
      };
      containerRuntime = mkOption {
        type = types.bool;
        default = false;
        description = "Enable NVIDIA container runtime (libnvidia-container + nvidia-container-toolkit)";
      };
      capabilities = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "CUDA compute capabilities to compile for, e.g. [ \"6.1\" ] for Pascal (GTX 10 series). Empty keeps the nixpkgs default set — which excludes Pascal, so verily set this on Pascal hosts. A capability below 7.5 also swaps the system's CUDA toolkit to 12.9, because CUDA 13 dropped Maxwell, Pascal and Volta entirely.";
      };
    };

    prime = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable NVIDIA PRIME (hybrid Intel-iGPU + NVIDIA-dGPU) with sync
          output. Leave true on hybrid laptops. Set false on a machine whose
          NVIDIA GPU drives every display directly (a desktop with no iGPU),
          where the PRIME bus IDs below do not apply.
        '';
      };
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

    lact = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "LACT GPU monitoring, fan control, and overclocking daemon";
      };
    };

    driver = mkOption {
      type = types.enum ["stable" "latest" "beta" "production" "legacy_580"];
      default = "stable";
      description = "Which NVIDIA driver to use. Use legacy_580 for Maxwell/Pascal/Volta (GeForce GTX 10 series and older) — the 590+ branches no longer support those GPUs.";
    };

    turingOrNewer = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether the GPU is Turing (RTX 20 / GTX 16) or newer. Gates the
        GSP-firmware, runtime-D3 dynamic power management and Resizable BAR
        parameters, none of which exist on Maxwell/Pascal/Volta (GeForce GTX 10
        series and older). Set false for those cards.
      '';
    };

    nvidiaPersistenced = mkOption {
      type = types.bool;
      default = false;
      description = "Run nvidia-persistenced so the driver stays initialised between CUDA jobs. Useful on an always-on compute workstation; keeps the GPU awake, so a little more idle power at the wall.";
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

          # Pin Vulkan to the NVIDIA ICD. Whether PRIME sync or a firmware
          # mux is driving the panel, the loader otherwise enumerates every
          # installed ICD (Intel ANV included) and that order is not
          # contractual — an app taking physical device 0 can land on the
          # iGPU. VK_DRIVER_FILES is the current variable; VK_ICD_FILENAMES
          # is the deprecated name still read by older loaders and apps.
          # Override per-invocation to reach Intel Vulkan, e.g.
          #   VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json <app>
          VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
          VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
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
          egl-wayland
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
        ++ optionals cfg.cuda.containerRuntime [
          # nvidia-container-cli and libnvidia-container, invoked by the runtime
          # hook to inject the driver libraries and devices into a container
          libnvidia-container
          # nvidia-ctk, which generates the CDI specification
          nvidia-container-toolkit
          # nvidia-container-runtime and its hook, in a separate output so the
          # runtime is not dragged in by every consumer of nvidia-ctk. This is the
          # path qemu-base.nix passes to Docker's --add-runtime.
          nvidia-container-toolkit.tools
        ]
        ++ optionals cfg.cuda.enable [
          cudatoolkit
          clinfo # OpenCL info/debug tool
          cudaPackages.cuda_nvcc
          cudaPackages.libcublas
          cudaPackages.libnvjitlink
          tiny-cuda-nn
          cudaPackages.cudatoolkit
          blas
          peakperf
          python312Packages.numpy

          # ── Video/image editing CUDA packages ────────────────────────
          cudaPackages.libnpp # NVIDIA Performance Primitives (image/signal processing)
          cudaPackages.libnvjpeg # GPU JPEG encode/decode — accelerates image workflow
          cudaPackages.libnvjpeg_2k # GPU JPEG2000 encode/decode — pro image editing
          cudaPackages.libcufft # CUDA FFT library — audio/video signal processing

          # CUDA-enabled ffmpeg with NVENC/NVDEC hardware encoding/decoding.
          # Stock ffmpeg already turns on CUDA/NVDEC/NVENC under cudaSupport,
          # and nixpkgs' CUDA jobset builds this exact derivation into the CUDA
          # binary cache, so it substitutes. Overriding it (withUnfree /
          # withCudaNVCC / withNpp) yields a bespoke derivation no cache
          # carries, so ffmpeg rebuilds from source on every update.
          ffmpeg
        ];
    };

    # ── Kernel parameters ──────────────────────────────────────────────
    boot.kernelParams =
      [
        # ── DRM / display ──
        # Provide a kernel framebuffer via nvidia-drm. Required for Wayland
        # and for the console to work before X starts.
        "nvidia_drm.fbdev=1"
        # Enable kernel modesetting via nvidia-drm. Required for PRIME sync,
        # Wayland, and proper multi-monitor support.
        "nvidia-drm.modeset=1"

        # ── Memory / performance (every generation) ──
        # Preserve VRAM allocations across VT switches and suspend/resume.
        # Without this, the GPU clears VRAM on mode switches, destroying
        # the desktop state. Does NOT conflict with nvidia-persistenced —
        # persistenced keeps the kernel module loaded; this preserves the
        # actual framebuffer contents in VRAM.
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        # Use Page Attribute Table (PAT) for CPU↔GPU memory mappings.
        # PAT is the modern replacement for MTRR — more flexible, better
        # performance on CPUs with many cores. MTRR is deprecated.
        "nvidia.NVreg_UsePageAttributeTable=1"
        # Skip zeroing system memory before GPU DMA allocations. The GPU
        # overwrites it immediately anyway. Saves CPU time on every buffer
        # allocation. Safe on a single-user desktop.
        "nvidia.NVreg_InitializeSystemMemoryAllocations=0"
      ]
      # ── Turing and newer only ──
      # GSP firmware, runtime-D3 dynamic power management and Resizable BAR do
      # not exist on Maxwell/Pascal/Volta (GeForce GTX 10 series and older) —
      # the driver ignores them there, so they are only emitted for Turing+.
      ++ optionals cfg.turingOrNewer [
        # Enable GSP (GPU System Processor) firmware. Required for
        # nvidia-powerd, P8 idle states and runtime D3 deep sleep.
        "nvidia.NVreg_EnableGpuFirmware=1"
        # Dynamic power management: 0x02 = coarse-grained (whole-GPU suspend).
        # Required alongside GSP firmware for the GPU to reach P8 at idle.
        "nvidia.NVreg_DynamicPowerManagement=0x02"
        # Enable PCIe Resizable BAR — lets the CPU access the entire GPU
        # framebuffer in one mapping instead of 256MB windows. Improves
        # throughput for large texture transfers.
        "nvidia.NVreg_EnableResizableBar=1"
      ];
    # PCIe ASPM is deliberately not set here. It is a bus-wide policy covering
    # the CPU root ports, the NVMe link and the PCH-attached CNVi WiFi, not a
    # property of the GPU — the GPU's own power states come from the parameters
    # above. policy=powersave additionally permits L1.2, which shows up as
    # periodic CNVi disconnects on idle timers. system/boot.nix is the single
    # owner of these parameters.

    # ── Initrd modules ────────────────────────────────────────────────
    # Loaded early so the display works during boot and LUKS unlock.
    # nvidiafb is deliberately absent: it is the legacy framebuffer driver
    # and conflicts with nvidia-drm's own fbdev (nvidia_drm.fbdev=1).
    boot.initrd.kernelModules = [
      "nvidia" # Main kernel driver
      "nvidia-drm" # DRM/KMS interface
      "nvidia-uvm" # Unified Virtual Memory (CUDA)
      "nvidia-modeset" # Kernel modesetting
    ];

    # ── LACT — GPU monitoring, fan control, and overclocking ───────────
    # services.lact installs the lact GUI and the lactd control daemon
    # together. The daemon owns the privileged socket the GUI talks to;
    # without it the GUI falls back to embedded mode and cannot change
    # clocks, power limits, or fan curves. On NVIDIA it drives the GPU
    # through NVML, reading the driver libraries that
    # hardware.graphics.extraPackages already exposes via
    # /run/opengl-driver/lib.
    services.lact.enable = cfg.lact.enable;

    nixpkgs.overlays = mkIf cudaNeedsLegacyToolkit [
      (final: prev: {cudaPackages = prev.cudaPackages_12_9;})
    ];

    nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = cfg.cuda.enable;
      cudaCapabilities = cfg.cuda.capabilities;
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

    # CUDA 13 dropped Maxwell, Pascal and Volta. Every CUDA consumer in the
    # system — opencv, ollama, the toolkit itself — takes its toolkit from
    # `cudaPackages`, and callPackage bakes that in, so overriding a single
    # package's argument does nothing. Hosts with those cards swap the set.
    # cudaCapabilities still narrows the arch list, so the 12.9 build emits
    # exactly the kernels the card needs.
    nixpkgs.overlays =
      optionals
      (cfg.cuda.enable && any (capability: versionOlder capability "7.5") cfg.cuda.capabilities)
      [(final: prev: {cudaPackages = prev.cudaPackages_12_9;})];

    hardware = {
      nvidia-container-toolkit.enable = cfg.cuda.containerRuntime;
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

        # ── nvidia-persistenced ────────────────────────────────────────
        # Keeps the driver initialised between CUDA jobs so the first kernel
        # launch is not re-paid on every process. Off by default (PRIME-sync
        # laptops keep the GPU active anyway); enable it on an always-on CUDA
        # desktop. Does NOT affect suspend/hibernate — that goes through the
        # kernel PM subsystem, not userspace daemons.
        nvidiaPersistenced = cfg.nvidiaPersistenced;

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
        # mkDefault so a desktop, where the GPU is the sole display
        # adapter, can turn runtime PM off from the host config.
        powerManagement = {
          enable = mkDefault true;
          finegrained = false;
        };

        # ── Open kernel modules ─────────────────────────────────────
        # Use the proprietary nvidia.ko (not the open-source one).
        # The open module fails to communicate with the Lenovo BIOS
        # (PlatformRequestHandler returns NV_ERR_INVALID_DATA for temp
        # targets and power modes), causing GPU memory allocation failures
        # and desktop freezes. Proprietary module works correctly.
        open = false;

        # GSP (GPU System Processor) firmware is a Turing+ feature. Keep it
        # disabled on Maxwell/Pascal/Volta so no GSP firmware is packaged and
        # the driver does not attempt a firmware handshake those GPUs lack.
        gsp.enable = cfg.turingOrNewer;

        package = config.boot.kernelPackages.nvidiaPackages.${cfg.driver};

        # Only configure PRIME on hybrid systems. On a desktop with the
        # NVIDIA GPU as the sole adapter — or a laptop whose firmware mux
        # routes the panel to the dGPU — the Intel bus ID is meaningless
        # and PRIME sync would point X at a non-existent framebuffer.
        prime = mkIf cfg.prime.enable {
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

    # ── X layout when the dGPU drives the panel directly ───────────────
    # With PRIME off, nixpkgs' X driver registration still shapes xorg.conf
    # for hybrid output: the only Screen in the ServerLayout belongs to the
    # Intel modesetting device, and the NVIDIA device is a GPU-screen for
    # PRIME offload with no Screen of its own. When a firmware mux has
    # routed the panel to the dGPU, the iGPU never registers a DRM card and
    # X dies with "no screens found". Rebuild the layout around the NVIDIA
    # Screen instead.
    services.xserver = mkIf (!cfg.prime.enable) {
      serverLayoutSection = ''
        Inactive "Device-nvidia[0]"
        Screen "Screen-nvidia[0]"
      '';
      screenSection = ''
        Option "RandRRotation" "on"
        # nvidia-drm is the KMS driver here, so the driver would let each
        # X client pick a GPU as if this were a hybrid system. With the
        # iGPU absent there is nothing to pick.
        Option "PerProcessGpuPicking" "off"
        # Work around a blank panel on Legion/ADL laptops in dGPU-only
        # mode with GSP firmware: the driver's default vsync mode can
        # leave the mux-routed eDP dark.
        Option "UseSwVsyncForFlip" "on"
      '';
    };

    # ── nvidia-powerd ─────────────────────────────────────────────────
    # Dynamic power management daemon. Requires GSP firmware
    # (NVreg_EnableGpuFirmware=1). Manages GPU clock/power state
    # transitions (P0↔P8), runtime D3, and video memory self-refresh.
  };
}
