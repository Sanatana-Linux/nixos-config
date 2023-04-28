{ config, pkgs, ... }:

{
    input."type:touchpad" = {
      pointer_accel = "10.0";
      natural_scroll = "enabled";
    };
}
