# Nvidia GPU on NixDS

## Nvidia's Drivers & Wayland 

Despite the widespread adoption of Wayland as the default display server on many Linux distributions, NVIDIA graphics card users often encounter compatibility issues. NVIDIA's proprietary drivers, while offering robust 3D acceleration, frequently struggle with Wayland, leading to visual artifacts, lag, and even system instability. This is primarily due to the differences in how Wayland and the traditional X11 system manage display outputs, with NVIDIA's drivers being optimized for the latter. To mitigate these issues, users often resort to using XWayland, a compatibility layer that runs X11 applications within a Wayland environment, or switch to using the open-source Nouveau driver, which provides basic 3D acceleration but may not offer the same level of performance as NVIDIA's proprietary drivers.

For me, this is fine, as I will be using AwesomeWM until something comes along for Wayland that is a true "window manager framework" the way AwesomeWM is as X11 shandle video memory allocation when
 the system shuts down or reboots.upport will be around for the foreseeable future. If this changes, I would expect these notes to reflect as much as they are ultimately my working notes and mostly intended as my own point of reference, but if third parties find them useful, that's awesome too! I have benefitted from plenty of the same myself, so happy to learn in public to the benefit of all so inclined. 


## Hybrid Nividia Graphics 

Luckily setting up hybrid graphics and arranging how they render and compute tasks on NixOS is, unlike much else related to NixOS, remarkably straight forward and easy to change at one's whim or will. Determining how the hybrid graphics allocate tasks between the dGPU and iGPU requires first that you have some basic boilerplate in your configuration, which for an Intel + Nvidia hybrid set up looks like:

```nix
{pkgs, config, lib}:
let 
    nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.beta; # stable, beta, etc.
in {
  boot.kernelModules = ["nvidia"]
  boot.blacklistedKernelModules = ["nouveau"];
  boot.kernelParams = [
      "nvidia_drm.fbdev=1" # Nvidia Framebuffer Support
      "nvidia-drm.modeset=1" # Nvidia modesetting support
      "nvidia.NVreg_UsePageAttributeTable=1" # Model Specific. Enables PAT
      "nvidia.NVreg_DynamicPowerManagement=0x02" # Model specific. 0x00:off  0x01: performance 0x02: efficiency 

  ]

  environment = {
    variables = {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "0.75";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
      GBM_BACKEND = "nvidia-drm";
  };
    systemPackages = with pkgs; [
      nvtopPackages.nvidia
      nvitop
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    nvidia.acceptLicense = true;
  };
 hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidiaDriverChannel
        nvidia-vaapi-driver
        intel-media-driver
        intel-gmmlib
        libvdpau-va-gl
        libva-utils
        mesa
      ];
    };
     nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      nvidiaPersistenced = true; # persist GPU after suspend
      dynamicBoost.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = false; # referring to nvidia's open source driver and not the Nouveau driver
      package = nvidiaDriverChannel;
      prime = {
        #nvidia_cg_toolkit
        #
        # NOTE See Below Descriptions for the content of this section's options,
        # which are explained in detail. 
        #
        #
        allowExternalGpu = true; # for eGPUs to work 
        #
        # Use "lspci | grep -E 'VGA|3D'" to get PCI-bus IDs
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
  };
}
```

## Reverse Prime Sync 

In a Reverse PRIME setup, the Intel GPU is used as the primary renderer, and the NVIDIA GPU is used as a secondary renderer. The Intel GPU renders the desktop and 2D graphics, while the NVIDIA GPU is used to accelerate 3D graphics and compute tasks. The rendered images from the NVIDIA GPU are then sent to the Intel GPU, which displays the final image on the screen.

```nix
         reverseSync ={
           enable = true;
           setupCommands.enable = true;
         };
```






```nix        
        # ----------------------------
        
        sync.enable = true;
        allowExternalGpu = true;
        
        # ----------------------------
        
       offload = {
         enable = true;
         enableOffloadCmd = true;
       };
        
```
