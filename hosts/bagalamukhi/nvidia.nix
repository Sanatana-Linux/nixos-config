{
  pkgs,
  config,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.latest; # stable, beta, etc.
in {
  environment = {
    variables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "0.75";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia"; # hardware acceleration
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      cudatoolkit
      nvidia-container-toolkit
      nvidia_cg_toolkit
      nv-codec-headers
      mesa
      nvtopPackages.nvidia
      config.boot.kernelPackages.nvidia_x11 # nvidia x11 kernel module
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
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
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
        nvidiaDriverChannel
        vaapiVdpau
        xorg_sys_opengl
      ];
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      #nvidiaPersistenced = true;
      dynamicBoost.enable = true;
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
