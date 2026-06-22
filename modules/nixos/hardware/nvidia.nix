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
      description = "GPU temperature target in °C, set via nvidia-smi -gtt at boot. null = disabled. Recommended: 75-85°C.";
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

          nvidia-optical-flow-sdk # Optical flow SDK
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
          cudaPackages.cuda_nvcc
          cudaPackages.libcutensor
          # python312Packages.cuda-bindings  # Let torch-bin handle its own CUDA dependencies
          # python312Packages.pycuda         # Let torch-bin handle its own CUDA dependencies
          tiny-cuda-nn
          cudaPackages.cudatoolkit
          blas
          peakperf
          python312Packages.numpy
          # (python312.withPackages (p:
          #   with p; [
          #     # tensorflowWithCuda  # Temporarily disabled - may be pulling in regular torch
          #     torch-bin # Use binary torch instead of building from source
          #     torchvision-bin # Use binary torchvision instead of building from source
          #   ]))
        ];
    };

    # Kernel params for NVIDIA
    boot.kernelParams = [
      "nvidia_drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_EnableResizableBar=1"
      # GSP firmware disabled: causes GPU instability on Lenovo Legion hybrid setups
      # (Vulkan/PRIME sync hangs, prevents lower power states on open kernel modules)
      "nvidia.NVreg_EnableGpuFirmware=0"
      # PAT (Page Attribute Table) is the modern memory management method — more
      # efficient than legacy MTRR for CPU↔GPU memory transfers (constant in sync mode)
      "nvidia.NVreg_UsePageAttributeTable=1"
      # Skip clearing system memory before GPU use. Minor perf gain, no meaningful
      # security risk on a single-user desktop.
      "nvidia.NVreg_InitializeSystemMemoryAllocations=0"
      "pcie_aspm=on"
      "pcie_aspm.policy=balanced"
    ];

    # Initrd kernel modules for NVIDIA
    # Loaded early to ensure display works during boot/LUKS
    boot.initrd.kernelModules = [
      "nvidia" # Main NVIDIA kernel driver
      "nvidiafb" # NVIDIA framebuffer driver
      "nvidia-drm" # Direct Rendering Manager (DRM) interface
      "nvidia-uvm" # Unified Virtual Memory (required for CUDA)
      "nvidia-modeset" # Kernel modesetting support
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
        nvidiaPersistenced = true;
        dynamicBoost.enable = true;
        forceFullCompositionPipeline = false;

        powerManagement = {
          enable = true;
          finegrained = false;
        };

        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.driver};

        prime = {
          # CRITICAL: Never change to offload mode EVER
          sync.enable = mkForce true;
          offload.enable = mkForce false;

          intelBusId = cfg.prime.intelBusId;
          nvidiaBusId = cfg.prime.nvidiaBusId;
        };
      };
    };

    # nvidia-powerd requires GSP firmware to function — permanently disabled since
    # NVreg_EnableGpuFirmware=0 (GSP off) makes it fail with "Allocate Root client failed 0x6a"
    systemd.services.nvidia-powerd.enable = false;

    # Apply GPU temperature limit via nvidia-smi at boot
    systemd.services.nvidia-temp-limit = mkIf (cfg.gpuTempLimit != null) {
      description = "Set NVIDIA GPU temperature limit to +${toString cfg.gpuTempLimit}°C";
      wantedBy = ["multi-user.target"];
      after = ["nvidia-persistenced.service" "systemd-modules-load.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = with pkgs; [ config.boot.kernelPackages.nvidiaPackages.${cfg.driver} ];
      script = ''
        TEMP_LIMIT=${toString cfg.gpuTempLimit}
        echo "Setting GPU temperature limit to $TEMP_LIMIT°C..."

        # Wait up to 30s for nvidia-smi to become available
        for i in $(seq 1 30); do
          if nvidia-smi -L >/dev/null 2>&1; then
            break
          fi
          echo "Waiting for nvidia-smi (attempt $i/30)..."
          sleep 1
        done

        if nvidia-smi -L >/dev/null 2>&1; then
          nvidia-smi -gtt "$TEMP_LIMIT"
          echo "GPU temperature limit set to $TEMP_LIMIT°C"
        else
          echo "ERROR: nvidia-smi not available after 30s — GPU temp limit NOT applied"
          exit 1
        fi
      '';
    };
  };


}
