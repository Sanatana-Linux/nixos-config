{
  services = {
    keybase.enable = true;
    poweralertd.enable = true;
    clipse = {
      enable = true;
      allowDuplicates = true;
      historySize = 1000;
      imageDisplay.type = "kitty";
      systemdTarget = "graphical-session.target";
    };
  };
}
