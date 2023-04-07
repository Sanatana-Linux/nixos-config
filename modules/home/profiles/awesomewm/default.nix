{ config, pkgs, lib, ... }:
{

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = lib.attrValues {
      inherit (pkgs.luaPackages)
        cjson dkjson ldbus luasec lgi ldoc lpeg luadbi-mysql luaposix argparse
        vicious;
    };
  };



#pkgs.thunar = {
#  enable = true;
#  override = {
#  thunarPlugins = with pkgs.xfce; [
#      thunar-volman
#      thunar-archive-plugin
#      thunar-media-tags-plugin
#      ];
#  };

#};


}
