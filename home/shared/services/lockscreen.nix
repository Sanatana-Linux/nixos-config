{
  config,
  pkgs,
  lib,
  ...
}: {
  services.betterlockscreen = {
    enable = true;
    package = pkgs.betterlockscreen;
    inactiveInterval = "15";
  };

  # Ref: https://github.com/betterlockscreen/betterlockscreen/blob/next/system/betterlockscreen%40.service
  systemd.services.lock = {
    enable = true;
    description = "Lock the screen on resume from suspend";
    before = [
      "sleep.target"
      "suspend.target"
    ];
    serviceConfig = {
      User = config.home.username;
      Type = "simple";
      Environment = "DISPLAY=:0";
      TimeoutSec = "infinity";
      ExecStart = "betterlockscreen --lock --dim 25 --blur 0.5 --span";
      ExecStartPost = "sleep 1";
    };
    wantedBy = [
      "sleep.target"
      "suspend.target"
    ];
  };
}
