{
  pkgs,
  config,
  lib,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.production; # stable, beta, etc.
in {
  environment = {
    variables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
      # Necessary to correctly enable va-api (video codec hardware
      # acceleration). If this isn't set, the libvdpau backend will be
      # picked, and that one doesn't work with most things, including
      # Firefox.
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
      # Required to use va-api it in Firefox. See
      # https://github.com/elFarto/nvidia-vaapi-driver/issues/96
      MOZ_DISABLE_RDD_SANDBOX = "1";
      # It appears that the normal rendering mode is broken on recent
      # nvidia drivers:
      # https://github.com/elFarto/nvidia-vaapi-driver/issues/213#issuecomment-1585584038
      #NVD_BACKEND = "direct";
    };
    systemPackages = with pkgs; [
      cudatoolkit
      nvidia-container-toolkit
      nvidia_cg_toolkit
      nv-codec-headers
      mesa
      nvtopPackages.nvidia
      config.boot.kernelPackages.acpi_call # acpi_call kernel module
      libGLX
      nvidia-texture-tools
      peakperf
      intel-media-driver
      intel-vaapi-driver
      xorg_sys_opengl
      mlx42
      glfw
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
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
        #        nvidiaDriverChannel
        vaapiVdpau
        xorg_sys_opengl
      ];
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      nvidiaPersistenced = false;
      dynamicBoost.enable = true;
      # forceFullCompositionPipeline = true; # fixes screen tearing
      powerManagement = {
        enable = true;
        finegrained = false;
      };
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
