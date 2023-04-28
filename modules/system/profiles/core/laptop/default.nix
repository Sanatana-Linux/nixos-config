{ config, pkgs, ... }:
{
    services.upower.enable = true;
    security.polkit.enable = true;
    security.rtkit.enable = true;

}
