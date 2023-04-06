{ config, pkgs, ... }:
{

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = lib.attrValues {
      inherit (pkgs.luaPackages)
        cjson dkjson ldbus luasec lgi ldoc lpeg luadbi-mysql luaposix argparse
        vicious;
    };
  };

pkgs.xfce.thunar.override {
  thunarPlugins = [
      pkgs.xfce.thunar-volman
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-media-tags-plugin
      ];
  }


}
