{
  config,
  pkgs,
  ...
}: {
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand";
  };
  services = {
    # thermal sensors and controls
    thermald.enable = true;
    # handle ACPI events
    acpid.enable = true;
    # Disable Power Profiles
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";
      };
    };
    upower = {
      enable = true;
      # Adjusts the action taken at the point of the battery being critical and adjusts when that is
      #criticalPowerAction = "Hibernate";
      percentageLow = 15;
      percentageCritical = 6;
      percentageAction = 5;
      usePercentageForPolicy = true;
    };
  };
}
