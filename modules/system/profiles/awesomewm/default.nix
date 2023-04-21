{ config, pkgs, lib, ... }: {
 services.xserver.displayManager = {
    defaultSession = "none+awesome";
    lightdm = {
      enable = true;
        greeters.enso = {
        enable = true;
        blur = true;
      };
    };
    #autoLogin = {
    #  enable = true;
    #  user = "tlh";
    #};
  };

  services.xserver.xautolock.enable = true;
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = lib.attrValues {
      inherit (pkgs.luaPackages)
        cjson dkjson ldbus luasec lgi ldoc lpeg luadbi-mysql luaposix argparse
        vicious;
    };
  };

}
