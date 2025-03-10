{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.stable-diffusion-webui.forge.cuda # For lllyasviel's fork of AUTOMATIC1111 WebUI
  ];
}
