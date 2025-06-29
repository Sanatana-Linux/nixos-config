{
  config,
  pkgs,
  ...
}: {
  powerManagement = {
    enable = true;
    powertop.enable = true; # Auto tune performance
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
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 60;
        TLP_DEFAULT_MODE = "BAT";
        TLP_PERSISTENT_DEFAULT = 1;
        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi ";
      };
    };
    upower = {
      enable = true;
      # Adjusts the action taken at the point of the battery being critical and adjusts when that is
      criticalPowerAction = "Hibernate";
      percentageLow = 15;
      percentageCritical = 5;
      percentageAction = 4;
      usePercentageForPolicy = true;
    };
  };
}
