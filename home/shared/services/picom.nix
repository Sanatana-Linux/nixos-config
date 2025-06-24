{
  lib,
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    package = pkgs.picom-next;
    # fully override default config (with lib.mkOptionDefault options that exist in default config, but not provided here will still remain defined)
      };
     xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
