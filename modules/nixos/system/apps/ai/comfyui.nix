{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.system.apps.ai.comfyui = {
    enable = lib.mkEnableOption "ComfyUI Stable Diffusion WebUI";
  };

  config = lib.mkIf config.modules.system.apps.ai.comfyui.enable {
    environment.systemPackages = [
      pkgs.stable-diffusion-webui.forge.cuda # For lllyasviel's fork of AUTOMATIC1111 WebUI
    ];
  };
}
