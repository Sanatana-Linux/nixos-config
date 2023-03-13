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
}
