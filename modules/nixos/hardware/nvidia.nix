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
    enable = mkEnableOption "NVIDIA graphics hardware support with CUDA";

    cudaSupport = mkOption {
      type = types.bool;
      default = true;
      description = "Enable CUDA toolkit and related packages";
    };

    gamingOptimizations = mkOption {
      type = types.bool;
      default = false;
      description = "Enable gaming-specific optimizations";
    };

    driver = mkOption {
      type = types.str;
      default = "production";
      description = "Which NVIDIA driver to use (stable, latest, beta, production)";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      variables =
        {
          # Display scaling optimizations
          GDK_SCALE = "1";
          GDK_DPI_SCALE = "1";
          _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";

          # Video acceleration
          LIBVA_DRIVER_NAME = "nvidia";

          # Wayland compatibility
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          WLR_NO_HARDWARE_CURSORS = "1";

          # Firefox optimizations
          MOZ_DISABLE_RDD_SANDBOX = "1";
          NVD_BACKEND = "direct";
        }
        // (mkIf cfg.cudaSupport {
          CUDA_PATH = "${pkgs.cudatoolkit}";
          EXTRA_LDFLAGS = "-L/lib -L${config.boot.kernelPackages.nvidiaPackages.${cfg.driver}}/lib";
          EXTRA_CCFLAGS = "-I/usr/include";
        });

      systemPackages = with pkgs;
        [
          # Core GL libraries
          libGL
          libGLU
          libGLX
          libglut
          libglvnd

          # Mesa and related
          mesa
          mesa_glu
          mesa-gl-headers
          mesa-demos
          intel-media-driver

          # NVIDIA specific
          nvidia-vaapi-driver
          nvidia-texture-tools
          nvidia-container-toolkit
          libnvidia-container
          nv-codec-headers
          nvtopPackages.nvidia
          nvidia_cg_toolkit

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
        ++ optionals cfg.cudaSupport [
          # CUDA packages
          cudatoolkit
          cudaPackages.libnvjitlink
          cudaPackages.nvidia_fs
          blas
          peakperf
          python313Packages.numpy
          (python312.withPackages (p:
            with p; [
              tensorflowWithCuda
            ]))
        ];
    };

    nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = cfg.cudaSupport;
      nvidia.acceptLicense = true;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "cudatoolkit"
          "nvidia-powerd"
          "nvidia-persistenced"
          "nvidia-settings"
          "nvidiaPackags.stable"
        ];
    };

    hardware = {
      nvidia-container-toolkit.enable = cfg.cudaSupport;
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
        forceFullCompositionPipeline = true;
        dynamicBoost.enable = true;

        powerManagement = {
          # Experimental power management
          enable = false;
          finegrained = false;
        };

        # Use proprietary driver (open source driver is still alpha quality)
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.driver};

        prime = {
          sync.enable = mkForce true;
          offload.enable = mkForce false;

          # Use "lspci | grep -E 'VGA|3D'" to get PCI-bus IDs
          intelBusId = "PCI:00:02:0";
          nvidiaBusId = "PCI:01:00:0";
        };
      };
    };
  };
}
