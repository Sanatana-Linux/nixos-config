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
      default = "production";
      description = "Which NVIDIA driver to use";
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
        ++ optionals cfg.cuda.enable [
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
      cudaSupport = cfg.cuda.enable;
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
        dynamicBoost.enable = false;

        powerManagement = {
          enable = true;
          finegrained = false;
        };

        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.driver};

        prime = {
          # CRITICAL: Never change to offload mode - causes display issues
          sync.enable = mkForce true;
          offload.enable = mkForce false;

          intelBusId = cfg.prime.intelBusId;
          nvidiaBusId = cfg.prime.nvidiaBusId;
        };
      };
    };
  };
}
