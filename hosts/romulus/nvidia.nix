{
  pkgs,
  config,
  lib,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.beta; # stable, beta, etc.
in {
  environment = {
    variables = {
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
      cudaPackages.saxpy
      cudaPackages.libnpp
      cudaPackages.libcufft
      cudaPackages.nvidia_fs
      nvidia-container-toolkit
      nvidia_cg_toolkit
      nv-codec-headers
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
      };
      open = false;
      package = nvidiaDriverChannel;
      prime = {
        sync.enable = lib.mkForce true;
        offload.enable = lib.mkForce false;
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
        intel-gmmlib
        libvdpau-va-gl
        nvidia-vaapi-driver
        intel-media-driver
        libva-utils
        libvdpau
        nvidia-texture-tools
        mesa
      ];
    };
  };
  services.xserver.videoDrivers = ["nvidia"]; # got problems with nouveau, would give it another try
