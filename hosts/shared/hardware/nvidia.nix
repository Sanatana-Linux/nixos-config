{
  pkgs,
  config,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.latest; # stable, beta, etc.
in {
  boot = {
    initrd = {
      kernelModules = ["nvidia" "ideapad_laptop"];
    };
    blacklistedKernelModules = ["nouveau"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11];

    kernelParams = [
      # Nvidia dGPU settings
      "nvidia_drm.fbdev=1"
      "nvidia-drm.modeset=1"
    ];
  };

  environment = {
    variable = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "0.75";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia"; # hardware acceleration
      #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      cudatoolkit
      cudaPackages.cutensor
      cudaPackages.cudnn
      cudaPackages.cuda_opencl
      cudaPackages.imex
      cudaPackages.saxpy
      cudaPackages.libnpp
      cudaPackages.cublas
      cudaPackages.libcufft
      cudaPackages.libcudla
      cudaPackages.cuda_gdb
      cudaPackages.cuda
      cudaPackages.nvidia_fs
      cudaPackages.libcurand
      nvidia-container-toolkit
      nvidia-docker
      nvc
      nvtopPackages.nvidia
      nvitop
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    nvidia.acceptLicense = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cudatoolkit"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      dynamicBoost.enable = true;
      powerManagement = {
        enable = true;
        # finegrained = true;
      };
      open = false;
      package = nvidiaDriverChannel;
      prime = {
        # reverseSync ={
        #   enable = true;
        #   setupCommands.enable = true;
        # };
        #
        # ----------------------------
        #
        sync.enable = true;
        allowExternalGpu = true;
        #
        # ----------------------------
        #
        # offload = {
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
        #
        # ----------------------------
        #
        # Multiple uses are available, check the NVIDIA NixOS wiki
        # Use "lspci | grep -E 'VGA|3D'" to get PCI-bus IDs
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidiaDriverChannel
        intel-vaapi-driver
        xorg_sys_opengl
        mlx42
        glfw
        vaapiVdpau
        mesa
        libvdpau-va-gl
        nvidia-vaapi-driver
        intel-media-sdk
        intel-media-driver
        libGL
        libva
        libva-utils
        libvdpau
        nvidia-texture-tools
        mesa
      ];
    };
    services.xserver.videoDrivers = ["nvidia"]; # got problems with nouveau, would give it another try
  };
}
