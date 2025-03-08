{pkgs, ...}: let
  my-comfyui = pkgs.comfyuiPackages.comfyui.override {
    extensions = [
      pkgs.comfyuiPackages.extensions.acly-inpaint
      pkgs.comfyuiPackages.extensions.acly-tooling
      pkgs.comfyuiPackages.extensions.cubiq-ipadapter-plus
      pkgs.comfyuiPackages.extensions.fannovel16-controlnet-aux
      pkgs.comfyuiPackages.extensions.badcafecode-execution-inversion-demo
      pkgs.comfyuiPackages.extensions.city96-gguf
      pkgs.comfyuiPackages.extensions.cubiq-essentials
      pkgs.comfyuiPackages.extensions.cubiq-instantid
      pkgs.comfyuiPackages.extensions.fannovel16-frame-interpolation
      pkgs.comfyuiPackages.extensions.cubiq-ipadapter-plus
      pkgs.comfyuiPackages.extensions.ellangok-post-processing
      pkgs.comfyuiPackages.extensions.extraltodeus-skimmed-cfg
      pkgs.comfyuiPackages.extensions.fizzledorf-fizz
      pkgs.comfyuiPackages.extensions.florestefano1975-portrait-master
      pkgs.comfyuiPackages.extensions.huchenlei-layerdiffuse
      pkgs.comfyuiPackages.extensions.kijai-supir
      pkgs.comfyuiPackages.extensions.ssitu-ultimate-sd-upscale
      pkgs.comfyuiPackages.extensions.lev145-images-grid
      pkgs.comfyuiPackages.extensions.kosinkadink-video-helper-suite
      pkgs.comfyuiPackages.extensions.kosinkadink-advanced-controlnet
      pkgs.comfyuiPackages.extensions.kijai-ic-light
    ];

    commandLineArgs = [
      "--preview-method"
      "auto"
    ];
  };
in {
  environment.systemPackages = [
    my-comfyui
    pkgs.comfyuiPackages.krita-with-extensions
  ];
}
