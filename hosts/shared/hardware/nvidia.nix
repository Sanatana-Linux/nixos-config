{
  pkgs,
  config,
  lib,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.production; # stable, production, beta, latest
in {
  environment = {
    variables = {
      # Display scaling, I like things nice and compact what can I say?
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
      # Necessary to correctly enable va-api (video codec hardware
      # acceleration). If this isn't set, the libvdpau backend will be
      # picked, and it doesn't work with things like Firefox.
      LIBVA_DRIVER_NAME = "nvidia";
      # Required to run the correct GBM backend for nvidia GPUs on wayland
      GBM_BACKEND = "nvidia-drm";
      # Apparently, without this nouveau may attempt to be used instead
      # (despite it being blacklisted)
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # CUDA Cores Package Location
      CUDA_PATH = "${pkgs.cudatoolkit}";
      EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidiaPackages.production}/lib";
      EXTRA_CCFLAGS = "-I/usr/include";
      # Hardware cursors are currently broken on nvidia
      WLR_NO_HARDWARE_CURSORS = "1";
      # Required to use va-api in Firefox. See
      # https://github.com/elFarto/nvidia-vaapi-driver/issues/96
      MOZ_DISABLE_RDD_SANDBOX = "1";
      # It appears that the normal rendering mode is broken on recent
      # nvidia drivers:
      # https://github.com/elFarto/nvidia-vaapi-driver/issues/213#issuecomment-1585584038
      NVD_BACKEND = "direct";
    };
    systemPackages = with pkgs;
      [
        libGL
        libGLU
        libGLX
        libglut
        libglvnd
        cudaPackages.libnvjitlink
        blas
        cudaPackages.cuda_cccl
        cudaPackages.cuda_cudart
        cudaPackages.cuda_gdb
        cudaPackages.saxpy
        cudaPackages.nvidia_fs
        cudaPackages.cuda_nvml_dev
        cudaPackages.cuda_opencl
        cudaPackages.cuda_sandbox_dev
        cudaPackages.cudatoolkit
        cudaPackages.cuda_sanitizer_api
        cudaPackages.cudnn-frontend
        cudaPackages.cudnn
        cudaPackages.cutensor
        cudaPackages.libcublas
        cudaPackages.libcufile
        cudaPackages.libcusparse
        cudaPackages.libnvidia_nscq
        cudaPackages.libnvjitlink
        cudaPackages.libnvjpeg
        cudatoolkit
        cudaPackages.nvidia_fs
        eglexternalplatform
        freeglut
        ftgl
        gegl
        glew
        glfw
        intel-media-driver
        libGL
        libglut
        libGLX
        libnvidia-container
        libvdpau-va-gl
        mesa
        mlx42
        nv-codec-headers
        nvidia-container-toolkit
        nvidia-texture-tools
        nvidia-vaapi-driver
        nvidia_cg_toolkit
        nvtopPackages.nvidia
        peakperf
        vaapiVdpau
        xorg_sys_opengl
        zenith-nvidia
      ]
      ++ [
        (python312.withPackages (p:
          with p; [
            # torchWithCuda
            tensorflowWithCuda
            triton-cuda
            pycuda
            cupy
          ]))
      ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    nvidia.acceptLicense = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cudatoolkit"
        "nvidia-powerd"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidiaPackags.production"
      ];
  };
  hardware = {
    nvidia-container-toolkit.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        glfw
        intel-vaapi-driver
        libva-utils
        libvdpau-va-gl
        mesa
        mlx42
        nvidia-vaapi-driver
        nvidiaDriverChannel
        vaapiVdpau
        xorg_sys_opengl
      ];
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      #  forceFullCompositionPipeline = true;
      dynamicBoost.enable = true;
      powerManagement = {
        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        enable = true;
        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        finegrained = false;
      };
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
      package = nvidiaDriverChannel;
      prime = {
        reverseSync = {
          enable = lib.mkForce true;
          setupCommands.enable = lib.mkForce true; # requires a dm with xsetupcommands ie sddm lightdm or gdm
        };
        #   sync.enable = true;
        offload.enable = lib.mkForce false;
        # Multiple uses are available, check the NVIDIA NixOS wiki
        # Use "lspci | grep -E 'VGA|3D'" to get PCI-bus IDs
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };
}
