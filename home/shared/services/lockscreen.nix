{
  config,
  pkgs,
  lib,
  ...
}: {
  services.betterlockscreen = {
    enable = true;
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
      User = username;
      Type = "simple";
      Environment = "DISPLAY=:0";
      TimeoutSec = "infinity";
      ExecStart = "${lib.getExe betterlockscreen} --lock --dim 25 --blur 0.5 --span";
      ExecStartPost = "${lib.getExe' pkgs.coreutils-full "sleep"} 1";
    };
    wantedBy = [
      "sleep.target"
      "suspend.target"
    ];
  };
}
